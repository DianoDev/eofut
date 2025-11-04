import 'package:dartz/dartz.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import 'package:eofut/domain/entities/quadra.dart';
import 'package:eofut/domain/repositories/quadra_repository.dart';
import '../datasources/quadra_remote_data_source.dart';

class QuadraRepositoryImpl implements QuadraRepository {
  final QuadraRemoteDataSource remoteDataSource;

  QuadraRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Quadra>>> getQuadrasByArena(String arenaId) async {
    try {
      final quadras = await remoteDataSource.getQuadrasByArena(arenaId);
      return Right(quadras.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, Quadra>> createQuadra({
    required String arenaId,
    required String nome,
    String? tipoPiso,
    double? valorHora,
    bool coberta = false,
    bool iluminacao = true,
    bool ativa = true,
    String? observacoes,
  }) async {
    try {
      final quadra = await remoteDataSource.createQuadra(
        arenaId: arenaId,
        nome: nome,
        tipoPiso: tipoPiso,
        valorHora: valorHora,
        coberta: coberta,
        iluminacao: iluminacao,
        ativa: ativa,
        observacoes: observacoes,
      );
      return Right(quadra.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, Quadra>> updateQuadra({
    required String id,
    String? nome,
    String? tipoPiso,
    double? valorHora,
    bool? coberta,
    bool? iluminacao,
    bool? ativa,
    String? observacoes,
  }) async {
    try {
      final quadra = await remoteDataSource.updateQuadra(
        id: id,
        nome: nome,
        tipoPiso: tipoPiso,
        valorHora: valorHora,
        coberta: coberta,
        iluminacao: iluminacao,
        ativa: ativa,
        observacoes: observacoes,
      );
      return Right(quadra.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteQuadra(String id) async {
    try {
      await remoteDataSource.deleteQuadra(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, Quadra>> toggleQuadraStatus(String id, bool ativa) async {
    try {
      final quadra = await remoteDataSource.toggleQuadraStatus(id, ativa);
      return Right(quadra.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }
}
