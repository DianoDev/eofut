import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/campeonato.dart';

abstract class CampeonatoRepository {
  Future<Either<Failure, List<Campeonato>>> getCampeonatos({
    String? cidade,
    String? estado,
    String? status,
  });

  Future<Either<Failure, Campeonato>> getCampeonatoById(String id);

  Future<Either<Failure, List<Campeonato>>> getMeusCampeonatos(String organizadorId);

  Future<Either<Failure, Campeonato>> createCampeonato({
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
  });

  Future<Either<Failure, Campeonato>> updateCampeonato({
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
  });

  Future<Either<Failure, void>> deleteCampeonato(String id);
}
