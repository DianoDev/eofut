import '../../../../../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.nome,
    required super.email,
    super.telefone,
    super.fotoUrl,
    super.cidade,
    super.estado,
    super.dataNascimento,
    super.genero,
    super.nivelJogo,
    super.posicaoPreferida,
    super.bio,
    super.rating,
    super.totalAvaliacoes,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Criar UserModel a partir de JSON do Supabase
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      nome: json['nome'] as String,
      email: json['email'] as String,
      telefone: json['telefone'] as String?,
      fotoUrl: json['foto_url'] as String?,
      cidade: json['cidade'] as String?,
      estado: json['estado'] as String?,
      dataNascimento: json['data_nascimento'] != null ? DateTime.parse(json['data_nascimento'] as String) : null,
      genero: json['genero'] as String?,
      nivelJogo: json['nivel_jogo'] as String?,
      posicaoPreferida: json['posicao_preferida'] as String?,
      bio: json['bio'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalAvaliacoes: json['total_avaliacoes'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converter UserModel para JSON do Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'foto_url': fotoUrl,
      'cidade': cidade,
      'estado': estado,
      'data_nascimento': dataNascimento?.toIso8601String(),
      'genero': genero,
      'nivel_jogo': nivelJogo,
      'posicao_preferida': posicaoPreferida,
      'bio': bio,
      'rating': rating,
      'total_avaliacoes': totalAvaliacoes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Criar UserModel a partir de User Entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      nome: user.nome,
      email: user.email,
      telefone: user.telefone,
      fotoUrl: user.fotoUrl,
      cidade: user.cidade,
      estado: user.estado,
      dataNascimento: user.dataNascimento,
      genero: user.genero,
      nivelJogo: user.nivelJogo,
      posicaoPreferida: user.posicaoPreferida,
      bio: user.bio,
      rating: user.rating,
      totalAvaliacoes: user.totalAvaliacoes,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  /// Converter para User Entity
  User toEntity() {
    return User(
      id: id,
      nome: nome,
      email: email,
      telefone: telefone,
      fotoUrl: fotoUrl,
      cidade: cidade,
      estado: estado,
      dataNascimento: dataNascimento,
      genero: genero,
      nivelJogo: nivelJogo,
      posicaoPreferida: posicaoPreferida,
      bio: bio,
      rating: rating,
      totalAvaliacoes: totalAvaliacoes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
