import 'package:dartz/dartz.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../domain/entities/user.dart';
import '../../../../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signUpJogador({
    required String nome,
    required String email,
    required String password,
    required String telefone,
    String? cidade,
    String? estado,
    String? nivelJogo,
  }) async {
    try {
      final userModel = await remoteDataSource.signUpJogador(
        nome: nome,
        email: email,
        password: password,
        telefone: telefone,
        cidade: cidade,
        estado: estado,
        nivelJogo: nivelJogo,
      );
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
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
  }) async {
    try {
      final userModel = await remoteDataSource.signUpArena(
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
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
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
  }) async {
    try {
      final userModel = await remoteDataSource.signUpProfessor(
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
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await remoteDataSource.resetPassword(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      if (userModel == null) {
        return const Right(null);
      }
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: $e'));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return remoteDataSource.authStateChanges.map((userModel) {
      if (userModel == null) return null;
      return userModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, User>> signUp({required String email, required String password, required String nome, required String telefone}) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
