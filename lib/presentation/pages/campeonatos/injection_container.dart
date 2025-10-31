import 'package:get_it/get_it.dart';
import 'package:eofut/core/network/supabase_config.dart';

// Data Sources
import 'data/datasources/campeonato_remote_data_source.dart';

// Repositories
import 'data/repositories/campeonato_repository_impl.dart';
import 'domain/repositories/campeonato_repository.dart';

// Use Cases
import 'domain/usecases/create_campeonato_usecase.dart';
import 'domain/usecases/delete_campeonato_usecase.dart';
import 'domain/usecases/get_campeonato_by_id_usecase.dart';
import 'domain/usecases/get_campeonatos_usecase.dart';
import 'domain/usecases/get_meus_campeonatos_usecase.dart';
import 'domain/usecases/update_campeonato_usecase.dart';

// BLoC
import 'presentation/bloc/campeonato_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================
  // BLoCs
  // ============================================

  sl.registerFactory(
    () => CampeonatoBloc(
      getCampeonatosUseCase: sl(),
      getCampeonatoByIdUseCase: sl(),
      getMeusCampeonatosUseCase: sl(),
      createCampeonatoUseCase: sl(),
      updateCampeonatoUseCase: sl(),
      deleteCampeonatoUseCase: sl(),
    ),
  );

  // ============================================
  // Use Cases
  // ============================================

  sl.registerLazySingleton(() => GetCampeonatosUseCase(sl()));
  sl.registerLazySingleton(() => GetCampeonatoByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetMeusCampeonatosUseCase(sl()));
  sl.registerLazySingleton(() => CreateCampeonatoUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCampeonatoUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCampeonatoUseCase(sl()));

  // ============================================
  // Repositories
  // ============================================

  sl.registerLazySingleton<CampeonatoRepository>(
    () => CampeonatoRepositoryImpl(remoteDataSource: sl()),
  );

  // ============================================
  // Data Sources
  // ============================================

  sl.registerLazySingleton<CampeonatoRemoteDataSource>(
    () => CampeonatoRemoteDataSourceImpl(supabaseClient: SupabaseConfig.client),
  );

  print('✅ Campeonato Module Initialized!');
}
