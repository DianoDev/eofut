-- ============================================
-- FutApp - Database Setup Script (MODIFICADO)
-- Execute este script no SQL Editor do Supabase
-- ============================================

-- Ativar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- ============================================
-- TABELA: users (MODIFICADA)
-- ============================================
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    firebase_uid VARCHAR(128) UNIQUE,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    foto_url TEXT,
    cidade VARCHAR(100),
    estado VARCHAR(2),
    data_nascimento DATE,
    genero VARCHAR(20),
    
    -- NOVOS CAMPOS PARA RANKING E JOGO
    nivel VARCHAR(20) DEFAULT 'iniciante', -- aprendiz, iniciante, intermediario, avancado
    lado_preferido VARCHAR(20) DEFAULT 'ambos', -- direito, esquerdo, ambos
    ranking INTEGER DEFAULT 1000, -- Sistema ELO ou pontos
    total_rachas INTEGER DEFAULT 0,
    vitorias INTEGER DEFAULT 0,
    derrotas INTEGER DEFAULT 0,
    
    posicao_preferida VARCHAR(50), -- frente, fundo, ambos
    bio TEXT,
    rating DECIMAL(3,2) DEFAULT 0,
    total_avaliacoes INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: arenas (MODIFICADA - sem numero_quadras)
-- ============================================
CREATE TABLE arenas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    proprietario_id UUID REFERENCES users(id),
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    endereco TEXT NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    cep VARCHAR(10),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    telefone VARCHAR(20),
    whatsapp VARCHAR(20),
    fotos JSONB, -- array de URLs
    horario_funcionamento JSONB, -- {seg: "8-22", ter: "8-22"...}
    comodidades JSONB, -- [vestiario, chuveiro, estacionamento, bar]
    rating DECIMAL(3,2) DEFAULT 0,
    total_avaliacoes INTEGER DEFAULT 0,
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: quadras (NOVA)
-- ============================================
CREATE TABLE quadras (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
    nome VARCHAR(50) NOT NULL, -- "Quadra 1", "Quadra Principal", "Quadra da Praia"
    tipo_piso VARCHAR(30), -- areia, grama, sintetico
    valor_hora DECIMAL(10,2), -- pode ter valor diferente por quadra
    coberta BOOLEAN DEFAULT false,
    iluminacao BOOLEAN DEFAULT true,
    ativa BOOLEAN DEFAULT true,
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: reservas (MODIFICADA - referencia quadra)
-- ============================================
CREATE TABLE reservas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    quadra_id UUID REFERENCES quadras(id), -- MUDOU: agora referencia quadra específica
    usuario_id UUID REFERENCES users(id),
    data_reserva DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pendente', -- pendente, confirmada, cancelada, concluida
    metodo_pagamento VARCHAR(50), -- pix, cartao, dinheiro, app
    pagamento_confirmado BOOLEAN DEFAULT false,
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(quadra_id, data_reserva, hora_inicio)
);

-- ============================================
-- TABELA: professores
-- ============================================
CREATE TABLE professores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) UNIQUE,
    certificacoes JSONB, -- array de certificações
    experiencia_anos INTEGER,
    especialidades JSONB, -- [iniciantes, fundamentos, saque, defesa]
    valor_hora_aula DECIMAL(10,2),
    descricao TEXT,
    disponibilidade JSONB, -- {seg: ["8-10", "14-16"], ter: [...]}
    rating DECIMAL(3,2) DEFAULT 0,
    total_avaliacoes INTEGER DEFAULT 0,
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: aulas (MODIFICADA - referencia quadra)
-- ============================================
CREATE TABLE aulas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    professor_id UUID REFERENCES professores(id),
    aluno_id UUID REFERENCES users(id),
    quadra_id UUID REFERENCES quadras(id) NULL, -- pode ser em quadra específica
    data_aula DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    tipo VARCHAR(20) DEFAULT 'particular', -- particular, grupo
    status VARCHAR(20) DEFAULT 'agendada', -- agendada, confirmada, cancelada, concluida
    pagamento_confirmado BOOLEAN DEFAULT false,
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: campeonatos (MODIFICADA - sem campos de categoria)
-- ============================================
CREATE TABLE campeonatos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organizador_id UUID REFERENCES users(id),
    arena_id UUID REFERENCES arenas(id) NULL,
    nome VARCHAR(200) NOT NULL,
    descricao TEXT,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    tipo VARCHAR(30), -- dupla, trio, quarteto
    regras TEXT,
    status VARCHAR(30) DEFAULT 'inscricoes_abertas',
    foto_capa TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: categorias_campeonato (NOVA)
