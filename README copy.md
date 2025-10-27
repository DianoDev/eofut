# FutApp - Aplicativo de Futevôlei 🏐

Aplicativo completo para jogadores amadores de futevôlei, desenvolvido com Flutter, BLoC e Supabase.

## 🚀 Tecnologias

- **Frontend:** Flutter 3.0+
- **State Management:** BLoC + Equatable
- **Backend:** Supabase (PostgreSQL)
- **Dependency Injection:** GetIt
- **Maps:** Google Maps
- **Arquitetura:** Clean Architecture

## 📋 Pré-requisitos

- Flutter SDK 3.0 ou superior
- Dart SDK 3.0 ou superior
- Conta no Supabase (gratuita)
- Conta no Google Cloud (para Google Maps)

## 🛠️ Setup do Projeto

### 1. Instalar Dependências

```bash
cd futapp
flutter pub get
```

### 2. Configurar Supabase

#### 2.1 Criar Projeto no Supabase

1. Acesse [supabase.com](https://supabase.com)
2. Crie uma conta gratuita
3. Crie um novo projeto
4. Anote a **URL** e a **anon key** do projeto

#### 2.2 Atualizar Credenciais

Edite o arquivo `lib/core/constants/api_constants.dart`:

```dart
static const String supabaseUrl = 'https://seu-projeto.supabase.co';
static const String supabaseAnonKey = 'sua-anon-key-aqui';
```

#### 2.3 Criar Tabelas no Banco

Acesse o SQL Editor no Supabase e execute o script:
`database/create_tables.sql` (veja próxima seção)

### 3. Configurar Google Maps (Opcional - para MVP pode pular)

#### Android
Edite `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="SUA_CHAVE_API_AQUI"/>
```

#### iOS
Edite `ios/Runner/AppDelegate.swift`:

```swift
GMSServices.provideAPIKey("SUA_CHAVE_API_AQUI")
```

### 4. Executar o App

```bash
flutter run
```

## 📊 Scripts SQL do Banco de Dados

Crie um arquivo `database/create_tables.sql` com o seguinte conteúdo e execute no Supabase SQL Editor:

```sql
-- Ativar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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
    nivel_jogo VARCHAR(20),
    posicao_preferida VARCHAR(50),
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
    fotos JSONB,
    horario_funcionamento JSONB,
    valor_hora DECIMAL(10,2),
    numero_quadras INTEGER DEFAULT 1,
    comodidades JSONB,
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
    status VARCHAR(20) DEFAULT 'pendente',
    metodo_pagamento VARCHAR(50),
    pagamento_confirmado BOOLEAN DEFAULT false,
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(arena_id, data_reserva, hora_inicio)
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
    nivel_desejado VARCHAR(30),
    vagas INTEGER NOT NULL,
    descricao TEXT,
    status VARCHAR(30) DEFAULT 'aberto',
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
    tipo VARCHAR(30),
    referencia_id UUID NOT NULL,
    nota INTEGER CHECK (nota >= 1 AND nota <= 5),
    comentario TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(avaliador_id, tipo, referencia_id)
);

-- ============================================
-- ÍNDICES PARA PERFORMANCE
-- ============================================
CREATE INDEX idx_users_cidade_estado ON users(cidade, estado);
CREATE INDEX idx_arenas_cidade_estado ON arenas(cidade, estado);
CREATE INDEX idx_reservas_arena_data ON reservas(arena_id, data_reserva);
CREATE INDEX idx_procura_parceiros_status ON procura_parceiros(status, data_jogo);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Ativar RLS nas tabelas
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE arenas ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;
ALTER TABLE procura_parceiros ENABLE ROW LEVEL SECURITY;
ALTER TABLE participantes_racha ENABLE ROW LEVEL SECURITY;
ALTER TABLE avaliacoes ENABLE ROW LEVEL SECURITY;

-- Políticas para users
CREATE POLICY "Users can view all profiles" ON users
    FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" ON users
    FOR UPDATE USING (auth.uid()::text = firebase_uid);

-- Políticas para arenas
CREATE POLICY "Anyone can view active arenas" ON arenas
    FOR SELECT USING (ativo = true);

-- Políticas para reservas
CREATE POLICY "Users can view own reservas" ON reservas
    FOR SELECT USING (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

CREATE POLICY "Users can create reservas" ON reservas
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = usuario_id));

-- Políticas para procura_parceiros
CREATE POLICY "Anyone can view open rachas" ON procura_parceiros
    FOR SELECT USING (status = 'aberto');

CREATE POLICY "Users can create rachas" ON procura_parceiros
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT firebase_uid FROM users WHERE id = criador_id));
```

## 📁 Estrutura do Projeto

```
lib/
├── core/
│   ├── constants/          # Constantes da aplicação
│   ├── errors/            # Failures e Exceptions
│   ├── network/           # Configuração Supabase
│   └── utils/             # Validadores e Formatadores
├── data/
│   ├── datasources/       # Remote e Local data sources
│   ├── models/            # Models com toJson/fromJson
│   └── repositories/      # Implementação dos repositories
├── domain/
│   ├── entities/          # Entidades do negócio
│   ├── repositories/      # Interfaces dos repositories
│   └── usecases/          # Casos de uso
└── presentation/
    ├── bloc/              # BLoCs (Events, States, Bloc)
    ├── pages/             # Páginas da aplicação
    └── widgets/           # Widgets reutilizáveis
```

## 🎯 Roadmap de Desenvolvimento

### Sprint 1 - Autenticação (ATUAL)
- [x] Setup do projeto
- [x] Configuração Supabase
- [x] Telas de Login e Registro
- [ ] BLoC de Auth
- [ ] Integração com Supabase Auth

### Sprint 2 - Arenas
- [ ] Listagem de arenas
- [ ] Filtros e busca
- [ ] Detalhes da arena
- [ ] Google Maps

### Sprint 3 - Reservas
- [ ] Criar reserva
- [ ] Listar minhas reservas
- [ ] Cancelar reserva

### Sprint 4 - Racha (Procurar Parceiros)
- [ ] Feed de rachas disponíveis
- [ ] Criar racha
- [ ] Participar de racha

## 🧪 Testes

```bash
# Rodar todos os testes
flutter test

# Rodar testes com coverage
flutter test --coverage
```

## 📱 Build

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT.

## 📧 Contato

Seu Nome - seu@email.com

Project Link: [https://github.com/seu-usuario/futapp](https://github.com/seu-usuario/futapp)

---

Desenvolvido com ❤️ e ⚽ para a comunidade de futevôlei
