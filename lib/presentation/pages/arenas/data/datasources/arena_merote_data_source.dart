import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/constants/api_constants.dart';
import '../models/arena_model.dart';

abstract class ArenaRemoteDataSource {
  Future<List<ArenaModel>> getArenas({
    String? cidade,
    String? estado,
  });

  Future<ArenaModel> getArenaById(String id);
}

class ArenaRemoteDataSourceImpl implements ArenaRemoteDataSource {
  final SupabaseClient supabaseClient;

  ArenaRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<ArenaModel>> getArenas({
    String? cidade,
    String? estado,
  }) async {
    try {
      var query = supabaseClient.from(ApiConstants.tableArenas).select().eq('ativo', true);

      if (cidade != null && cidade.isNotEmpty) {
        query = query.eq('cidade', cidade);
      }

      if (estado != null && estado.isNotEmpty) {
        query = query.eq('estado', estado);
      }

      final response = await query.order('nome', ascending: true);

      return (response as List).map((json) => ArenaModel.fromJson(json as Map<String, dynamic>)).toList();
    } on PostgrestException catch (e) {
      throw ServerException('Erro ao buscar arenas: ${e.message}');
    } catch (e) {
      throw ServerException('Erro ao buscar arenas: $e');
    }
  }

  @override
  Future<ArenaModel> getArenaById(String id) async {
    try {
      final response = await supabaseClient.from(ApiConstants.tableArenas).select().eq('id', id).single();

      return ArenaModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException('Erro ao buscar arena: ${e.message}');
    } catch (e) {
      throw ServerException('Erro ao buscar arena: $e');
    }
  }
}
