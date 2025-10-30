import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/professor.dart';

abstract class ProfessorRepository {
  Future<Either<Failure, List<Professor>>> getProfessores({
    String? cidade,
    String? estado,
    double? precoMax,
    double? ratingMin,
  });

  Future<Either<Failure, Professor>> getProfessorById(String id);

  Future<Either<Failure, void>> avaliarProfessor({
    required String professorId,
    required int nota,
    String? comentario,
  });
}
