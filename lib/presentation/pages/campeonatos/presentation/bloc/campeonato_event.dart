import 'package:equatable/equatable.dart';

abstract class CampeonatoEvent extends Equatable {
  const CampeonatoEvent();

  @override
  List<Object?> get props => [];
}

class LoadCampeonatosEvent extends CampeonatoEvent {
  const LoadCampeonatosEvent();
}

class LoadMeusCampeonatosEvent extends CampeonatoEvent {
  final String organizadorId;

  const LoadMeusCampeonatosEvent({required this.organizadorId});

  @override
  List<Object?> get props => [organizadorId];
}

class LoadCampeonatoByIdEvent extends CampeonatoEvent {
  final String id;

  const LoadCampeonatoByIdEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class SearchCampeonatosEvent extends CampeonatoEvent {
  final String? cidade;
  final String? estado;
  final String? status;

  const SearchCampeonatosEvent({
    this.cidade,
    this.estado,
    this.status,
  });

  @override
  List<Object?> get props => [cidade, estado, status];
}

class CreateCampeonatoEvent extends CampeonatoEvent {
  final String nome;
  final String descricao;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String? localArenaId;
  final String organizadorId;
  final String cidade;
  final String estado;
  final List<String>? categorias;
  final String? nivelMinimo;
  final int vagas;
  final double valorInscricao;
  final String? premiacao;
  final String? regras;
  final List<String>? fotos;

  const CreateCampeonatoEvent({
    required this.nome,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    this.localArenaId,
    required this.organizadorId,
    required this.cidade,
    required this.estado,
    this.categorias,
    this.nivelMinimo,
    required this.vagas,
    required this.valorInscricao,
    this.premiacao,
    this.regras,
    this.fotos,
  });

  @override
  List<Object?> get props => [
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
        premiacao,
        regras,
        fotos,
      ];
}

class UpdateCampeonatoEvent extends CampeonatoEvent {
  final String id;
  final String? nome;
  final String? descricao;
  final DateTime? dataInicio;
  final DateTime? dataFim;
  final String? localArenaId;
  final String? cidade;
  final String? estado;
  final List<String>? categorias;
  final String? nivelMinimo;
  final int? vagas;
  final double? valorInscricao;
  final String? status;
  final String? premiacao;
  final String? regras;
  final List<String>? fotos;

  const UpdateCampeonatoEvent({
    required this.id,
    this.nome,
    this.descricao,
    this.dataInicio,
    this.dataFim,
    this.localArenaId,
    this.cidade,
    this.estado,
    this.categorias,
    this.nivelMinimo,
    this.vagas,
    this.valorInscricao,
    this.status,
    this.premiacao,
    this.regras,
    this.fotos,
  });

  @override
  List<Object?> get props => [
        id,
        nome,
        descricao,
        dataInicio,
        dataFim,
        localArenaId,
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
      ];
}

class DeleteCampeonatoEvent extends CampeonatoEvent {
  final String id;

  const DeleteCampeonatoEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
