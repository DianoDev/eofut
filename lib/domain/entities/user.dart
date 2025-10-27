import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String nome;
  final String email;
  final String? telefone;
  final String? fotoUrl;
  final String? cidade;
  final String? estado;
  final DateTime? dataNascimento;
  final String? genero;
  final String? nivelJogo;
  final String? posicaoPreferida;
  final String? bio;
  final double rating;
  final int totalAvaliacoes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
    this.fotoUrl,
    this.cidade,
    this.estado,
    this.dataNascimento,
    this.genero,
    this.nivelJogo,
    this.posicaoPreferida,
    this.bio,
    this.rating = 0.0,
    this.totalAvaliacoes = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        nome,
        email,
        telefone,
        fotoUrl,
        cidade,
        estado,
        dataNascimento,
        genero,
        nivelJogo,
        posicaoPreferida,
        bio,
        rating,
        totalAvaliacoes,
        createdAt,
        updatedAt,
      ];

  User copyWith({
    String? id,
    String? nome,
    String? email,
    String? telefone,
    String? fotoUrl,
    String? cidade,
    String? estado,
    DateTime? dataNascimento,
    String? genero,
    String? nivelJogo,
    String? posicaoPreferida,
    String? bio,
    double? rating,
    int? totalAvaliacoes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      genero: genero ?? this.genero,
      nivelJogo: nivelJogo ?? this.nivelJogo,
      posicaoPreferida: posicaoPreferida ?? this.posicaoPreferida,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      totalAvaliacoes: totalAvaliacoes ?? this.totalAvaliacoes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
