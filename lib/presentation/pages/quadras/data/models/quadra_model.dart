import 'package:eofut/domain/entities/quadra.dart';

class QuadraModel {
  final String id;
  final String arenaId;
  final String nome;
  final String? tipoPiso;
  final double? valorHora;
  final bool coberta;
  final bool iluminacao;
  final bool ativa;
  final String? observacoes;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuadraModel({
    required this.id,
    required this.arenaId,
    required this.nome,
    this.tipoPiso,
    this.valorHora,
    this.coberta = false,
    this.iluminacao = true,
    this.ativa = true,
    this.observacoes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuadraModel.fromJson(Map<String, dynamic> json) {
    return QuadraModel(
      id: json['id'] as String,
      arenaId: json['arena_id'] as String,
      nome: json['nome'] as String,
      tipoPiso: json['tipo_piso'] as String?,
      valorHora: json['valor_hora'] != null ? (json['valor_hora'] as num).toDouble() : null,
      coberta: json['coberta'] as bool? ?? false,
      iluminacao: json['iluminacao'] as bool? ?? true,
      ativa: json['ativa'] as bool? ?? true,
      observacoes: json['observacoes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arena_id': arenaId,
      'nome': nome,
      'tipo_piso': tipoPiso,
      'valor_hora': valorHora,
      'coberta': coberta,
      'iluminacao': iluminacao,
      'ativa': ativa,
      'observacoes': observacoes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Quadra toEntity() {
    return Quadra(
      id: id,
      arenaId: arenaId,
      nome: nome,
      tipoPiso: tipoPiso,
      valorHora: valorHora,
      coberta: coberta,
      iluminacao: iluminacao,
      ativa: ativa,
      observacoes: observacoes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory QuadraModel.fromEntity(Quadra entity) {
    return QuadraModel(
      id: entity.id,
      arenaId: entity.arenaId,
      nome: entity.nome,
      tipoPiso: entity.tipoPiso,
      valorHora: entity.valorHora,
      coberta: entity.coberta,
      iluminacao: entity.iluminacao,
      ativa: entity.ativa,
      observacoes: entity.observacoes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
