import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/campeonato.dart';
import '../repositories/campeonato_repository.dart';

class CreateCampeonatoUseCase {
  final CampeonatoRepository repository;

  CreateCampeonatoUseCase(this.repository);

  Future<Either<Failure, Campeonato>> call({
    required String nome,
    required String descricao,
    required DateTime dataInicio,
    required DateTime dataFim,
    String? localArenaId,
    required String organizadorId,
    required String cidade,
    required String estado,
    List<String>? categorias,
    String? nivelMinimo,
    required int vagas,
    required double valorInscricao,
    String? premiacao,
    String? regras,
    List<String>? fotos,
  }) async {
    return await repository.createCampeonato(
      nome: nome,
      descricao: descricao,
      dataInicio: dataInicio,
      dataFim: dataFim,
      localArenaId: localArenaId,
      organizadorId: organizadorId,
      cidade: cidade,
      estado: estado,
      categorias: categorias,
      nivelMinimo: nivelMinimo,
      vagas: vagas,
      valorInscricao: valorInscricao,
      premiacao: premiacao,
      regras: regras,
      fotos: fotos,
    );
  }
}
