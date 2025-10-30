import 'package:get_it/get_it.dart';
import 'package:eofut/core/network/supabase_config.dart';

// Professores - Data Sources
import 'data/datasources/professor_remote_data_source.dart';

// Professores - Repositories
import 'data/repositories/professor_repository_impl.dart';
import 'package:eofut/domain/repositories/professor_repository.dart';

// Professores - Use Cases
import 'domain/get_professores_usecase.dart';

// Professores - BLoC
import 'presentation/bloc/professor_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================
  // BLoCs
  // ============================================

  /// Professor BLoC - Factory para criar nova instância
  sl.registerFactory(
    () => ProfessorBloc(
      getProfessoresUseCase: sl(),
    ),
  );

  // ============================================
  // Use Cases
  // ============================================

  /// Professor Use Cases
  sl.registerLazySingleton(() => GetProfessoresUseCase(sl()));

  // ============================================
  // Repositories
  // ============================================

  /// Professor Repository Implementation
  sl.registerLazySingleton<ProfessorRepository>(
    () => ProfessorRepositoryImpl(remoteDataSource: sl()),
  );

  // ============================================
  // Data Sources
  // ============================================

  /// Professor Remote Data Source
  sl.registerLazySingleton<ProfessorRemoteDataSource>(
    () => ProfessorRemoteDataSourceImpl(supabaseClient: SupabaseConfig.client),
  );

  print('✅ Professor Module Initialized!');
}
