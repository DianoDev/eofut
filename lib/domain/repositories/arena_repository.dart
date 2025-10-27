import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/arena.dart';

abstract class ArenaRepository {
  Future<Either<Failure, List<Arena>>> getArenasNearby({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  });

  Future<Either<Failure, List<Arena>>> searchArenas({
    String? cidade,
    String? estado,
    double? precoMax,
    double? ratingMin,
  });

  Future<Either<Failure, Arena>> getArenaById(String id);

  Future<Either<Failure, List<Arena>>> getMyArenas(String userId);

  Future<Either<Failure, void>> avaliarArena({
    required String arenaId,
    required int nota,
    String? comentario,
  });
}
