import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/supabase_config.dart';

// Auth - Data Sources
import 'data/datasources/auth_remote_data_source.dart';

// Auth - Repositories
import 'data/repositories/auth_repository_impl.dart';
import '../../../domain/repositories/auth_repository.dart';

// Auth - Use Cases
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/register_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/get_current_user_usecase.dart';

// Auth - BLoC
import 'presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================
  // BLoCs
  // ============================================

  /// Auth BLoC - Factory para criar nova instância quando necessário
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

  /// Auth Use Cases - LazySingleton para reutilizar instâncias
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // ============================================
  // Repositories
  // ============================================

  /// Auth Repository Implementation
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // ============================================
  // Data Sources
  // ============================================

  /// Auth Remote Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: SupabaseConfig.client),
  );

  // ============================================
  // External Dependencies
  // ============================================

  /// Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  /// Supabase Client
  sl.registerLazySingleton(() => SupabaseConfig.client);
}