-- ============================================
CREATE TABLE categorias_campeonato (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    campeonato_id UUID REFERENCES campeonatos(id) ON DELETE CASCADE,
    nome VARCHAR(100) NOT NULL, -- "Masculino Intermediário", "Feminino Avançado", "Misto Iniciante"
    genero VARCHAR(30), -- masculino, feminino, misto
    nivel VARCHAR(30), -- aprendiz, iniciante, intermediario, avancado, aberto
    max_duplas INTEGER,
    valor_inscricao DECIMAL(10,2) DEFAULT 0,
    premiacao JSONB, -- {1o: 1000, 2o: 500, 3o: 250}
    status VARCHAR(30) DEFAULT 'inscricoes_abertas',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: inscricoes_campeonato (MODIFICADA)
-- ============================================
CREATE TABLE inscricoes_campeonato (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    categoria_id UUID REFERENCES categorias_campeonato(id), -- MUDOU: agora referencia categoria
    jogador1_id UUID REFERENCES users(id),
    jogador2_id UUID REFERENCES users(id) NULL,
    jogador3_id UUID REFERENCES users(id) NULL,
    jogador4_id UUID REFERENCES users(id) NULL,
    nome_equipe VARCHAR(100),
    status VARCHAR(30) DEFAULT 'pendente',
    pagamento_confirmado BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(categoria_id, jogador1_id)
);

-- ============================================
-- TABELA: posts
-- ============================================
CREATE TABLE posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID REFERENCES users(id),
    tipo VARCHAR(30), -- video, foto, texto, procura_parceiro
    conteudo TEXT,
    midia_url TEXT,
    thumbnail_url TEXT,
    tags JSONB, -- [saque, defesa, jogada]
    curtidas INTEGER DEFAULT 0,
    visualizacoes INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: comentarios
-- ============================================
CREATE TABLE comentarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
    usuario_id UUID REFERENCES users(id),
    conteudo TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: curtidas
-- ============================================
CREATE TABLE curtidas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
    usuario_id UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(post_id, usuario_id)
);

-- ============================================
-- TABELA: rachas (NOVA - Sistema completo de partidas)
-- ============================================
CREATE TABLE rachas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    criador_id UUID REFERENCES users(id),
    quadra_id UUID REFERENCES quadras(id),
    juiz_id UUID REFERENCES users(id), -- NOVO: usuário que arbitra
    
    data_racha TIMESTAMP NOT NULL,
    duracao_minutos INTEGER DEFAULT 60,
    
    -- PAGAMENTO
    valor_total DECIMAL(10,2) NOT NULL, -- valor que as duplas pagarão
    payment_intent_id VARCHAR(200), -- ID do gateway de pagamento
    pagamento_status VARCHAR(30) DEFAULT 'pendente', -- pendente, autorizado, capturado, cancelado, reembolsado
    
    -- RESULTADO
    status VARCHAR(30) DEFAULT 'aguardando_jogadores', -- aguardando_jogadores, completo, em_andamento, aguardando_resultado, finalizado, cancelado
    dupla_vencedora INTEGER, -- 1 ou 2 (definido pelo juiz)
    placar_dupla1 INTEGER,
    placar_dupla2 INTEGER,
    
    nivel_sugerido VARCHAR(30), -- aprendiz, iniciante, intermediario, avancado, aberto
    observacoes TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    finalizado_at TIMESTAMP
);

-- ============================================
-- TABELA: duplas_racha (NOVA)
-- ============================================
CREATE TABLE duplas_racha (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    racha_id UUID REFERENCES rachas(id) ON DELETE CASCADE,
    numero_dupla INTEGER NOT NULL, -- 1 ou 2
    jogador1_id UUID REFERENCES users(id) NOT NULL,
    jogador2_id UUID REFERENCES users(id) NOT NULL,
    
    -- ESTATÍSTICAS E PONTOS
    pontos_ranking_ganhos INTEGER DEFAULT 0, -- pontos que ganharão/perderam no ranking
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CHECK (numero_dupla IN (1, 2)),
    CHECK (jogador1_id != jogador2_id),
    UNIQUE(racha_id, numero_dupla)
);

