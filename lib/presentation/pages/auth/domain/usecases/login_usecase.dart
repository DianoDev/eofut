import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../domain/repositories/auth_repository.dart';
import '../../../../../domain/entities/user.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) async {
    return await repository.signIn(
      email: email,
      password: password,
    );
  }
}
