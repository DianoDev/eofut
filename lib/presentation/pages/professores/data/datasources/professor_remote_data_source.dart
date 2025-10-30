import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/constants/api_constants.dart';
import '../models/professor_model.dart';

abstract class ProfessorRemoteDataSource {
  Future<List<ProfessorModel>> getProfessores({
    String? cidade,
    String? estado,
  });

  Future<ProfessorModel> getProfessorById(String id);
}

class ProfessorRemoteDataSourceImpl implements ProfessorRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProfessorRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<ProfessorModel>> getProfessores({
    String? cidade,
    String? estado,
  }) async {
    try {
      // Join com a tabela users para pegar nome e foto
      var query = supabaseClient.from(ApiConstants.tableProfessores).select('*, users!inner(nome, foto_url, cidade, estado)').eq('ativo', true);

      // Filtrar por cidade/estado do usuário
      if (cidade != null && cidade.isNotEmpty) {
        query = query.eq('users.cidade', cidade);
      }

      if (estado != null && estado.isNotEmpty) {
        query = query.eq('users.estado', estado);
      }

      final response = await query.order('rating', ascending: false);

      return (response as List).map((json) => ProfessorModel.fromJson(json as Map<String, dynamic>)).toList();
    } on PostgrestException catch (e) {
      throw ServerException('Erro ao buscar professores: ${e.message}');
    } catch (e) {
      throw ServerException('Erro ao buscar professores: $e');
    }
  }

  @override
  Future<ProfessorModel> getProfessorById(String id) async {
    try {
      final response = await supabaseClient.from(ApiConstants.tableProfessores).select('*, users!inner(nome, foto_url, cidade, estado)').eq('id', id).single();

      return ProfessorModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException('Erro ao buscar professor: ${e.message}');
    } catch (e) {
      throw ServerException('Erro ao buscar professor: $e');
    }
  }
}
