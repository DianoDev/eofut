import 'package:dartz/dartz.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../domain/entities/professor.dart';
import '../../../../../domain/repositories/professor_repository.dart';
import '../datasources/professor_remote_data_source.dart';

class ProfessorRepositoryImpl implements ProfessorRepository {
  final ProfessorRemoteDataSource remoteDataSource;

  ProfessorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Professor>>> getProfessores({
    String? cidade,
    String? estado,
    double? precoMax,
    double? ratingMin,
  }) async {
    try {
      final professores = await remoteDataSource.getProfessores(
        cidade: cidade,
        estado: estado,
      );

      var filteredProfessores = professores.map((model) => model.toEntity()).toList();

      // Aplicar filtros adicionais
      if (precoMax != null) {
        filteredProfessores = filteredProfessores.where((prof) => prof.valorHoraAula <= precoMax).toList();
      }

      if (ratingMin != null) {
        filteredProfessores = filteredProfessores.where((prof) => prof.rating >= ratingMin).toList();
      }

      return Right(filteredProfessores);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, Professor>> getProfessorById(String id) async {
    try {
      final professorModel = await remoteDataSource.getProfessorById(id);
      return Right(professorModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> avaliarProfessor({
    required String professorId,
    required int nota,
    String? comentario,
  }) async {
    // Implementar avaliações depois
    return const Right(null);
  }
}
