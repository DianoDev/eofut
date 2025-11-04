-- ============================================
-- FutApp - Database Setup Script (MODIFICADO)
-- Execute este script no SQL Editor do Supabase
-- ============================================

-- Ativar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- ============================================
-- TABELA: users (MODIFICADA com tipo_usuario)
-- ============================================
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    firebase_uid VARCHAR(128) UNIQUE,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    tipo_usuario VARCHAR(20) DEFAULT 'jogador' CHECK (tipo_usuario IN ('jogador', 'arena', 'professor')),
    telefone VARCHAR(20),
    foto_url TEXT,
    cidade VARCHAR(100),
    estado VARCHAR(2),
    data_nascimento DATE,
    genero VARCHAR(20),
    bio TEXT,
    rating DECIMAL(3,2) DEFAULT 0,
    total_avaliacoes INTEGER DEFAULT 0,
    
    -- Campos específicos de JOGADOR
    nivel VARCHAR(20) DEFAULT 'iniciante',
    lado_preferido VARCHAR(20) DEFAULT 'ambos',
    ranking INTEGER DEFAULT 1000,
    total_rachas INTEGER DEFAULT 0,
    vitorias INTEGER DEFAULT 0,
    derrotas INTEGER DEFAULT 0,
    posicao_preferida VARCHAR(50),
    nivel_jogo VARCHAR(20),
    
    -- Campos específicos de ARENA
    cnpj VARCHAR(20),
    nome_estabelecimento VARCHAR(200),
    endereco_completo TEXT,
    horario_funcionamento JSONB,
    
    -- Campos específicos de PROFESSOR
    certificacoes JSONB,
    especialidades JSONB,
    valor_hora_aula DECIMAL(10,2),
    experiencia_anos INTEGER,
    
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
    fotos JSONB,
    horario_funcionamento JSONB,
    comodidades JSONB,
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
    nome VARCHAR(50) NOT NULL,
    tipo_piso VARCHAR(30),
    valor_hora DECIMAL(10,2),
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
    quadra_id UUID REFERENCES quadras(id),
    usuario_id UUID REFERENCES users(id),
    data_reserva DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pendente',
    metodo_pagamento VARCHAR(50),
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
    certificacoes JSONB,
    experiencia_anos INTEGER,
    especialidades JSONB,
    valor_hora_aula DECIMAL(10,2),
    descricao TEXT,
    disponibilidade JSONB,
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
    quadra_id UUID REFERENCES quadras(id) NULL,
    data_aula DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    tipo VARCHAR(20) DEFAULT 'particular',
    status VARCHAR(20) DEFAULT 'agendada',
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
    tipo VARCHAR(30),
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
    nome VARCHAR(100) NOT NULL,
    genero VARCHAR(30),
    nivel VARCHAR(30),
    max_duplas INTEGER,
    valor_inscricao DECIMAL(10,2) DEFAULT 0,
    premiacao JSONB,
    status VARCHAR(30) DEFAULT 'inscricoes_abertas',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: inscricoes_campeonato (MODIFICADA)
