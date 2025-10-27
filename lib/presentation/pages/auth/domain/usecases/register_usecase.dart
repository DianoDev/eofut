import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../domain/entities/user.dart';
import '../../../../../domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String nome,
    required String email,
    required String telefone,
    required String password,
  }) async {
    return await repository.signUp(
      nome: nome,
      email: email,
      password: password,
      telefone: telefone,
    );
  }
}
