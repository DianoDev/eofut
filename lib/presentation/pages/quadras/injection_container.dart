import 'package:get_it/get_it.dart';
import 'package:eofut/core/network/supabase_config.dart';

// Data Sources
import 'data/datasources/quadra_remote_data_source.dart';

// Repositories
import 'package:eofut/presentation/pages/quadras/data/repositories/quadra_repository_impl.dart';
import 'package:eofut/domain/repositories/quadra_repository.dart';

// Use Cases
import 'domain/get_quadras_by_arena_usecase.dart';
import 'domain/create_quadra_usecase.dart';
import 'domain/update_quadra_usecase.dart';
import 'domain/delete_quadra_usecase.dart';
import 'domain/toggle_quadra_status_usecase.dart';

// BLoC
import 'presentation/bloc/quadra_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================
  // BLoCs
  // ============================================

  sl.registerFactory(
    () => QuadraBloc(
      getQuadrasByArenaUseCase: sl(),
      createQuadraUseCase: sl(),
      updateQuadraUseCase: sl(),
      deleteQuadraUseCase: sl(),
      toggleQuadraStatusUseCase: sl(),
    ),
  );

  // ============================================
  // Use Cases
  // ============================================

  sl.registerLazySingleton(() => GetQuadrasByArenaUseCase(sl()));
  sl.registerLazySingleton(() => CreateQuadraUseCase(sl()));
  sl.registerLazySingleton(() => UpdateQuadraUseCase(sl()));
  sl.registerLazySingleton(() => DeleteQuadraUseCase(sl()));
  sl.registerLazySingleton(() => ToggleQuadraStatusUseCase(sl()));

  // ============================================
  // Repositories
  // ============================================

  sl.registerLazySingleton<QuadraRepository>(
    () => QuadraRepositoryImpl(remoteDataSource: sl()),
  );

  // ============================================
  // Data Sources
  // ============================================

  sl.registerLazySingleton<QuadraRemoteDataSource>(
    () => QuadraRemoteDataSourceImpl(supabaseClient: SupabaseConfig.client),
  );

  print('✅ Quadra Module Initialized!');
}
