import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/campeonato.dart';
import '../repositories/campeonato_repository.dart';

class GetCampeonatosUseCase {
  final CampeonatoRepository repository;

  GetCampeonatosUseCase(this.repository);

  Future<Either<Failure, List<Campeonato>>> call({
    String? cidade,
    String? estado,
    String? status,
  }) async {
    return await repository.getCampeonatos(
      cidade: cidade,
      estado: estado,
      status: status,
    );
  }
}
