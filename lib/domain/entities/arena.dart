import 'package:equatable/equatable.dart';

class Arena extends Equatable {
  final String id;
  final String nome;
  final String descricao;
  final String endereco;
  final String cidade;
  final String estado;
  final String? cep;
  final double? latitude;
  final double? longitude;
  final String? telefone;
  final String? whatsapp;
  final List<String> fotos;
  final double valorHora;
  final int numeroQuadras;
  final List<String> comodidades;
  final double rating;
  final int totalAvaliacoes;
  final bool ativo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Arena({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.endereco,
    required this.cidade,
    required this.estado,
    this.cep,
    this.latitude,
    this.longitude,
    this.telefone,
    this.whatsapp,
    this.fotos = const [],
    required this.valorHora,
    this.numeroQuadras = 1,
    this.comodidades = const [],
    this.rating = 0.0,
    this.totalAvaliacoes = 0,
    this.ativo = true,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        nome,
        descricao,
        endereco,
        cidade,
        estado,
        cep,
        latitude,
        longitude,
        telefone,
        whatsapp,
        fotos,
        valorHora,
        numeroQuadras,
        comodidades,
        rating,
        totalAvaliacoes,
        ativo,
        createdAt,
        updatedAt,
      ];

  // Calcular distância (útil para ordenação)
  double? distanciaKm;

  Arena copyWith({
    String? id,
    String? nome,
    String? descricao,
    String? endereco,
    String? cidade,
    String? estado,
    String? cep,
    double? latitude,
    double? longitude,
    String? telefone,
    String? whatsapp,
    List<String>? fotos,
    double? valorHora,
    int? numeroQuadras,
    List<String>? comodidades,
    double? rating,
    int? totalAvaliacoes,
    bool? ativo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Arena(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      endereco: endereco ?? this.endereco,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      cep: cep ?? this.cep,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      telefone: telefone ?? this.telefone,
      whatsapp: whatsapp ?? this.whatsapp,
      fotos: fotos ?? this.fotos,
      valorHora: valorHora ?? this.valorHora,
      numeroQuadras: numeroQuadras ?? this.numeroQuadras,
      comodidades: comodidades ?? this.comodidades,
      rating: rating ?? this.rating,
      totalAvaliacoes: totalAvaliacoes ?? this.totalAvaliacoes,
      ativo: ativo ?? this.ativo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
