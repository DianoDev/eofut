import 'package:equatable/equatable.dart';

class Professor extends Equatable {
  final String id;
  final String userId;
  final String nome; // Vai vir do join com users
  final String? fotoUrl; // Vai vir do join com users
  final List<String> certificacoes;
  final int experienciaAnos;
  final List<String> especialidades;
  final double valorHoraAula;
  final String? descricao;
  final Map<String, List<String>>? disponibilidade;
  final double rating;
  final int totalAvaliacoes;
  final bool ativo;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Professor({
    required this.id,
    required this.userId,
    required this.nome,
    this.fotoUrl,
    this.certificacoes = const [],
    required this.experienciaAnos,
    this.especialidades = const [],
    required this.valorHoraAula,
    this.descricao,
    this.disponibilidade,
    this.rating = 0.0,
    this.totalAvaliacoes = 0,
    this.ativo = true,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        nome,
        fotoUrl,
        certificacoes,
        experienciaAnos,
        especialidades,
        valorHoraAula,
        descricao,
        disponibilidade,
        rating,
        totalAvaliacoes,
        ativo,
        createdAt,
        updatedAt,
      ];

  Professor copyWith({
    String? id,
    String? userId,
    String? nome,
    String? fotoUrl,
    List<String>? certificacoes,
    int? experienciaAnos,
    List<String>? especialidades,
    double? valorHoraAula,
    String? descricao,
    Map<String, List<String>>? disponibilidade,
    double? rating,
    int? totalAvaliacoes,
    bool? ativo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Professor(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nome: nome ?? this.nome,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      certificacoes: certificacoes ?? this.certificacoes,
      experienciaAnos: experienciaAnos ?? this.experienciaAnos,
      especialidades: especialidades ?? this.especialidades,
      valorHoraAula: valorHoraAula ?? this.valorHoraAula,
      descricao: descricao ?? this.descricao,
      disponibilidade: disponibilidade ?? this.disponibilidade,
      rating: rating ?? this.rating,
      totalAvaliacoes: totalAvaliacoes ?? this.totalAvaliacoes,
      ativo: ativo ?? this.ativo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
