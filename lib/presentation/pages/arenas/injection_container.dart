import 'package:get_it/get_it.dart';
import 'package:eofut/core/network/supabase_config.dart';

// Arenas - Data Sources
import 'data/datasources/arena_merote_data_source.dart';

// Arenas - Repositories
import 'data/repositories/arena_repository_impl.dart';
import 'package:eofut/domain/repositories/arena_repository.dart';

// Arenas - Use Cases
import 'domain/get_arenas_usecase.dart';

// Arenas - BLoC
import 'presentation/bloc/arena_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================
  // BLoCs
  // ============================================

  /// Arena BLoC - Factory para criar nova instância
  sl.registerFactory(
    () => ArenaBloc(
      getArenasUseCase: sl(),
    ),
  );

  // ============================================
  // Use Cases
  // ============================================

  /// Arena Use Cases
  sl.registerLazySingleton(() => GetArenasUseCase(sl()));

  // ============================================
  // Repositories
  // ============================================

  /// Arena Repository Implementation
  sl.registerLazySingleton<ArenaRepository>(
    () => ArenaRepositoryImpl(remoteDataSource: sl()),
  );

  // ============================================
  // Data Sources
  // ============================================

  /// Arena Remote Data Source
  sl.registerLazySingleton<ArenaRemoteDataSource>(
    () => ArenaRemoteDataSourceImpl(supabaseClient: SupabaseConfig.client),
  );

  print('✅ Arena Module Initialized!');
}
