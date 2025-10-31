import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/campeonato.dart';
import '../repositories/campeonato_repository.dart';

class UpdateCampeonatoUseCase {
  final CampeonatoRepository repository;

  UpdateCampeonatoUseCase(this.repository);

  Future<Either<Failure, Campeonato>> call({
    required String id,
    String? nome,
    String? descricao,
    DateTime? dataInicio,
    DateTime? dataFim,
    String? localArenaId,
    String? cidade,
    String? estado,
    List<String>? categorias,
    String? nivelMinimo,
    int? vagas,
    double? valorInscricao,
    String? status,
    String? premiacao,
    String? regras,
    List<String>? fotos,
  }) async {
    return await repository.updateCampeonato(
      id: id,
      nome: nome,
      descricao: descricao,
      dataInicio: dataInicio,
      dataFim: dataFim,
      localArenaId: localArenaId,
      cidade: cidade,
      estado: estado,
      categorias: categorias,
      nivelMinimo: nivelMinimo,
      vagas: vagas,
      valorInscricao: valorInscricao,
      status: status,
      premiacao: premiacao,
      regras: regras,
      fotos: fotos,
    );
  }
}
