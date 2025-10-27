import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/supabase_config.dart';

// TODO: Importar repositories, datasources, blocs quando criados
// import 'data/datasources/remote/auth_remote_datasource.dart';
// import 'data/repositories/auth_repository_impl.dart';
// import 'domain/repositories/auth_repository.dart';
// import 'domain/usecases/auth/login_usecase.dart';
// import 'presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================
  // BLoCs
  // ============================================
  // sl.registerFactory(() => AuthBloc(loginUseCase: sl()));

  // ============================================
  // Use Cases
  // ============================================
  // sl.registerLazySingleton(() => LoginUseCase(sl()));

  // ============================================
  // Repositories
  // ============================================
  // sl.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(remoteDataSource: sl()),
  // );

  // ============================================
  // Data Sources
  // ============================================
  // sl.registerLazySingleton<AuthRemoteDataSource>(
  //   () => AuthRemoteDataSourceImpl(client: SupabaseConfig.client),
  // );

  // ============================================
  // External
  // ============================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => SupabaseConfig.client);
}
