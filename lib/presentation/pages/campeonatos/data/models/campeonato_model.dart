import '../../domain/entities/campeonato.dart';

class CampeonatoModel extends Campeonato {
  CampeonatoModel({
    required super.id,
    required super.nome,
    required super.descricao,
    required super.dataInicio,
    required super.dataFim,
    super.localArenaId,
    required super.organizadorId,
    required super.cidade,
    required super.estado,
    super.categorias,
    super.nivelMinimo,
    required super.vagas,
    required super.valorInscricao,
    super.status,
    super.premiacao,
    super.regras,
    super.fotos,
    super.totalInscritos,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CampeonatoModel.fromJson(Map<String, dynamic> json) {
    return CampeonatoModel(
      id: json['id'].toString(),
      nome: json['nome'] as String,
      descricao: json['descricao'] as String? ?? '',
      dataInicio: DateTime.parse(json['data_inicio'] as String),
      dataFim: DateTime.parse(json['data_fim'] as String),
      localArenaId: json['local_arena_id'] as String?,
      organizadorId: json['organizador_id'] as String,
      cidade: json['cidade'] as String,
      estado: json['estado'] as String,
      categorias: json['categorias'] != null
          ? List<String>.from(json['categorias'] as List)
          : [],
      nivelMinimo: json['nivel_minimo'] as String?,
      vagas: json['vagas'] as int,
      valorInscricao: (json['valor_inscricao'] as num).toDouble(),
      status: _stringToStatus(json['status'] as String? ?? 'aberto'),
      premiacao: json['premiacao'] as String?,
      regras: json['regras'] as String?,
      fotos: json['fotos'] != null
          ? List<String>.from(json['fotos'] as List)
          : [],
      totalInscritos: json['total_inscritos'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'data_inicio': dataInicio.toIso8601String(),
      'data_fim': dataFim.toIso8601String(),
      'local_arena_id': localArenaId,
      'organizador_id': organizadorId,
      'cidade': cidade,
      'estado': estado,
      'categorias': categorias,
      'nivel_minimo': nivelMinimo,
      'vagas': vagas,
      'valor_inscricao': valorInscricao,
      'status': _statusToString(status),
      'premiacao': premiacao,
      'regras': regras,
      'fotos': fotos,
      'total_inscritos': totalInscritos,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Campeonato toEntity() {
    return Campeonato(
      id: id,
      nome: nome,
      descricao: descricao,
      dataInicio: dataInicio,
      dataFim: dataFim,
      localArenaId: localArenaId,
      organizadorId: organizadorId,
      cidade: cidade,
      estado: estado,
      categorias: categorias,
      nivelMinimo: nivelMinimo,
      vagas: vagas,
      valorInscricao: valorInscricao,
      status: status,
      premiacao: premiacao,
      regras: regras,
      fotos: fotos,
      totalInscritos: totalInscritos,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static StatusCampeonato _stringToStatus(String status) {
    switch (status.toLowerCase()) {
      case 'fechado':
        return StatusCampeonato.fechado;
      case 'cancelado':
        return StatusCampeonato.cancelado;
      case 'concluido':
      case 'concluído':
        return StatusCampeonato.concluido;
      case 'aberto':
      default:
        return StatusCampeonato.aberto;
    }
  }

  static String _statusToString(StatusCampeonato status) {
    switch (status) {
      case StatusCampeonato.aberto:
        return 'aberto';
      case StatusCampeonato.fechado:
        return 'fechado';
      case StatusCampeonato.cancelado:
        return 'cancelado';
      case StatusCampeonato.concluido:
        return 'concluido';
    }
  }
}
