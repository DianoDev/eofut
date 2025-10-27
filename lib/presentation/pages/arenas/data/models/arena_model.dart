import 'package:eofut/domain/entities/arena.dart';

class ArenaModel extends Arena {
  ArenaModel({
    required super.id,
    required super.nome,
    required super.descricao,
    required super.endereco,
    required super.cidade,
    required super.estado,
    super.cep,
    super.latitude,
    super.longitude,
    super.telefone,
    super.whatsapp,
    super.fotos,
    required super.valorHora,
    super.numeroQuadras,
    super.comodidades,
    super.rating,
    super.totalAvaliacoes,
    super.ativo,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ArenaModel.fromJson(Map<String, dynamic> json) {
    return ArenaModel(
      id: json['id'].toString(),
      nome: json['nome'] as String,
      descricao: json['descricao'] as String? ?? '',
      endereco: json['endereco'] as String,
      cidade: json['cidade'] as String,
      estado: json['estado'] as String,
      cep: json['cep'] as String?,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      telefone: json['telefone'] as String?,
      whatsapp: json['whatsapp'] as String?,
      fotos: json['fotos'] != null ? List<String>.from(json['fotos'] as List) : [],
      valorHora: (json['valor_hora'] as num).toDouble(),
      numeroQuadras: json['numero_quadras'] as int? ?? 1,
      comodidades: json['comodidades'] != null ? List<String>.from(json['comodidades'] as List) : [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalAvaliacoes: json['total_avaliacoes'] as int? ?? 0,
      ativo: json['ativo'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'endereco': endereco,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
      'latitude': latitude,
      'longitude': longitude,
      'telefone': telefone,
      'whatsapp': whatsapp,
      'fotos': fotos,
      'valor_hora': valorHora,
      'numero_quadras': numeroQuadras,
      'comodidades': comodidades,
      'rating': rating,
      'total_avaliacoes': totalAvaliacoes,
      'ativo': ativo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Arena toEntity() {
    return Arena(
      id: id,
      nome: nome,
      descricao: descricao,
      endereco: endereco,
      cidade: cidade,
      estado: estado,
      cep: cep,
      latitude: latitude,
      longitude: longitude,
      telefone: telefone,
      whatsapp: whatsapp,
      fotos: fotos,
      valorHora: valorHora,
      numeroQuadras: numeroQuadras,
      comodidades: comodidades,
      rating: rating,
      totalAvaliacoes: totalAvaliacoes,
      ativo: ativo,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
