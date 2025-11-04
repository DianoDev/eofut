import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import 'package:eofut/domain/entities/quadra.dart';
import 'package:eofut/domain/repositories/quadra_repository.dart';

class GetQuadrasByArenaUseCase {
  final QuadraRepository repository;

  GetQuadrasByArenaUseCase(this.repository);

  Future<Either<Failure, List<Quadra>>> call(String arenaId) async {
    return await repository.getQuadrasByArena(arenaId);
  }
}
