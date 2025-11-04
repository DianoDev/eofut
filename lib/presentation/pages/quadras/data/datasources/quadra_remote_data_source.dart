import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/errors/exceptions.dart';
import '../models/quadra_model.dart';

abstract class QuadraRemoteDataSource {
  Future<List<QuadraModel>> getQuadrasByArena(String arenaId);
  Future<QuadraModel> createQuadra({
    required String arenaId,
    required String nome,
    String? tipoPiso,
    double? valorHora,
    bool coberta,
    bool iluminacao,
    bool ativa,
    String? observacoes,
  });
  Future<QuadraModel> updateQuadra({
    required String id,
    String? nome,
    String? tipoPiso,
    double? valorHora,
    bool? coberta,
    bool? iluminacao,
    bool? ativa,
    String? observacoes,
  });
  Future<void> deleteQuadra(String id);
  Future<QuadraModel> toggleQuadraStatus(String id, bool ativa);
}

class QuadraRemoteDataSourceImpl implements QuadraRemoteDataSource {
  final SupabaseClient supabaseClient;

  QuadraRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<QuadraModel>> getQuadrasByArena(String arenaId) async {
    try {
      final response = await supabaseClient.from('quadras').select().eq('arena_id', arenaId).order('nome', ascending: true);

      return (response as List).map((json) => QuadraModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Erro ao carregar quadras: $e');
    }
  }

  @override
  Future<QuadraModel> createQuadra({
    required String arenaId,
    required String nome,
    String? tipoPiso,
    double? valorHora,
    bool coberta = false,
    bool iluminacao = true,
    bool ativa = true,
    String? observacoes,
  }) async {
    try {
      final response = await supabaseClient
          .from('quadras')
          .insert({
            'arena_id': arenaId,
            'nome': nome,
            'tipo_piso': tipoPiso,
            'valor_hora': valorHora,
            'coberta': coberta,
            'iluminacao': iluminacao,
            'ativa': ativa,
            'observacoes': observacoes,
          })
          .select()
          .single();

      return QuadraModel.fromJson(response);
    } catch (e) {
      throw ServerException('Erro ao criar quadra: $e');
    }
  }

  @override
  Future<QuadraModel> updateQuadra({
    required String id,
    String? nome,
    String? tipoPiso,
    double? valorHora,
    bool? coberta,
    bool? iluminacao,
    bool? ativa,
    String? observacoes,
  }) async {
    try {
      final Map<String, dynamic> updates = {};

      if (nome != null) updates['nome'] = nome;
      if (tipoPiso != null) updates['tipo_piso'] = tipoPiso;
      if (valorHora != null) updates['valor_hora'] = valorHora;
      if (coberta != null) updates['coberta'] = coberta;
      if (iluminacao != null) updates['iluminacao'] = iluminacao;
      if (ativa != null) updates['ativa'] = ativa;
      if (observacoes != null) updates['observacoes'] = observacoes;

      final response = await supabaseClient.from('quadras').update(updates).eq('id', id).select().single();

      return QuadraModel.fromJson(response);
    } catch (e) {
      throw ServerException('Erro ao atualizar quadra: $e');
    }
  }

  @override
  Future<void> deleteQuadra(String id) async {
    try {
      await supabaseClient.from('quadras').delete().eq('id', id);
    } catch (e) {
      throw ServerException('Erro ao deletar quadra: $e');
    }
  }

  @override
  Future<QuadraModel> toggleQuadraStatus(String id, bool ativa) async {
    try {
      final response = await supabaseClient.from('quadras').update({'ativa': ativa}).eq('id', id).select().single();

      return QuadraModel.fromJson(response);
    } catch (e) {
      throw ServerException('Erro ao atualizar status da quadra: $e');
    }
  }
}
