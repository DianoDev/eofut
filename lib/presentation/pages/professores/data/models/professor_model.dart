import 'package:eofut/domain/entities/professor.dart';

class ProfessorModel extends Professor {
  ProfessorModel({
    required super.id,
    required super.userId,
    required super.nome,
    super.fotoUrl,
    super.certificacoes,
    required super.experienciaAnos,
    super.especialidades,
    required super.valorHoraAula,
    super.descricao,
    super.disponibilidade,
    super.rating,
    super.totalAvaliacoes,
    super.ativo,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProfessorModel.fromJson(Map<String, dynamic> json) {
    // Extrair dados do usuário (join)
    final userData = json['users'] as Map<String, dynamic>?;

    return ProfessorModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      nome: userData?['nome'] as String? ?? 'Professor',
      fotoUrl: userData?['foto_url'] as String?,
      certificacoes: json['certificacoes'] != null ? List<String>.from(json['certificacoes'] as List) : [],
      experienciaAnos: json['experiencia_anos'] as int? ?? 0,
      especialidades: json['especialidades'] != null ? List<String>.from(json['especialidades'] as List) : [],
      valorHoraAula: (json['valor_hora_aula'] as num).toDouble(),
      descricao: json['descricao'] as String?,
      disponibilidade: json['disponibilidade'] != null
          ? Map<String, List<String>>.from(
              (json['disponibilidade'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  List<String>.from(value as List),
                ),
              ),
            )
          : null,
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
      'user_id': userId,
      'certificacoes': certificacoes,
      'experiencia_anos': experienciaAnos,
      'especialidades': especialidades,
      'valor_hora_aula': valorHoraAula,
      'descricao': descricao,
      'disponibilidade': disponibilidade,
      'rating': rating,
      'total_avaliacoes': totalAvaliacoes,
      'ativo': ativo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Professor toEntity() {
    return Professor(
      id: id,
      userId: userId,
      nome: nome,
      fotoUrl: fotoUrl,
      certificacoes: certificacoes,
      experienciaAnos: experienciaAnos,
      especialidades: especialidades,
      valorHoraAula: valorHoraAula,
      descricao: descricao,
      disponibilidade: disponibilidade,
      rating: rating,
      totalAvaliacoes: totalAvaliacoes,
      ativo: ativo,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
