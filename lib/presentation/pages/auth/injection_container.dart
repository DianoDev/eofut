import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eofut/core/network/supabase_config.dart';

// Auth - Data Sources
import 'data/datasources/auth_remote_data_source.dart';

// Auth - Repositories
import 'data/repositories/auth_repository_impl.dart';
import 'package:eofut/domain/repositories/auth_repository.dart';

// Auth - Use Cases
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/register_jogador_usecase.dart';
import 'domain/usecases/register_arena_usecase.dart';
import 'domain/usecases/register_professor_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/get_current_user_usecase.dart';

// Auth - BLoC
import 'presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================
  // BLoCs
  // ============================================
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerJogadorUseCase: sl(),
      registerArenaUseCase: sl(),
      registerProfessorUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  // ============================================
  // Use Cases
  // ============================================
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterJogadorUseCase(sl()));
  sl.registerLazySingleton(() => RegisterArenaUseCase(sl()));
  sl.registerLazySingleton(() => RegisterProfessorUseCase(sl()));
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
    () => AuthRemoteDataSourceImpl(supabaseClient: SupabaseConfig.client),
  );

  // ============================================
  // External Dependencies
  // ============================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => SupabaseConfig.client);
}