-- ============================================
-- TABELA: procura_parceiros (MANTIDA - para encontrar parceiros)
-- ============================================
CREATE TABLE procura_parceiros (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    criador_id UUID REFERENCES users(id),
    quadra_id UUID REFERENCES quadras(id) NULL,
    data_jogo DATE NOT NULL,
    hora_jogo TIME NOT NULL,
    nivel_desejado VARCHAR(30), -- qualquer, aprendiz, iniciante, intermediario, avancado
    lado_desejado VARCHAR(30), -- qualquer, direito, esquerdo
    vagas INTEGER NOT NULL, -- quantos jogadores faltam
    tipo_busca VARCHAR(30) DEFAULT 'parceiro', -- parceiro, adversarios, ambos
    descricao TEXT,
    status VARCHAR(30) DEFAULT 'aberto', -- aberto, fechado, cancelado
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: solicitacoes_racha (NOVA - Vaquinha para alugar quadra)
-- ============================================
CREATE TABLE solicitacoes_racha (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    criador_id UUID REFERENCES users(id),
    arena_id UUID REFERENCES arenas(id),
    
    data_jogo DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    duracao_horas DECIMAL(3,1), -- 1.5, 2.0, etc
    
    -- LIMITE E PARTICIPANTES
    limite_participantes INTEGER NOT NULL, -- máximo de pessoas (ex: 4, 6, 8)
    participantes_atuais INTEGER DEFAULT 1, -- começa com o criador
    
    -- VALORES
    valor_estimado DECIMAL(10,2), -- valor estimado do aluguel
    valor_por_pessoa DECIMAL(10,2), -- valor_estimado / limite_participantes
    
    -- STATUS E CONTROLE
    status VARCHAR(30) DEFAULT 'aberta', -- aberta, completa, confirmada, reservada, cancelada, expirada
    reserva_id UUID REFERENCES reservas(id) NULL, -- quando confirmar, cria a reserva
    quadra_alocada_id UUID REFERENCES quadras(id) NULL, -- quadra que foi alocada
    
    -- PAGAMENTO
    metodo_pagamento VARCHAR(50), -- divisao_app, pix_dividido, cada_um_paga
    payment_intent_id VARCHAR(200), -- para pagamento centralizado
    
    nivel_sugerido VARCHAR(30), -- aprendiz, iniciante, intermediario, avancado, aberto
    descricao TEXT,
    observacoes TEXT,
    
    -- PRAZOS
    data_limite_confirmacao TIMESTAMP, -- prazo para todos confirmarem
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CHECK (limite_participantes >= 2),
    CHECK (limite_participantes <= 20)
);

-- ============================================
-- TABELA: participantes_procura (RENOMEADA e MODIFICADA)
-- ============================================
CREATE TABLE participantes_procura (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    procura_id UUID REFERENCES procura_parceiros(id) ON DELETE CASCADE,
    usuario_id UUID REFERENCES users(id),
    status VARCHAR(30) DEFAULT 'interessado', -- interessado, confirmado, recusado
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(procura_id, usuario_id)
);

-- ============================================
-- TABELA: participantes_solicitacao (NOVA)
-- ============================================
CREATE TABLE participantes_solicitacao (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    solicitacao_id UUID REFERENCES solicitacoes_racha(id) ON DELETE CASCADE,
    usuario_id UUID REFERENCES users(id),
    
    status VARCHAR(30) DEFAULT 'interessado', -- interessado, confirmado, pagou, desistiu
    valor_pago DECIMAL(10,2) DEFAULT 0,
    pagamento_confirmado BOOLEAN DEFAULT false,
    
    metodo_pagamento VARCHAR(50), -- pix, cartao, dinheiro
    comprovante_url TEXT, -- URL do comprovante de pagamento
    
    observacoes TEXT,
    confirmado_em TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(solicitacao_id, usuario_id)
);

-- ============================================
-- TABELA: avaliacoes
-- ============================================
CREATE TABLE avaliacoes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    avaliador_id UUID REFERENCES users(id),
    tipo VARCHAR(30), -- arena, professor, jogador, quadra
    referencia_id UUID NOT NULL,
    nota INTEGER CHECK (nota >= 1 AND nota <= 5),
    comentario TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(avaliador_id, tipo, referencia_id)
);

-- ============================================
-- TABELA: notificacoes
-- ============================================
CREATE TABLE notificacoes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID REFERENCES users(id),
    tipo VARCHAR(50),
    titulo VARCHAR(200),
    mensagem TEXT,
    dados JSONB,
    lida BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: historico_ranking (NOVA - para tracking de evolução)
