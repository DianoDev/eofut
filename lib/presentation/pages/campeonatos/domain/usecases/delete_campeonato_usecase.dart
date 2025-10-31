import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../repositories/campeonato_repository.dart';

class DeleteCampeonatoUseCase {
  final CampeonatoRepository repository;

  DeleteCampeonatoUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteCampeonato(id);
  }
}