-- ============================================
CREATE TABLE inscricoes_campeonato (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    categoria_id UUID REFERENCES categorias_campeonato(id),
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
    tipo VARCHAR(30),
    conteudo TEXT,
    midia_url TEXT,
    thumbnail_url TEXT,
    tags JSONB,
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
    juiz_id UUID REFERENCES users(id),
    
    data_racha TIMESTAMP NOT NULL,
    duracao_minutos INTEGER DEFAULT 60,
    
    valor_total DECIMAL(10,2) NOT NULL,
    payment_intent_id VARCHAR(200),
    pagamento_status VARCHAR(30) DEFAULT 'pendente',
    
    status VARCHAR(30) DEFAULT 'aguardando_jogadores',
    dupla_vencedora INTEGER,
    placar_dupla1 INTEGER,
    placar_dupla2 INTEGER,
    
    nivel_sugerido VARCHAR(30),
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
    numero_dupla INTEGER NOT NULL,
    jogador1_id UUID REFERENCES users(id) NOT NULL,
    jogador2_id UUID REFERENCES users(id) NOT NULL,
    
    pontos_ranking_ganhos INTEGER DEFAULT 0,
    
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
    nivel_desejado VARCHAR(30),
    lado_desejado VARCHAR(30),
    vagas INTEGER NOT NULL,
    tipo_busca VARCHAR(30) DEFAULT 'parceiro',
    descricao TEXT,
    status VARCHAR(30) DEFAULT 'aberto',
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
    duracao_horas DECIMAL(3,1),
    
    limite_participantes INTEGER NOT NULL,
    participantes_atuais INTEGER DEFAULT 1,
    
    valor_estimado DECIMAL(10,2),
    valor_por_pessoa DECIMAL(10,2),
    
    status VARCHAR(30) DEFAULT 'aberta',
    reserva_id UUID REFERENCES reservas(id) NULL,
    quadra_alocada_id UUID REFERENCES quadras(id) NULL,
    
    metodo_pagamento VARCHAR(50),
    payment_intent_id VARCHAR(200),
    
    nivel_sugerido VARCHAR(30),
    descricao TEXT,
    observacoes TEXT,
    
    data_limite_confirmacao TIMESTAMP,
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
    status VARCHAR(30) DEFAULT 'interessado',
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
    
    status VARCHAR(30) DEFAULT 'interessado',
    valor_pago DECIMAL(10,2) DEFAULT 0,
    pagamento_confirmado BOOLEAN DEFAULT false,
    
    metodo_pagamento VARCHAR(50),
    comprovante_url TEXT,
    
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
    tipo VARCHAR(30),
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
    motivo VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- ÍNDICES PARA PERFORMANCE
-- ============================================
CREATE INDEX idx_users_tipo ON users(tipo_usuario);
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

CREATE POLICY "Users can update own procuras" ON procura_parceiros
    FOR UPDATE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = criador_id));

-- ============================================
-- POLÍTICAS RLS - SOLICITACOES_RACHA
-- ============================================
CREATE POLICY "Anyone can view open solicitacoes" ON solicitacoes_racha
    FOR SELECT USING (status IN ('aberta', 'completa'));

CREATE POLICY "Users can create solicitacoes" ON solicitacoes_racha
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = criador_id));

CREATE POLICY "Users can update own solicitacoes" ON solicitacoes_racha
    FOR UPDATE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = criador_id));

-- ============================================
-- POLÍTICAS RLS - PARTICIPANTES
-- ============================================
CREATE POLICY "Users can view participantes_procura" ON participantes_procura
    FOR SELECT USING (true);

CREATE POLICY "Users can create participantes_procura" ON participantes_procura
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

CREATE POLICY "Users can view participantes_solicitacao" ON participantes_solicitacao
    FOR SELECT USING (true);

CREATE POLICY "Users can create participantes_solicitacao" ON participantes_solicitacao
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

-- ============================================
-- POLÍTICAS RLS - PROFESSORES
-- ============================================
CREATE POLICY "Anyone can view active professores" ON professores
    FOR SELECT USING (ativo = true);

CREATE POLICY "Users can update own professor profile" ON professores
    FOR UPDATE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = user_id));

-- ============================================
-- POLÍTICAS RLS - AULAS
-- ============================================
CREATE POLICY "Users can view own aulas" ON aulas
    FOR SELECT USING (
        auth.uid()::text IN (
            SELECT firebase_uid FROM users WHERE id IN (
                aulas.aluno_id,
                (SELECT user_id FROM professores WHERE id = aulas.professor_id)
            )
        )
    );

