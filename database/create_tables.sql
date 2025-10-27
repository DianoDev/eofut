-- ============================================
-- FutApp - Database Setup Script
-- Execute este script no SQL Editor do Supabase
-- ============================================

-- Ativar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- ============================================
-- TABELA: users
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
    nivel_jogo VARCHAR(20), -- iniciante, intermediario, avancado
    posicao_preferida VARCHAR(50), -- frente, fundo, ambos
    bio TEXT,
    rating DECIMAL(3,2) DEFAULT 0,
    total_avaliacoes INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: arenas
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
    valor_hora DECIMAL(10,2),
    numero_quadras INTEGER DEFAULT 1,
    comodidades JSONB, -- [vestiario, chuveiro, estacionamento, bar]
    rating DECIMAL(3,2) DEFAULT 0,
    total_avaliacoes INTEGER DEFAULT 0,
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: reservas
-- ============================================
CREATE TABLE reservas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    arena_id UUID REFERENCES arenas(id),
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
    UNIQUE(arena_id, data_reserva, hora_inicio)
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
-- TABELA: aulas
-- ============================================
CREATE TABLE aulas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    professor_id UUID REFERENCES professores(id),
    aluno_id UUID REFERENCES users(id),
    arena_id UUID REFERENCES arenas(id) NULL,
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
-- TABELA: campeonatos
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
    categoria VARCHAR(30), -- misto, masculino, feminino
    nivel VARCHAR(30), -- iniciante, intermediario, avancado, aberto
    valor_inscricao DECIMAL(10,2) DEFAULT 0,
    max_duplas INTEGER,
    premiacao JSONB, -- {1o: 1000, 2o: 500, 3o: 250}
    regras TEXT,
    status VARCHAR(30) DEFAULT 'inscricoes_abertas',
    foto_capa TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: inscricoes_campeonato
-- ============================================
CREATE TABLE inscricoes_campeonato (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    campeonato_id UUID REFERENCES campeonatos(id),
    jogador1_id UUID REFERENCES users(id),
    jogador2_id UUID REFERENCES users(id) NULL,
    jogador3_id UUID REFERENCES users(id) NULL,
    jogador4_id UUID REFERENCES users(id) NULL,
    nome_equipe VARCHAR(100),
    status VARCHAR(30) DEFAULT 'pendente',
    pagamento_confirmado BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(campeonato_id, jogador1_id)
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
-- TABELA: procura_parceiros
-- ============================================
CREATE TABLE procura_parceiros (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    criador_id UUID REFERENCES users(id),
    arena_id UUID REFERENCES arenas(id) NULL,
    data_jogo DATE NOT NULL,
    hora_jogo TIME NOT NULL,
    nivel_desejado VARCHAR(30), -- qualquer, iniciante, intermediario, avancado
    vagas INTEGER NOT NULL, -- 1, 2 ou 3
    descricao TEXT,
    status VARCHAR(30) DEFAULT 'aberto', -- aberto, fechado, cancelado
    cidade VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: participantes_racha
-- ============================================
CREATE TABLE participantes_racha (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    racha_id UUID REFERENCES procura_parceiros(id),
    usuario_id UUID REFERENCES users(id),
    status VARCHAR(30) DEFAULT 'confirmado',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(racha_id, usuario_id)
);

-- ============================================
-- TABELA: avaliacoes
-- ============================================
CREATE TABLE avaliacoes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    avaliador_id UUID REFERENCES users(id),
    tipo VARCHAR(30), -- arena, professor, jogador
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
-- ÍNDICES PARA PERFORMANCE
-- ============================================
CREATE INDEX idx_users_cidade_estado ON users(cidade, estado);
CREATE INDEX idx_arenas_cidade_estado ON arenas(cidade, estado);
CREATE INDEX idx_reservas_arena_data ON reservas(arena_id, data_reserva);
CREATE INDEX idx_posts_usuario ON posts(usuario_id, created_at DESC);
CREATE INDEX idx_campeonatos_status ON campeonatos(status, data_inicio);
CREATE INDEX idx_procura_parceiros_status ON procura_parceiros(status, data_jogo);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Ativar RLS nas tabelas
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE arenas ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;
ALTER TABLE professores ENABLE ROW LEVEL SECURITY;
ALTER TABLE aulas ENABLE ROW LEVEL SECURITY;
ALTER TABLE campeonatos ENABLE ROW LEVEL SECURITY;
ALTER TABLE inscricoes_campeonato ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE comentarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE curtidas ENABLE ROW LEVEL SECURITY;
ALTER TABLE procura_parceiros ENABLE ROW LEVEL SECURITY;
ALTER TABLE participantes_racha ENABLE ROW LEVEL SECURITY;
ALTER TABLE avaliacoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE notificacoes ENABLE ROW LEVEL SECURITY;

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
-- POLÍTICAS RLS - RESERVAS
-- ============================================
CREATE POLICY "Users can view own reservas" ON reservas
    FOR SELECT USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

CREATE POLICY "Users can create reservas" ON reservas
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

CREATE POLICY "Users can update own reservas" ON reservas
    FOR UPDATE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

-- ============================================
-- POLÍTICAS RLS - PROCURA_PARCEIROS
-- ============================================
CREATE POLICY "Anyone can view open rachas" ON procura_parceiros
    FOR SELECT USING (status = 'aberto');

CREATE POLICY "Users can create rachas" ON procura_parceiros
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = criador_id));

CREATE POLICY "Creators can update own rachas" ON procura_parceiros
    FOR UPDATE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = criador_id));

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
-- POLÍTICAS RLS - NOTIFICACOES
-- ============================================
CREATE POLICY "Users can view own notifications" ON notificacoes
    FOR SELECT USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

CREATE POLICY "Users can update own notifications" ON notificacoes
    FOR UPDATE USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

-- ============================================
-- STORAGE BUCKETS
-- ============================================
-- Execute no Supabase Storage, não no SQL Editor:
-- 1. Vá em Storage
-- 2. Crie os buckets:
--    - avatars (público)
--    - arena-photos (público)
--    - post-media (público)

-- ============================================
-- ✅ SETUP COMPLETO!
-- ============================================
