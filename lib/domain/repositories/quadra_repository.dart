import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/quadra.dart';

abstract class QuadraRepository {
  Future<Either<Failure, List<Quadra>>> getQuadrasByArena(String arenaId);

  Future<Either<Failure, Quadra>> createQuadra({
    required String arenaId,
    required String nome,
    String? tipoPiso,
    double? valorHora,
    bool coberta,
    bool iluminacao,
    bool ativa,
    String? observacoes,
  });

  Future<Either<Failure, Quadra>> updateQuadra({
    required String id,
    String? nome,
    String? tipoPiso,
    double? valorHora,
    bool? coberta,
    bool? iluminacao,
    bool? ativa,
    String? observacoes,
  });

  Future<Either<Failure, void>> deleteQuadra(String id);

  Future<Either<Failure, Quadra>> toggleQuadraStatus(String id, bool ativa);
}
