# CRUD de Campeonatos - Flutter BLoC

## Estrutura de Arquivos

```
campeonatos/
├── domain/
│   ├── entities/
│   │   └── campeonato.dart
│   ├── repositories/
│   │   └── campeonato_repository.dart
│   └── usecases/
│       ├── create_campeonato_usecase.dart
│       ├── delete_campeonato_usecase.dart
│       ├── get_campeonato_by_id_usecase.dart
│       ├── get_campeonatos_usecase.dart
│       ├── get_meus_campeonatos_usecase.dart
│       └── update_campeonato_usecase.dart
├── data/
│   ├── models/
│   │   └── campeonato_model.dart
│   ├── datasources/
│   │   └── campeonato_remote_data_source.dart
│   └── repositories/
│       └── campeonato_repository_impl.dart
├── presentation/
│   ├── bloc/
│   │   ├── campeonato_bloc.dart
│   │   ├── campeonato_event.dart
│   │   └── campeonato_state.dart
│   └── pages/
│       ├── campeonatos_list_page.dart
│       ├── campeonato_form_page.dart
│       └── campeonato_detail_page.dart
└── injection_container.dart
```

## Como Integrar no Projeto

### 1. Copiar Arquivos
Copie a pasta `campeonatos_crud` para dentro do diretório do seu projeto, seguindo a estrutura:
```
lib/
├── presentation/
│   └── pages/
│       └── campeonatos/  <- cole aqui
```

### 2. Atualizar main.dart
Adicione a inicialização do módulo de campeonatos no `main.dart`:

```dart
import 'package:eofut/presentation/pages/campeonatos/injection_container.dart' as campeonato_di;

void main() async {
  // ... código existente ...
  
  // Inicializar Dependency Injection
  await auth_di.init();
  await arena_di.init();
  await campeonato_di.init(); // <- ADICIONAR ESTA LINHA
  
  runApp(const MyApp());
}
```

### 3. Criar Tabela no Supabase
Execute este SQL no Supabase para criar a tabela de campeonatos:

```sql
CREATE TABLE campeonatos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nome VARCHAR(200) NOT NULL,
  descricao TEXT NOT NULL,
  data_inicio TIMESTAMP NOT NULL,
  data_fim TIMESTAMP NOT NULL,
  local_arena_id UUID REFERENCES arenas(id),
  organizador_id UUID NOT NULL REFERENCES users(id),
  cidade VARCHAR(100) NOT NULL,
  estado VARCHAR(2) NOT NULL,
  categorias TEXT[] DEFAULT '{}',
  nivel_minimo VARCHAR(50),
  vagas INTEGER NOT NULL,
  valor_inscricao DECIMAL(10,2) NOT NULL,
  status VARCHAR(50) DEFAULT 'aberto',
  premiacao TEXT,
  regras TEXT,
  fotos TEXT[] DEFAULT '{}',
  total_inscritos INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Índices para melhor performance
CREATE INDEX idx_campeonatos_organizador ON campeonatos(organizador_id);
CREATE INDEX idx_campeonatos_cidade ON campeonatos(cidade);
CREATE INDEX idx_campeonatos_status ON campeonatos(status);
CREATE INDEX idx_campeonatos_data_inicio ON campeonatos(data_inicio);

-- Trigger para atualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_campeonatos_updated_at BEFORE UPDATE
  ON campeonatos FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
```

### 4. Row Level Security (RLS) - Opcional mas Recomendado

```sql
-- Habilitar RLS
ALTER TABLE campeonatos ENABLE ROW LEVEL SECURITY;

-- Política: Todos podem ver campeonatos
CREATE POLICY "Campeonatos são visíveis para todos"
  ON campeonatos FOR SELECT
  USING (true);

-- Política: Apenas professores e arenas podem criar
CREATE POLICY "Professores e arenas podem criar campeonatos"
  ON campeonatos FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND tipo_usuario IN ('professor', 'arena')
    )
  );

-- Política: Apenas o criador pode atualizar
CREATE POLICY "Criador pode atualizar seu campeonato"
  ON campeonatos FOR UPDATE
  USING (organizador_id = auth.uid());

-- Política: Apenas o criador pode deletar
CREATE POLICY "Criador pode deletar seu campeonato"
  ON campeonatos FOR DELETE
  USING (organizador_id = auth.uid());
```

## Como Usar

### Listar Todos os Campeonatos
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const CampeonatosListPage(),
  ),
);
```

### Listar Meus Campeonatos (Professor/Arena)
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CampeonatosListPage(
      userId: currentUser.id,
      meusCampeonatos: true,
    ),
  ),
);
```

### Criar Novo Campeonato
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CampeonatoFormPage(
      organizadorId: currentUser.id,
    ),
  ),
);
```

### Ver Detalhes do Campeonato
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CampeonatoDetailPage(
      campeonatoId: campeonatoId,
      canEdit: isMyChampionship,
    ),
  ),
);
```

## Funcionalidades Implementadas

✅ Listar todos os campeonatos
✅ Listar meus campeonatos (criados pelo usuário)
✅ Criar novo campeonato
✅ Editar campeonato
✅ Deletar campeonato
✅ Ver detalhes do campeonato
✅ Buscar/Filtrar campeonatos por cidade, estado e status
✅ Validações de formulário
✅ Mensagens de erro e sucesso
✅ Loading states
✅ Pull-to-refresh

## Próximos Passos (Sugestões)

- [ ] Implementar upload de fotos
- [ ] Implementar inscrições de jogadores
- [ ] Implementar gerenciamento de times/duplas
- [ ] Implementar tabela de jogos
- [ ] Implementar resultados e classificação
- [ ] Notificações push para atualizações
- [ ] Compartilhamento de campeonatos

## Observações

- O módulo segue exatamente o mesmo padrão Clean Architecture + BLoC do resto do projeto
- Todos os arquivos estão prontos para uso
- As dependências já estão no projeto (GetIt, Bloc, Supabase, Dartz, etc)
- O sistema de DI está configurado seguindo o padrão dos outros módulos
