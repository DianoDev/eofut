import 'package:dartz/dartz.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../domain/entities/arena.dart';
import '../../../../../domain/repositories/arena_repository.dart';
import '../datasources/arena_merote_data_source.dart';

class ArenaRepositoryImpl implements ArenaRepository {
  final ArenaRemoteDataSource remoteDataSource;

  ArenaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Arena>>> getArenasNearby({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  }) async {
    try {
      // Por enquanto, retornar todas as arenas
      // Implementar cálculo de distância depois
      final arenas = await remoteDataSource.getArenas();
      return Right(arenas.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Arena>>> searchArenas({
    String? cidade,
    String? estado,
    double? precoMax,
    double? ratingMin,
  }) async {
    try {
      final arenas = await remoteDataSource.getArenas(
        cidade: cidade,
        estado: estado,
      );

      var filteredArenas = arenas.map((model) => model.toEntity()).toList();

      // Aplicar filtros adicionais
      if (precoMax != null) {
        filteredArenas = filteredArenas.where((arena) => arena.valorHora <= precoMax).toList();
      }

      if (ratingMin != null) {
        filteredArenas = filteredArenas.where((arena) => arena.rating >= ratingMin).toList();
      }

      return Right(filteredArenas);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, Arena>> getArenaById(String id) async {
    try {
      final arenaModel = await remoteDataSource.getArenaById(id);
      return Right(arenaModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Arena>>> getMyArenas(String userId) async {
    // Implementar quando adicionar proprietario_id no datasource
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> avaliarArena({
    required String arenaId,
    required int nota,
    String? comentario,
  }) async {
    // Implementar avaliações depois
    return const Right(null);
  }
}
