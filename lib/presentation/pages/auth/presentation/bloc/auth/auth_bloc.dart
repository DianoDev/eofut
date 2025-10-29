import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eofut/presentation/pages/auth/domain/usecases/get_current_user_usecase.dart';
import '../../../domain/usecases/get_current_user_usecase.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import '../../../domain/usecases/register_jogador_usecase.dart';
import '../../../domain/usecases/register_arena_usecase.dart';
import '../../../domain/usecases/register_professor_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterJogadorUseCase registerJogadorUseCase;
  final RegisterArenaUseCase registerArenaUseCase;
  final RegisterProfessorUseCase registerProfessorUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerJogadorUseCase,
    required this.registerArenaUseCase,
    required this.registerProfessorUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AuthInitial()) {
    // Registrar handlers para cada evento
    on<LoginEvent>(_onLogin);
    on<RegisterJogadorEvent>(_onRegisterJogador);
    on<RegisterArenaEvent>(_onRegisterArena);
    on<RegisterProfessorEvent>(_onRegisterProfessor);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<ClearAuthErrorEvent>(_onClearAuthError);
  }

  /// Handler para evento de Login
  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  /// Handler para registro de JOGADOR
  Future<void> _onRegisterJogador(
    RegisterJogadorEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await registerJogadorUseCase(
      nome: event.nome,
      email: event.email,
      password: event.password,
      telefone: event.telefone,
      cidade: event.cidade,
      estado: event.estado,
      nivelJogo: event.nivelJogo,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  /// Handler para registro de ARENA
  Future<void> _onRegisterArena(
    RegisterArenaEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await registerArenaUseCase(
      nomeEstabelecimento: event.nomeEstabelecimento,
      email: event.email,
      password: event.password,
      telefone: event.telefone,
      cnpj: event.cnpj,
      enderecoCompleto: event.enderecoCompleto,
      cidade: event.cidade,
      estado: event.estado,
      horarioFuncionamento: event.horarioFuncionamento,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  /// Handler para registro de PROFESSOR
  Future<void> _onRegisterProfessor(
    RegisterProfessorEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await registerProfessorUseCase(
      nome: event.nome,
      email: event.email,
      password: event.password,
      telefone: event.telefone,
      certificacoes: event.certificacoes,
      especialidades: event.especialidades,
      valorHoraAula: event.valorHoraAula,
      experienciaAnos: event.experienciaAnos,
      cidade: event.cidade,
      estado: event.estado,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  /// Handler para evento de Logout
  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  /// Handler para verificar status de autenticação
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await getCurrentUserUseCase();

    result.fold(
      (failure) => emit(const Unauthenticated()),
      (user) {
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          emit(const Unauthenticated());
        }
      },
    );
  }

  /// Handler para limpar erros
  Future<void> _onClearAuthError(
    ClearAuthErrorEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthInitial());
  }
}