-- ============================================
CREATE TABLE historico_ranking (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID REFERENCES users(id),
    racha_id UUID REFERENCES rachas(id) NULL,
    ranking_anterior INTEGER NOT NULL,
    ranking_novo INTEGER NOT NULL,
    diferenca INTEGER NOT NULL,
    motivo VARCHAR(50), -- vitoria, derrota, ajuste_manual
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- ÍNDICES PARA PERFORMANCE
-- ============================================
CREATE INDEX idx_users_cidade_estado ON users(cidade, estado);
CREATE INDEX idx_users_ranking ON users(ranking DESC);
CREATE INDEX idx_users_nivel ON users(nivel);

CREATE INDEX idx_arenas_cidade_estado ON arenas(cidade, estado);
CREATE INDEX idx_quadras_arena ON quadras(arena_id);

CREATE INDEX idx_reservas_quadra_data ON reservas(quadra_id, data_reserva);

CREATE INDEX idx_rachas_status ON rachas(status);
CREATE INDEX idx_rachas_data ON rachas(data_racha);
CREATE INDEX idx_rachas_quadra ON rachas(quadra_id);
CREATE INDEX idx_duplas_racha_jogadores ON duplas_racha(jogador1_id, jogador2_id);

CREATE INDEX idx_posts_usuario ON posts(usuario_id, created_at DESC);

CREATE INDEX idx_campeonatos_status ON campeonatos(status, data_inicio);
CREATE INDEX idx_categorias_campeonato ON categorias_campeonato(campeonato_id);

CREATE INDEX idx_procura_parceiros_status ON procura_parceiros(status, data_jogo);
CREATE INDEX idx_solicitacoes_status ON solicitacoes_racha(status, data_jogo);
CREATE INDEX idx_solicitacoes_arena ON solicitacoes_racha(arena_id, data_jogo, hora_inicio);
CREATE INDEX idx_participantes_solicitacao ON participantes_solicitacao(solicitacao_id, status);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Ativar RLS nas tabelas
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE arenas ENABLE ROW LEVEL SECURITY;
ALTER TABLE quadras ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;
ALTER TABLE professores ENABLE ROW LEVEL SECURITY;
ALTER TABLE aulas ENABLE ROW LEVEL SECURITY;
ALTER TABLE campeonatos ENABLE ROW LEVEL SECURITY;
ALTER TABLE categorias_campeonato ENABLE ROW LEVEL SECURITY;
ALTER TABLE inscricoes_campeonato ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE comentarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE curtidas ENABLE ROW LEVEL SECURITY;
ALTER TABLE rachas ENABLE ROW LEVEL SECURITY;
ALTER TABLE duplas_racha ENABLE ROW LEVEL SECURITY;
ALTER TABLE procura_parceiros ENABLE ROW LEVEL SECURITY;
ALTER TABLE participantes_procura ENABLE ROW LEVEL SECURITY;
ALTER TABLE solicitacoes_racha ENABLE ROW LEVEL SECURITY;
ALTER TABLE participantes_solicitacao ENABLE ROW LEVEL SECURITY;
ALTER TABLE avaliacoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE notificacoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE historico_ranking ENABLE ROW LEVEL SECURITY;

-- ============================================
-- POLÍTICAS RLS - USERS
-- ============================================
CREATE POLICY "Users can view all profiles" ON users
    FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" ON users
    FOR UPDATE USING (auth.uid()::text = firebase_uid);

CREATE POLICY "Users can insert own profile" ON users
    FOR INSERT WITH CHECK (auth.uid()::text = firebase_uid);

-- ============================================
-- POLÍTICAS RLS - ARENAS
-- ============================================
CREATE POLICY "Anyone can view active arenas" ON arenas
    FOR SELECT USING (ativo = true);

CREATE POLICY "Owners can update own arenas" ON arenas
    FOR UPDATE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = proprietario_id));

CREATE POLICY "Authenticated users can create arenas" ON arenas
    FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

-- ============================================
-- POLÍTICAS RLS - QUADRAS
-- ============================================
CREATE POLICY "Anyone can view active quadras" ON quadras
    FOR SELECT USING (ativa = true);

CREATE POLICY "Arena owners can manage quadras" ON quadras
    FOR ALL USING (
        auth.uid()::text = (
            SELECT u.firebase_uid 
            FROM users u 
            JOIN arenas a ON a.proprietario_id = u.id 
            WHERE a.id = quadras.arena_id
        )
    );

-- ============================================
-- POLÍTICAS RLS - RESERVAS
-- ============================================
CREATE POLICY "Users can view own reservas" ON reservas
    FOR SELECT USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

CREATE POLICY "Users can create reservas" ON reservas
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

CREATE POLICY "Users can update own reservas" ON reservas
    FOR UPDATE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

-- ============================================
-- POLÍTICAS RLS - RACHAS
-- ============================================
CREATE POLICY "Anyone can view rachas" ON rachas
    FOR SELECT USING (true);

CREATE POLICY "Users can create rachas" ON rachas
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = criador_id));

CREATE POLICY "Participants can update rachas" ON rachas
    FOR UPDATE USING (
        auth.uid()::text IN (
            SELECT u.firebase_uid FROM users u WHERE u.id IN (
                criador_id, 
                juiz_id,
                (SELECT jogador1_id FROM duplas_racha WHERE racha_id = rachas.id),
                (SELECT jogador2_id FROM duplas_racha WHERE racha_id = rachas.id)
            )
        )
    );

