# 🚀 Próximos Passos - FutApp

Este documento guia você através dos próximos passos de desenvolvimento.

## ✅ O que já está pronto

- [x] Estrutura completa do projeto (Clean Architecture)
- [x] Configuração inicial do Flutter
- [x] Entidades do domínio (User, Arena, Reserva, Racha)
- [x] Interfaces dos repositories
- [x] Validadores e formatadores
- [x] Telas de Login e Registro (UI)
- [x] Configuração do Supabase
- [x] Scripts SQL do banco de dados
- [x] Tema e design system
- [x] Splash screen

## 🎯 Sprint 1 - Autenticação (2 semanas)

### Semana 1 - Backend de Auth

#### Dia 1-2: Data Layer
```bash
# Criar os seguintes arquivos:

1. lib/data/models/user_model.dart
   - Converter User entity para model
   - Implementar fromJson e toJson
   - Usar json_serializable

2. lib/data/datasources/remote/auth_remote_datasource.dart
   - signInWithEmail(email, password)
   - signUpWithEmail(email, password, nome)
   - signOut()
   - getCurrentUser()
   - resetPassword(email)

3. lib/data/datasources/remote/auth_remote_datasource_impl.dart
   - Implementar usando Supabase
   - Tratar exceções
```

**Código exemplo - user_model.dart:**
```dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.nome,
    required super.email,
    super.telefone,
    super.fotoUrl,
    super.cidade,
    super.estado,
    super.dataNascimento,
    super.genero,
    super.nivelJogo,
    super.posicaoPreferida,
    super.bio,
    super.rating,
    super.totalAvaliacoes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      nome: user.nome,
      email: user.email,
      telefone: user.telefone,
      fotoUrl: user.fotoUrl,
      cidade: user.cidade,
      estado: user.estado,
      dataNascimento: user.dataNascimento,
      genero: user.genero,
      nivelJogo: user.nivelJogo,
      posicaoPreferida: user.posicaoPreferida,
      bio: user.bio,
      rating: user.rating,
      totalAvaliacoes: user.totalAvaliacoes,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}
```

#### Dia 3-4: Repository Implementation
```bash
4. lib/data/repositories/auth_repository_impl.dart
   - Implementar AuthRepository
   - Usar Either<Failure, T> do dartz
   - Tratar exceptions e converter em Failures
```

#### Dia 5: Use Cases
```bash
5. lib/domain/usecases/auth/login_usecase.dart
6. lib/domain/usecases/auth/register_usecase.dart
7. lib/domain/usecases/auth/logout_usecase.dart
8. lib/domain/usecases/auth/get_current_user_usecase.dart
```

**Código exemplo - login_usecase.dart:**
```dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) async {
    return await repository.signIn(
      email: email,
      password: password,
    );
  }
}
```

### Semana 2 - BLoC e UI

#### Dia 6-7: Auth BLoC
```bash
9. lib/presentation/bloc/auth/auth_event.dart
10. lib/presentation/bloc/auth/auth_state.dart
11. lib/presentation/bloc/auth/auth_bloc.dart
```

**Código exemplo - auth_event.dart:**
```dart
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String nome;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.nome,
  });

  @override
  List<Object?> get props => [email, password, nome];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
```

**Código exemplo - auth_state.dart:**
```dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
```

#### Dia 8-9: Integrar BLoC com UI
```bash
12. Atualizar lib/presentation/pages/auth/login_page.dart
    - Adicionar BlocProvider
    - Adicionar BlocListener
    - Adicionar BlocBuilder
    - Disparar eventos do BLoC

13. Atualizar lib/presentation/pages/auth/register_page.dart
    - Mesmo processo
```

#### Dia 10: Dependency Injection
```bash
14. Atualizar lib/injection_container.dart
    - Registrar todos os BLoCs
    - Registrar todos os UseCases
    - Registrar todos os Repositories
    - Registrar todos os DataSources
```

