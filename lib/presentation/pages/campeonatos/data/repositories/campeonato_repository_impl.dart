import 'package:dartz/dartz.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/campeonato.dart';
import '../../domain/repositories/campeonato_repository.dart';
import '../datasources/campeonato_remote_data_source.dart';

class CampeonatoRepositoryImpl implements CampeonatoRepository {
  final CampeonatoRemoteDataSource remoteDataSource;

  CampeonatoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Campeonato>>> getCampeonatos({
    String? cidade,
    String? estado,
    String? status,
  }) async {
    try {
      final campeonatos = await remoteDataSource.getCampeonatos(
        cidade: cidade,
        estado: estado,
        status: status,
      );
      return Right(campeonatos.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, Campeonato>> getCampeonatoById(String id) async {
    try {
      final campeonato = await remoteDataSource.getCampeonatoById(id);
      return Right(campeonato.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Campeonato>>> getMeusCampeonatos(String organizadorId) async {
    try {
      final campeonatos = await remoteDataSource.getMeusCampeonatos(organizadorId);
      return Right(campeonatos.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
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
  }) async {
    try {
      final data = {
        'nome': nome,
        'descricao': descricao,
        'data_inicio': dataInicio.toIso8601String(),
        'data_fim': dataFim.toIso8601String(),
        'local_arena_id': localArenaId,
        'organizador_id': organizadorId,
        'cidade': cidade,
        'estado': estado,
        'categorias': categorias ?? [],
        'nivel_minimo': nivelMinimo,
        'vagas': vagas,
        'valor_inscricao': valorInscricao,
        'status': 'aberto',
        'premiacao': premiacao,
        'regras': regras,
        'fotos': fotos ?? [],
        'total_inscritos': 0,
      };

      final campeonato = await remoteDataSource.createCampeonato(data);
      return Right(campeonato.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
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
  }) async {
    try {
      final data = <String, dynamic>{};

      if (nome != null) data['nome'] = nome;
      if (descricao != null) data['descricao'] = descricao;
      if (dataInicio != null) data['data_inicio'] = dataInicio.toIso8601String();
      if (dataFim != null) data['data_fim'] = dataFim.toIso8601String();
      if (localArenaId != null) data['local_arena_id'] = localArenaId;
      if (cidade != null) data['cidade'] = cidade;
      if (estado != null) data['estado'] = estado;
      if (categorias != null) data['categorias'] = categorias;
      if (nivelMinimo != null) data['nivel_minimo'] = nivelMinimo;
      if (vagas != null) data['vagas'] = vagas;
      if (valorInscricao != null) data['valor_inscricao'] = valorInscricao;
      if (status != null) data['status'] = status;
      if (premiacao != null) data['premiacao'] = premiacao;
      if (regras != null) data['regras'] = regras;
      if (fotos != null) data['fotos'] = fotos;

      final campeonato = await remoteDataSource.updateCampeonato(id, data);
      return Right(campeonato.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCampeonato(String id) async {
    try {
      await remoteDataSource.deleteCampeonato(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }
}