-- ============================================
-- POLÍTICAS RLS - DUPLAS_RACHA
-- ============================================
CREATE POLICY "Anyone can view duplas" ON duplas_racha
    FOR SELECT USING (true);

CREATE POLICY "Racha creator can add duplas" ON duplas_racha
    FOR INSERT WITH CHECK (
        auth.uid()::text = (SELECT u.firebase_uid FROM users u JOIN rachas r ON r.criador_id = u.id WHERE r.id = racha_id)
    );

-- ============================================
-- POLÍTICAS RLS - PROCURA_PARCEIROS
-- ============================================
CREATE POLICY "Anyone can view open procuras" ON procura_parceiros
    FOR SELECT USING (status = 'aberto');

CREATE POLICY "Users can create procuras" ON procura_parceiros
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = criador_id));

CREATE POLICY "Creators can update own procuras" ON procura_parceiros
    FOR UPDATE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = criador_id));

-- ============================================
-- POLÍTICAS RLS - SOLICITACOES_RACHA
-- ============================================
CREATE POLICY "Anyone can view open solicitacoes" ON solicitacoes_racha
    FOR SELECT USING (status IN ('aberta', 'completa'));

CREATE POLICY "Users can create solicitacoes" ON solicitacoes_racha
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = criador_id));

CREATE POLICY "Creators can update own solicitacoes" ON solicitacoes_racha
    FOR UPDATE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = criador_id));

CREATE POLICY "Participants can view their solicitacoes" ON solicitacoes_racha
    FOR SELECT USING (
        auth.uid()::text IN (
            SELECT u.firebase_uid 
            FROM users u 
            JOIN participantes_solicitacao ps ON ps.usuario_id = u.id 
            WHERE ps.solicitacao_id = solicitacoes_racha.id
        )
    );

-- ============================================
-- POLÍTICAS RLS - PARTICIPANTES_SOLICITACAO
-- ============================================
CREATE POLICY "Anyone can view participants" ON participantes_solicitacao
    FOR SELECT USING (true);

CREATE POLICY "Users can join solicitacoes" ON participantes_solicitacao
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

CREATE POLICY "Users can update own participation" ON participantes_solicitacao
    FOR UPDATE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

CREATE POLICY "Solicitacao creator can manage participants" ON participantes_solicitacao
    FOR UPDATE USING (
        auth.uid()::text = (
            SELECT u.firebase_uid 
            FROM users u 
            JOIN solicitacoes_racha s ON s.criador_id = u.id 
            WHERE s.id = participantes_solicitacao.solicitacao_id
        )
    );

-- ============================================
-- POLÍTICAS RLS - POSTS
-- ============================================
CREATE POLICY "Anyone can view posts" ON posts
    FOR SELECT USING (true);

CREATE POLICY "Users can create posts" ON posts
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

CREATE POLICY "Users can update own posts" ON posts
    FOR UPDATE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

CREATE POLICY "Users can delete own posts" ON posts
    FOR DELETE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

-- ============================================
-- POLÍTICAS RLS - CATEGORIAS CAMPEONATO
-- ============================================
CREATE POLICY "Anyone can view categorias" ON categorias_campeonato
    FOR SELECT USING (true);

CREATE POLICY "Organizers can manage categorias" ON categorias_campeonato
    FOR ALL USING (
        auth.uid()::text = (
            SELECT u.firebase_uid 
            FROM users u 
            JOIN campeonatos c ON c.organizador_id = u.id 
            WHERE c.id = categorias_campeonato.campeonato_id
        )
    );

-- ============================================
-- POLÍTICAS RLS - NOTIFICACOES
-- ============================================
CREATE POLICY "Users can view own notifications" ON notificacoes
    FOR SELECT USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

CREATE POLICY "Users can update own notifications" ON notificacoes
    FOR UPDATE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

-- ============================================
-- POLÍTICAS RLS - HISTORICO_RANKING
-- ============================================
CREATE POLICY "Users can view own ranking history" ON historico_ranking
    FOR SELECT USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

-- ============================================
-- FUNCTIONS ÚTEIS
-- ============================================

-- Função para atualizar ranking após racha
CREATE OR REPLACE FUNCTION atualizar_ranking_pos_racha()
RETURNS TRIGGER AS $$
DECLARE
    dupla_vencedora_rec RECORD;
    dupla_perdedora_rec RECORD;
    k_factor INTEGER := 32; -- Fator K do sistema ELO
    ranking_vencedor_medio INTEGER;
    ranking_perdedor_medio INTEGER;
    probabilidade_vitoria DECIMAL;
    pontos_ganhos INTEGER;
