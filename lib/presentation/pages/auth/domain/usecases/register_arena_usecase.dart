import 'package:dartz/dartz.dart';
import 'package:eofut/core/errors/failures.dart';
import 'package:eofut/domain/entities/user.dart';
import 'package:eofut/domain/repositories/auth_repository.dart';

class RegisterArenaUseCase {
  final AuthRepository repository;

  RegisterArenaUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String nomeEstabelecimento,
    required String email,
    required String password,
    required String telefone,
    required String cnpj,
    required String enderecoCompleto,
    required String cidade,
    required String estado,
    Map<String, dynamic>? horarioFuncionamento,
  }) async {
    return await repository.signUpArena(
      nomeEstabelecimento: nomeEstabelecimento,
      email: email,
      password: password,
      telefone: telefone,
      cnpj: cnpj,
      enderecoCompleto: enderecoCompleto,
      cidade: cidade,
      estado: estado,
      horarioFuncionamento: horarioFuncionamento,
    );
  }
}
