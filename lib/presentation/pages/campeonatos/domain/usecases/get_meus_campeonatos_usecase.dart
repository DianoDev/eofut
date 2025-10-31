import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/campeonato.dart';
import '../repositories/campeonato_repository.dart';

class GetMeusCampeonatosUseCase {
  final CampeonatoRepository repository;

  GetMeusCampeonatosUseCase(this.repository);

  Future<Either<Failure, List<Campeonato>>> call(String organizadorId) async {
    return await repository.getMeusCampeonatos(organizadorId);
  }
}
