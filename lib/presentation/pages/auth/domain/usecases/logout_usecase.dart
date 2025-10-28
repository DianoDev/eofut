import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}
