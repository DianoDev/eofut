import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/constants/api_constants.dart';
import '../models/campeonato_model.dart';

abstract class CampeonatoRemoteDataSource {
  Future<List<CampeonatoModel>> getCampeonatos({
    String? cidade,
    String? estado,
    String? status,
  });

  Future<CampeonatoModel> getCampeonatoById(String id);

  Future<List<CampeonatoModel>> getMeusCampeonatos(String organizadorId);

  Future<CampeonatoModel> createCampeonato(Map<String, dynamic> data);

  Future<CampeonatoModel> updateCampeonato(String id, Map<String, dynamic> data);

  Future<void> deleteCampeonato(String id);
}

class CampeonatoRemoteDataSourceImpl implements CampeonatoRemoteDataSource {
  final SupabaseClient supabaseClient;

  CampeonatoRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<CampeonatoModel>> getCampeonatos({
    String? cidade,
    String? estado,
    String? status,
  }) async {
    try {
      var query = supabaseClient.from(ApiConstants.tableCampeonatos).select();

      if (cidade != null && cidade.isNotEmpty) {
        query = query.eq('cidade', cidade);
      }

      if (estado != null && estado.isNotEmpty) {
        query = query.eq('estado', estado);
      }

      if (status != null && status.isNotEmpty) {
        query = query.eq('status', status);
      }

      final response = await query.order('data_inicio', ascending: false);

      return (response as List).map((json) => CampeonatoModel.fromJson(json as Map<String, dynamic>)).toList();
    } on PostgrestException catch (e) {
      throw ServerException('Erro ao buscar campeonatos: ${e.message}');
    } catch (e) {
      throw ServerException('Erro ao buscar campeonatos: $e');
    }
  }

  @override
  Future<CampeonatoModel> getCampeonatoById(String id) async {
    try {
      final response = await supabaseClient.from(ApiConstants.tableCampeonatos).select().eq('id', id).single();

      return CampeonatoModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException('Erro ao buscar campeonato: ${e.message}');
    } catch (e) {
      throw ServerException('Erro ao buscar campeonato: $e');
    }
  }

  @override
  Future<List<CampeonatoModel>> getMeusCampeonatos(String organizadorId) async {
    try {
      final response = await supabaseClient.from(ApiConstants.tableCampeonatos).select().eq('organizador_id', organizadorId).order('created_at', ascending: false);

      return (response as List).map((json) => CampeonatoModel.fromJson(json as Map<String, dynamic>)).toList();
    } on PostgrestException catch (e) {
      throw ServerException('Erro ao buscar meus campeonatos: ${e.message}');
    } catch (e) {
      throw ServerException('Erro ao buscar meus campeonatos: $e');
    }
  }

  @override
  Future<CampeonatoModel> createCampeonato(Map<String, dynamic> data) async {
    try {
      final response = await supabaseClient.from(ApiConstants.tableCampeonatos).insert(data).select().single();

      return CampeonatoModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException('Erro ao criar campeonato: ${e.message}');
    } catch (e) {
      throw ServerException('Erro ao criar campeonato: $e');
    }
  }

  @override
  Future<CampeonatoModel> updateCampeonato(String id, Map<String, dynamic> data) async {
    try {
      data['updated_at'] = DateTime.now().toIso8601String();

      final response = await supabaseClient.from(ApiConstants.tableCampeonatos).update(data).eq('id', id).select().single();

      return CampeonatoModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException('Erro ao atualizar campeonato: ${e.message}');
    } catch (e) {
      throw ServerException('Erro ao atualizar campeonato: $e');
    }
  }

  @override
  Future<void> deleteCampeonato(String id) async {
    try {
      await supabaseClient.from(ApiConstants.tableCampeonatos).delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerException('Erro ao deletar campeonato: ${e.message}');
    } catch (e) {
      throw ServerException('Erro ao deletar campeonato: $e');
    }
  }
}
