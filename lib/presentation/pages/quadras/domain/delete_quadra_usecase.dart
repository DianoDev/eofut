import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import 'package:eofut/domain/repositories/quadra_repository.dart';

class DeleteQuadraUseCase {
  final QuadraRepository repository;

  DeleteQuadraUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteQuadra(id);
  }
}
