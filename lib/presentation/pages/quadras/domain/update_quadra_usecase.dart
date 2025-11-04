import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import 'package:eofut/domain/entities/quadra.dart';
import 'package:eofut/domain/repositories/quadra_repository.dart';

class UpdateQuadraUseCase {
  final QuadraRepository repository;

  UpdateQuadraUseCase(this.repository);

  Future<Either<Failure, Quadra>> call({
    required String id,
    String? nome,
    String? tipoPiso,
    double? valorHora,
    bool? coberta,
    bool? iluminacao,
    bool? ativa,
    String? observacoes,
  }) async {
    return await repository.updateQuadra(
      id: id,
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