**Código exemplo - injection_container.dart atualizado:**
```dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/supabase_config.dart';

// Auth
import 'data/datasources/remote/auth_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/register_usecase.dart';
import 'domain/usecases/auth/logout_usecase.dart';
import 'domain/usecases/auth/get_current_user_usecase.dart';
import 'presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================
  // BLoCs
  // ============================================
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  // ============================================
  // Use Cases
  // ============================================
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // ============================================
  // Repositories
  // ============================================
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // ============================================
  // Data Sources
  // ============================================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: SupabaseConfig.client),
  );

  // ============================================
  // External
  // ============================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => SupabaseConfig.client);
}
```

### ✅ Checklist Sprint 1

- [ ] UserModel criado
- [ ] AuthRemoteDataSource implementado
- [ ] AuthRepository implementado
- [ ] UseCases criados
- [ ] Auth BLoC criado (Events, States, Bloc)
- [ ] Login integrado com BLoC
- [ ] Register integrado com BLoC
- [ ] DI configurado
- [ ] Testado login funcional
- [ ] Testado registro funcional
- [ ] Navegação pós-login

---

## 🎯 Sprint 2 - Arenas (2 semanas)

### Tarefas:
1. Criar ArenaModel
2. Criar ArenaRemoteDataSource
3. Criar ArenaRepositoryImpl
4. Criar UseCases de Arena:
   - GetArenasNearbyUseCase
   - SearchArenasUseCase
   - GetArenaByIdUseCase
5. Criar Arena BLoC
6. Criar ArenaListPage
7. Criar ArenaDetailsPage
8. Integrar Google Maps
9. Implementar geolocalização
10. Implementar filtros de busca

---

## 🎯 Sprint 3 - Reservas (2 semanas)

### Tarefas:
1. Criar ReservaModel
2. Criar ReservaRemoteDataSource
3. Criar ReservaRepositoryImpl
4. Criar UseCases de Reserva
5. Criar Reserva BLoC
6. Criar página de calendário
7. Criar fluxo de reserva
8. Implementar listagem de reservas
9. Implementar cancelamento

---

## 🎯 Sprint 4 - Racha/Procurar Parceiros (2 semanas)

### Tarefas:
1. Criar RachaModel
2. Criar RachaRemoteDataSource
3. Criar RachaRepositoryImpl
4. Criar UseCases de Racha
5. Criar Racha BLoC
6. Criar feed de rachas
7. Criar página de criar racha
8. Implementar participar de racha
9. Sistema de notificações

---

## 📚 Recursos Úteis

### Documentação
- [BLoC Pattern](https://bloclibrary.dev/)
- [Supabase Flutter](https://supabase.com/docs/reference/dart/introduction)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

### Comandos Úteis

```bash
# Gerar código (models, etc)
flutter pub run build_runner build --delete-conflicting-outputs

# Verificar issues
flutter analyze

# Formatar código
dart format lib/

# Rodar testes
flutter test

# Limpar e reinstalar
flutter clean && flutter pub get
```

### Dicas de Desenvolvimento

1. **Sempre gere o código após criar models:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Teste cada camada separadamente:**
   - DataSource → Repository → UseCase → BLoC

3. **Use o debugger do Flutter:**
   - Coloque breakpoints
   - Inspecione variáveis
   - Use DevTools

4. **Commit frequentemente:**
   ```bash
   git add .
   git commit -m "feat: implementa autenticação"
   ```

5. **Mantenha o código limpo:**
   - Siga as convenções do Dart
   - Use nomes descritivos
   - Comente quando necessário

---

## 🆘 Troubleshooting

### Erro: "Supabase not initialized"
**Solução:** Verifique se o Supabase.initialize() está sendo chamado no main.dart antes de runApp()

### Erro: "Type 'X' is not a subtype of type 'Y'"
**Solução:** Verifique se você está convertendo corretamente entre Model e Entity

### Erro: "BLoC not found in context"
**Solução:** Certifique-se de que o BlocProvider está acima do widget que tenta acessar o BLoC

### Erro ao gerar código
**Solução:** 
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🎉 Boa sorte!

Qualquer dúvida, consulte:
- README.md principal
- Documentação do BLoC
- Documentação do Supabase
- Ou abra uma issue no GitHub!
