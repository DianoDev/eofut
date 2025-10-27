import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../domain/entities/arena.dart';
import '../../../../domain/repositories/arena_repository.dart';

class GetArenasUseCase {
  final ArenaRepository repository;

  GetArenasUseCase(this.repository);

  Future<Either<Failure, List<Arena>>> call({
    String? cidade,
    String? estado,
    double? precoMax,
    double? ratingMin,
  }) async {
    return await repository.searchArenas(
      cidade: cidade,
      estado: estado,
      precoMax: precoMax,
      ratingMin: ratingMin,
    );
  }
}
