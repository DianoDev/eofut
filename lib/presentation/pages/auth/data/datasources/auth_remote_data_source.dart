import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '/../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Fazer login com email e senha
  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  /// Registrar novo usuário
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String nome,
  });

  /// Fazer logout
  Future<void> signOut();

  /// Recuperar senha
  Future<void> resetPassword(String email);

  /// Obter usuário atual
  Future<UserModel?> getCurrentUser();

  /// Stream de mudanças no estado de autenticação
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Fazer login no Supabase Auth
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const ServerException('Erro ao fazer login');
      }

      // 2. Buscar dados do usuário na tabela users
      final userData = await supabaseClient.from('users').select().eq('firebase_uid', response.user!.id).single();

      return UserModel.fromJson(userData);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Erro ao fazer login: $e');
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String nome,
  }) async {
    try {
      // 1. Criar usuário no Supabase Auth
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const ServerException('Erro ao criar conta');
      }

      // 2. Criar registro na tabela users com TODOS os campos
      final userData = await supabaseClient
          .from('users')
          .insert({
            'firebase_uid': response.user!.id,
            'nome': nome,
            'email': email,
            // Campos opcionais iniciam como null
            'telefone': null,
            'foto_url': null,
            'cidade': null,
            'estado': null,
            'data_nascimento': null,
            'genero': null,
            'nivel_jogo': 'iniciante', // valor padrão
            'posicao_preferida': null,
            'bio': null,
            'rating': 0.0,
            'total_avaliacoes': 0,
          })
          .select()
          .single();

      return UserModel.fromJson(userData);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Erro ao criar conta: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException('Erro ao fazer logout: $e');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Erro ao recuperar senha: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = supabaseClient.auth.currentUser;

      if (currentUser == null) {
        return null;
      }

      final userData = await supabaseClient.from('users').select().eq('firebase_uid', currentUser.id).single();

      return UserModel.fromJson(userData);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      // Se não houver usuário, retorna null em vez de lançar exceção
      return null;
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return supabaseClient.auth.onAuthStateChange.asyncMap((authState) async {
      final user = authState.session?.user;

      if (user == null) return null;

      try {
        final userData = await supabaseClient.from('users').select().eq('firebase_uid', user.id).single();

        return UserModel.fromJson(userData);
      } catch (e) {
        return null;
      }
    });
  }
}
