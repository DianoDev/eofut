import 'package:dartz/dartz.dart';
import 'package:eofut/core/errors/failures.dart';
import 'package:eofut/domain/entities/user.dart';
import 'package:eofut/domain/repositories/auth_repository.dart';

class RegisterProfessorUseCase {
  final AuthRepository repository;

  RegisterProfessorUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String nome,
    required String email,
    required String password,
    required String telefone,
    List<String>? certificacoes,
    List<String>? especialidades,
    double? valorHoraAula,
    int? experienciaAnos,
    String? cidade,
    String? estado,
  }) async {
    return await repository.signUpProfessor(
      nome: nome,
      email: email,
      password: password,
      telefone: telefone,
      certificacoes: certificacoes,
      especialidades: especialidades,
      valorHoraAula: valorHoraAula,
      experienciaAnos: experienciaAnos,
      cidade: cidade,
      estado: estado,
    );
  }
}