BEGIN
    -- Só executa se o racha foi finalizado e tem vencedor
    IF NEW.status = 'finalizado' AND NEW.dupla_vencedora IS NOT NULL THEN
        
        -- Busca dupla vencedora
        SELECT * INTO dupla_vencedora_rec FROM duplas_racha 
        WHERE racha_id = NEW.id AND numero_dupla = NEW.dupla_vencedora;
        
        -- Busca dupla perdedora
        SELECT * INTO dupla_perdedora_rec FROM duplas_racha 
        WHERE racha_id = NEW.id AND numero_dupla != NEW.dupla_vencedora;
        
        -- Calcula ranking médio de cada dupla
        SELECT AVG(ranking) INTO ranking_vencedor_medio FROM users 
        WHERE id IN (dupla_vencedora_rec.jogador1_id, dupla_vencedora_rec.jogador2_id);
        
        SELECT AVG(ranking) INTO ranking_perdedor_medio FROM users 
        WHERE id IN (dupla_perdedora_rec.jogador1_id, dupla_perdedora_rec.jogador2_id);
        
        -- Calcula probabilidade de vitória (fórmula ELO)
        probabilidade_vitoria := 1.0 / (1.0 + POWER(10, (ranking_perdedor_medio - ranking_vencedor_medio) / 400.0));
        
        -- Calcula pontos ganhos/perdidos
        pontos_ganhos := ROUND(k_factor * (1 - probabilidade_vitoria));
        
        -- Atualiza ranking dos vencedores
        UPDATE users SET 
            ranking = ranking + pontos_ganhos,
            vitorias = vitorias + 1,
            total_rachas = total_rachas + 1
        WHERE id IN (dupla_vencedora_rec.jogador1_id, dupla_vencedora_rec.jogador2_id);
        
        -- Atualiza ranking dos perdedores
        UPDATE users SET 
            ranking = ranking - pontos_ganhos,
            derrotas = derrotas + 1,
            total_rachas = total_rachas + 1
        WHERE id IN (dupla_perdedora_rec.jogador1_id, dupla_perdedora_rec.jogador2_id);
        
        -- Atualiza pontos na tabela duplas_racha
        UPDATE duplas_racha SET pontos_ranking_ganhos = pontos_ganhos
        WHERE id = dupla_vencedora_rec.id;
        
        UPDATE duplas_racha SET pontos_ranking_ganhos = -pontos_ganhos
        WHERE id = dupla_perdedora_rec.id;
        
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para atualizar ranking
CREATE TRIGGER trigger_atualizar_ranking
    AFTER UPDATE ON rachas
    FOR EACH ROW
    WHEN (NEW.status = 'finalizado' AND OLD.status != 'finalizado')
    EXECUTE FUNCTION atualizar_ranking_pos_racha();

-- Função para atualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger de updated_at em tabelas relevantes
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_arenas_updated_at BEFORE UPDATE ON arenas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_quadras_updated_at BEFORE UPDATE ON quadras
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reservas_updated_at BEFORE UPDATE ON reservas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_rachas_updated_at BEFORE UPDATE ON rachas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_solicitacoes_updated_at BEFORE UPDATE ON solicitacoes_racha
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- FUNÇÃO: Atualizar contador de participantes
-- ============================================
CREATE OR REPLACE FUNCTION atualizar_participantes_solicitacao()
RETURNS TRIGGER AS $$
BEGIN
    -- Atualiza o contador de participantes na solicitação
    UPDATE solicitacoes_racha
    SET participantes_atuais = (
        SELECT COUNT(*) FROM participantes_solicitacao
        WHERE solicitacao_id = COALESCE(NEW.solicitacao_id, OLD.solicitacao_id)
        AND status IN ('confirmado', 'pagou')
    ) + 1  -- +1 para incluir o criador
    WHERE id = COALESCE(NEW.solicitacao_id, OLD.solicitacao_id);
    
    -- Se atingiu o limite, marca como completa
    UPDATE solicitacoes_racha
    SET status = 'completa'
    WHERE id = COALESCE(NEW.solicitacao_id, OLD.solicitacao_id)
    AND participantes_atuais >= limite_participantes
    AND status = 'aberta';
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Trigger para atualizar contador ao adicionar/atualizar participante
CREATE TRIGGER trigger_atualizar_participantes_add
    AFTER INSERT OR UPDATE ON participantes_solicitacao
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_participantes_solicitacao();

-- Trigger para atualizar contador ao remover participante
CREATE TRIGGER trigger_atualizar_participantes_remove
    AFTER DELETE ON participantes_solicitacao
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_participantes_solicitacao();

