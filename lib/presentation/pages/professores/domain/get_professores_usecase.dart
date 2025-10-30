import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../domain/entities/professor.dart';
import '../../../../domain/repositories/professor_repository.dart';

class GetProfessoresUseCase {
  final ProfessorRepository repository;

  GetProfessoresUseCase(this.repository);

  Future<Either<Failure, List<Professor>>> call({
    String? cidade,
    String? estado,
    double? precoMax,
    double? ratingMin,
  }) async {
    return await repository.getProfessores(
      cidade: cidade,
      estado: estado,
      precoMax: precoMax,
      ratingMin: ratingMin,
    );
  }
}
