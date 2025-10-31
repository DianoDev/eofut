import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/campeonato.dart';
import '../repositories/campeonato_repository.dart';

class GetCampeonatoByIdUseCase {
  final CampeonatoRepository repository;

  GetCampeonatoByIdUseCase(this.repository);

  Future<Either<Failure, Campeonato>> call(String id) async {
    return await repository.getCampeonatoById(id);
  }
}
