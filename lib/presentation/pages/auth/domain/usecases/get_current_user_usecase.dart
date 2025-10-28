import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../domain/entities/user.dart';
import '../../../../../domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, User?>> call() async {
    return await repository.getCurrentUser();
  }
}
