import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import 'package:eofut/domain/entities/quadra.dart';
import 'package:eofut/domain/repositories/quadra_repository.dart';

class CreateQuadraUseCase {
  final QuadraRepository repository;

  CreateQuadraUseCase(this.repository);

  Future<Either<Failure, Quadra>> call({
    required String arenaId,
    required String nome,
    String? tipoPiso,
    double? valorHora,
    bool coberta = false,
    bool iluminacao = true,
    bool ativa = true,
    String? observacoes,
  }) async {
    return await repository.createQuadra(
      arenaId: arenaId,
      nome: nome,
      tipoPiso: tipoPiso,
      valorHora: valorHora,
      coberta: coberta,
      iluminacao: iluminacao,
      ativa: ativa,
      observacoes: observacoes,
    );
  }
}
