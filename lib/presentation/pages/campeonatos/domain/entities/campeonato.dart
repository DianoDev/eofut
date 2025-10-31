import 'package:equatable/equatable.dart';

enum StatusCampeonato {
  aberto,
  fechado,
  cancelado,
  concluido,
}

class Campeonato extends Equatable {
  final String id;
  final String nome;
  final String descricao;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String? localArenaId;
  final String organizadorId;
  final String cidade;
  final String estado;
  final List<String> categorias;
  final String? nivelMinimo;
  final int vagas;
  final double valorInscricao;
  final StatusCampeonato status;
  final String? premiacao;
  final String? regras;
  final List<String> fotos;
  final int totalInscritos;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Campeonato({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    this.localArenaId,
    required this.organizadorId,
    required this.cidade,
    required this.estado,
    this.categorias = const [],
    this.nivelMinimo,
    required this.vagas,
    required this.valorInscricao,
    this.status = StatusCampeonato.aberto,
    this.premiacao,
    this.regras,
    this.fotos = const [],
    this.totalInscritos = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        nome,
        descricao,
        dataInicio,
        dataFim,
        localArenaId,
        organizadorId,
        cidade,
        estado,
        categorias,
        nivelMinimo,
        vagas,
        valorInscricao,
        status,
        premiacao,
        regras,
        fotos,
        totalInscritos,
        createdAt,
        updatedAt,
      ];

  bool get isAberto => status == StatusCampeonato.aberto;
  bool get isFechado => status == StatusCampeonato.fechado;
  bool get isCancelado => status == StatusCampeonato.cancelado;
  bool get isConcluido => status == StatusCampeonato.concluido;
  bool get temVagas => totalInscritos < vagas;

  Campeonato copyWith({
    String? id,
    String? nome,
    String? descricao,
    DateTime? dataInicio,
    DateTime? dataFim,
    String? localArenaId,
    String? organizadorId,
    String? cidade,
    String? estado,
    List<String>? categorias,
    String? nivelMinimo,
    int? vagas,
    double? valorInscricao,
    StatusCampeonato? status,
    String? premiacao,
    String? regras,
    List<String>? fotos,
    int? totalInscritos,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Campeonato(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      localArenaId: localArenaId ?? this.localArenaId,
      organizadorId: organizadorId ?? this.organizadorId,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      categorias: categorias ?? this.categorias,
      nivelMinimo: nivelMinimo ?? this.nivelMinimo,
      vagas: vagas ?? this.vagas,
      valorInscricao: valorInscricao ?? this.valorInscricao,
      status: status ?? this.status,
      premiacao: premiacao ?? this.premiacao,
      regras: regras ?? this.regras,
      fotos: fotos ?? this.fotos,
      totalInscritos: totalInscritos ?? this.totalInscritos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
