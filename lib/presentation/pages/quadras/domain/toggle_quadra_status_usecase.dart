import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import 'package:eofut/domain/entities/quadra.dart';
import 'package:eofut/domain/repositories/quadra_repository.dart';

class ToggleQuadraStatusUseCase {
  final QuadraRepository repository;

  ToggleQuadraStatusUseCase(this.repository);

  Future<Either<Failure, Quadra>> call(String id, bool ativa) async {
    return await repository.toggleQuadraStatus(id, ativa);
  }
}