-- ============================================
-- FUNÇÃO: Verificar disponibilidade de quadras
-- ============================================
CREATE OR REPLACE FUNCTION verificar_quadras_disponiveis(
    p_arena_id UUID,
    p_data DATE,
    p_hora_inicio TIME,
    p_hora_fim TIME
)
RETURNS TABLE(
    quadra_id UUID,
    quadra_nome VARCHAR(50),
    disponivel BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        q.id as quadra_id,
        q.nome as quadra_nome,
        NOT EXISTS (
            SELECT 1 FROM reservas r
            WHERE r.quadra_id = q.id
            AND r.data_reserva = p_data
            AND r.status NOT IN ('cancelada')
            AND (
                (r.hora_inicio, r.hora_fim) OVERLAPS (p_hora_inicio, p_hora_fim)
            )
        ) as disponivel
    FROM quadras q
    WHERE q.arena_id = p_arena_id
    AND q.ativa = true
    ORDER BY q.nome;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- FUNÇÃO: Criar reserva automática quando solicitação completa
-- ============================================
CREATE OR REPLACE FUNCTION criar_reserva_solicitacao()
RETURNS TRIGGER AS $$
DECLARE
    v_quadra_id UUID;
    v_reserva_id UUID;
BEGIN
    -- Só executa quando status muda para 'confirmada'
    IF NEW.status = 'confirmada' AND OLD.status != 'confirmada' THEN
        
        -- Busca primeira quadra disponível
        SELECT quadra_id INTO v_quadra_id
        FROM verificar_quadras_disponiveis(
            NEW.arena_id,
            NEW.data_jogo,
            NEW.hora_inicio,
            NEW.hora_fim
        )
        WHERE disponivel = true
        LIMIT 1;
        
        -- Se encontrou quadra disponível, cria a reserva
        IF v_quadra_id IS NOT NULL THEN
            INSERT INTO reservas (
                quadra_id,
                usuario_id,
                data_reserva,
                hora_inicio,
                hora_fim,
                valor,
                status,
                pagamento_confirmado,
                observacoes
            ) VALUES (
                v_quadra_id,
                NEW.criador_id,
                NEW.data_jogo,
                NEW.hora_inicio,
                NEW.hora_fim,
                NEW.valor_estimado,
                'confirmada',
                true,
                'Reserva criada automaticamente via solicitação compartilhada'
            )
            RETURNING id INTO v_reserva_id;
            
            -- Atualiza a solicitação com a reserva e quadra
            NEW.reserva_id := v_reserva_id;
            NEW.quadra_alocada_id := v_quadra_id;
            NEW.status := 'reservada';
        ELSE
            -- Não há quadras disponíveis
            RAISE NOTICE 'Nenhuma quadra disponível para o horário solicitado';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para criar reserva automaticamente
CREATE TRIGGER trigger_criar_reserva_solicitacao
    BEFORE UPDATE ON solicitacoes_racha
    FOR EACH ROW
    WHEN (NEW.status = 'confirmada' AND OLD.status != 'confirmada')
    EXECUTE FUNCTION criar_reserva_solicitacao();

-- ============================================
-- VIEWS ÚTEIS
-- ============================================

-- View para leaderboard (ranking)
CREATE OR REPLACE VIEW leaderboard AS
SELECT 
    u.id,
    u.nome,
    u.foto_url,
    u.cidade,
    u.estado,
    u.nivel,
    u.lado_preferido,
    u.ranking,
    u.total_rachas,
    u.vitorias,
    u.derrotas,
    CASE 
        WHEN u.total_rachas > 0 THEN ROUND((u.vitorias::DECIMAL / u.total_rachas) * 100, 2)
        ELSE 0
    END as percentual_vitorias,
    ROW_NUMBER() OVER (ORDER BY u.ranking DESC) as posicao
FROM users u
WHERE u.total_rachas >= 5 -- Só mostra quem jogou pelo menos 5 rachas
ORDER BY u.ranking DESC;

-- View para estatísticas de quadras
CREATE OR REPLACE VIEW estatisticas_quadras AS
SELECT 
    q.id,
    q.nome,
    q.arena_id,
    a.nome as arena_nome,
    COUNT(DISTINCT r.id) as total_reservas,
    COUNT(DISTINCT ra.id) as total_rachas,
    q.valor_hora,
    q.tipo_piso,
    q.coberta
FROM quadras q
JOIN arenas a ON a.id = q.arena_id
LEFT JOIN reservas r ON r.quadra_id = q.id
LEFT JOIN rachas ra ON ra.quadra_id = q.id
GROUP BY q.id, a.nome;

-- View para solicitações abertas
CREATE OR REPLACE VIEW solicitacoes_abertas AS
SELECT 
    s.id,
    s.arena_id,
    a.nome as arena_nome,
    a.cidade,
    a.estado,
    s.criador_id,
    u.nome as criador_nome,
    u.foto_url as criador_foto,
    s.data_jogo,
    s.hora_inicio,
    s.hora_fim,
    s.limite_participantes,
    s.participantes_atuais,
    (s.limite_participantes - s.participantes_atuais) as vagas_disponiveis,
    s.valor_estimado,
    s.valor_por_pessoa,
    s.nivel_sugerido,
    s.descricao,
    s.status,
    s.created_at,
    -- Lista de participantes confirmados
    (
        SELECT json_agg(json_build_object(
            'id', p.id,
            'usuario_id', p.usuario_id,
            'nome', uu.nome,
            'foto_url', uu.foto_url,
            'status', p.status
        ))
        FROM participantes_solicitacao p
        JOIN users uu ON uu.id = p.usuario_id
        WHERE p.solicitacao_id = s.id
        AND p.status IN ('confirmado', 'pagou')
    ) as participantes
FROM solicitacoes_racha s
JOIN arenas a ON a.id = s.arena_id
JOIN users u ON u.id = s.criador_id
WHERE s.status = 'aberta'
AND s.data_jogo >= CURRENT_DATE
ORDER BY s.data_jogo ASC, s.hora_inicio ASC;

-- View para histórico de solicitações do usuário
CREATE OR REPLACE VIEW minhas_solicitacoes AS
SELECT 
    s.id,
    s.arena_id,
    a.nome as arena_nome,
    s.data_jogo,
    s.hora_inicio,
    s.hora_fim,
    s.limite_participantes,
    s.participantes_atuais,
    s.valor_estimado,
    s.valor_por_pessoa,
    s.status,
    s.quadra_alocada_id,
    q.nome as quadra_nome,
    CASE 
        WHEN s.criador_id = u.id THEN 'criador'
        ELSE 'participante'
    END as papel,
    ps.status as meu_status,
    ps.pagamento_confirmado as meu_pagamento,
    s.created_at
FROM solicitacoes_racha s
JOIN arenas a ON a.id = s.arena_id
LEFT JOIN quadras q ON q.id = s.quadra_alocada_id
CROSS JOIN users u
LEFT JOIN participantes_solicitacao ps ON ps.solicitacao_id = s.id AND ps.usuario_id = u.id
WHERE s.criador_id = u.id OR ps.usuario_id = u.id
ORDER BY s.data_jogo DESC, s.created_at DESC;

-- ============================================
-- DADOS DE EXEMPLO (OPCIONAL)
-- ============================================

-- Inserir alguns níveis de exemplo
COMMENT ON COLUMN users.nivel IS 'Níveis: aprendiz, iniciante, intermediario, avancado';
COMMENT ON COLUMN users.lado_preferido IS 'Lados: direito, esquerdo, ambos';
COMMENT ON COLUMN rachas.status IS 'Status: aguardando_jogadores, completo, em_andamento, aguardando_resultado, finalizado, cancelado';
COMMENT ON COLUMN rachas.pagamento_status IS 'Status pagamento: pendente, autorizado, capturado, cancelado, reembolsado';

-- ============================================
-- STORAGE BUCKETS
-- ============================================
-- Execute no Supabase Storage, não no SQL Editor:
-- 1. Vá em Storage
-- 2. Crie os buckets:
--    - avatars (público)
--    - arena-photos (público)
--    - post-media (público)
--    - quadra-photos (público)

-- ============================================
-- ✅ SETUP COMPLETO!
-- ============================================
-- 
-- PRINCIPAIS MUDANÇAS:
-- 
-- 1. QUADRAS: Agora separadas da arena - cada arena pode ter múltiplas quadras
-- 2. CATEGORIAS CAMPEONATO: Campeonatos podem ter várias categorias (genero + nivel)
-- 3. RANKING: Usuarios têm ranking, total de rachas, vitórias e derrotas
-- 4. LADO PREFERIDO: Usuários podem definir lado direito, esquerdo ou ambos
-- 5. SISTEMA DE RACHA COMPLETO:
--    - Duas duplas (4 jogadores)
--    - Um juiz
--    - Sistema de pagamento integrado
--    - Cálculo automático de ranking usando sistema ELO
--    - Histórico de ranking
-- 6. SOLICITAÇÕES COMPARTILHADAS (NOVO):
--    - Usuários podem criar "vaquinhas" para alugar quadras
--    - Define limite de participantes e valor por pessoa
--    - Sistema de confirmação e pagamento
--    - Reserva criada automaticamente quando completa
--    - Verificação de disponibilidade de quadras
-- 7. VIEWS: Leaderboard, estatísticas de quadras, solicitações abertas
-- 
-- ============================================