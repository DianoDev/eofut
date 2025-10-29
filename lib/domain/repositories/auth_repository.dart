import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signUpJogador({
    required String nome,
    required String email,
    required String password,
    required String telefone,
    String? cidade,
    String? estado,
    String? nivelJogo,
  });

  Future<Either<Failure, User>> signUpArena({
    required String nomeEstabelecimento,
    required String email,
    required String password,
    required String telefone,
    required String cnpj,
    required String enderecoCompleto,
    required String cidade,
    required String estado,
    Map<String, dynamic>? horarioFuncionamento,
  });

  Future<Either<Failure, User>> signUpProfessor({
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
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> resetPassword(String email);

  Future<Either<Failure, User?>> getCurrentUser();

  Stream<User?> get authStateChanges;
}