CREATE POLICY "Professors can create aulas" ON aulas
    FOR INSERT WITH CHECK (
        auth.uid()::text = (SELECT u.firebase_uid FROM users u JOIN professores p ON p.user_id = u.id WHERE p.id = professor_id)
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

-- ============================================
-- POLÍTICAS RLS - COMENTARIOS
-- ============================================
CREATE POLICY "Anyone can view comentarios" ON comentarios
    FOR SELECT USING (true);

CREATE POLICY "Users can create comentarios" ON comentarios
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

-- ============================================
-- POLÍTICAS RLS - CURTIDAS
-- ============================================
CREATE POLICY "Anyone can view curtidas" ON curtidas
    FOR SELECT USING (true);

CREATE POLICY "Users can create curtidas" ON curtidas
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

CREATE POLICY "Users can delete own curtidas" ON curtidas
    FOR DELETE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

-- ============================================
-- POLÍTICAS RLS - CAMPEONATOS
-- ============================================
CREATE POLICY "Anyone can view campeonatos" ON campeonatos
    FOR SELECT USING (true);

CREATE POLICY "Users can create campeonatos" ON campeonatos
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = organizador_id));

-- ============================================
-- POLÍTICAS RLS - CATEGORIAS_CAMPEONATO
-- ============================================
CREATE POLICY "Anyone can view categorias" ON categorias_campeonato
    FOR SELECT USING (true);

CREATE POLICY "Organizers can manage categorias" ON categorias_campeonato
    FOR ALL USING (
        auth.uid()::text = (
            SELECT u.firebase_uid FROM users u 
            JOIN campeonatos c ON c.organizador_id = u.id 
            WHERE c.id = categorias_campeonato.campeonato_id
        )
    );

-- ============================================
-- POLÍTICAS RLS - INSCRICOES_CAMPEONATO
-- ============================================
CREATE POLICY "Anyone can view inscricoes" ON inscricoes_campeonato
    FOR SELECT USING (true);

CREATE POLICY "Users can create inscricoes" ON inscricoes_campeonato
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = jogador1_id));

-- ============================================
-- POLÍTICAS RLS - AVALIACOES
-- ============================================
CREATE POLICY "Anyone can view avaliacoes" ON avaliacoes
    FOR SELECT USING (true);

CREATE POLICY "Users can create avaliacoes" ON avaliacoes
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = avaliador_id));

-- ============================================
-- POLÍTICAS RLS - NOTIFICACOES
-- ============================================
CREATE POLICY "Users can view own notificacoes" ON notificacoes
    FOR SELECT USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

CREATE POLICY "Users can update own notificacoes" ON notificacoes
    FOR UPDATE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

-- ============================================
-- POLÍTICAS RLS - HISTORICO_RANKING
-- ============================================
CREATE POLICY "Users can view own historico" ON historico_ranking
    FOR SELECT USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

-- ============================================
-- TRIGGERS
-- ============================================

-- Trigger para criar registro de professor automaticamente
CREATE OR REPLACE FUNCTION create_professor_profile()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tipo_usuario = 'professor' THEN
        INSERT INTO professores (
            user_id,
            certificacoes,
            especialidades,
            valor_hora_aula,
            experiencia_anos,
            ativo
        ) VALUES (
            NEW.id,
            NEW.certificacoes,
            NEW.especialidades,
            NEW.valor_hora_aula,
            NEW.experiencia_anos,
            true
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_create_professor_profile
    AFTER INSERT ON users
    FOR EACH ROW
    EXECUTE FUNCTION create_professor_profile();

-- Trigger para criar registro de arena automaticamente
CREATE OR REPLACE FUNCTION create_arena_profile()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tipo_usuario = 'arena' THEN
        INSERT INTO arenas (
            proprietario_id,
            nome,
            endereco,
            cidade,
            estado,
            telefone,
            horario_funcionamento,
            ativo
        ) VALUES (
            NEW.id,
            NEW.nome_estabelecimento,
            NEW.endereco_completo,
            NEW.cidade,
            NEW.estado,
            NEW.telefone,
            NEW.horario_funcionamento,
            true
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_create_arena_profile
    AFTER INSERT ON users
    FOR EACH ROW
    EXECUTE FUNCTION create_arena_profile();

-- Trigger para atualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_arenas_updated_at BEFORE UPDATE ON arenas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_quadras_updated_at BEFORE UPDATE ON quadras
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reservas_updated_at BEFORE UPDATE ON reservas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_professores_updated_at BEFORE UPDATE ON professores
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_rachas_updated_at BEFORE UPDATE ON rachas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_solicitacoes_racha_updated_at BEFORE UPDATE ON solicitacoes_racha
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();