import 'package:dartz/dartz.dart';
import 'package:eofut/core/errors/failures.dart';
import 'package:eofut/domain/entities/user.dart';
import 'package:eofut/domain/repositories/auth_repository.dart';

class RegisterJogadorUseCase {
  final AuthRepository repository;

  RegisterJogadorUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String nome,
    required String email,
    required String password,
    required String telefone,
    String? cidade,
    String? estado,
    String? nivelJogo,
  }) async {
    return await repository.signUpJogador(
      nome: nome,
      email: email,
      password: password,
      telefone: telefone,
      cidade: cidade,
      estado: estado,
      nivelJogo: nivelJogo,
    );
  }
}
