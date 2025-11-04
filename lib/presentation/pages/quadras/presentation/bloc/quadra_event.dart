import 'package:equatable/equatable.dart';

abstract class QuadraEvent extends Equatable {
  const QuadraEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuadras extends QuadraEvent {
  final String arenaId;

  const LoadQuadras(this.arenaId);

  @override
  List<Object?> get props => [arenaId];
}

class CreateQuadra extends QuadraEvent {
  final String arenaId;
  final String nome;
  final String? tipoPiso;
  final double? valorHora;
  final bool coberta;
  final bool iluminacao;
  final bool ativa;
  final String? observacoes;

  const CreateQuadra({
    required this.arenaId,
    required this.nome,
    this.tipoPiso,
    this.valorHora,
    this.coberta = false,
    this.iluminacao = true,
    this.ativa = true,
    this.observacoes,
  });

  @override
  List<Object?> get props => [
        arenaId,
        nome,
        tipoPiso,
        valorHora,
        coberta,
        iluminacao,
        ativa,
        observacoes,
      ];
}

class UpdateQuadra extends QuadraEvent {
  final String id;
  final String? nome;
  final String? tipoPiso;
  final double? valorHora;
  final bool? coberta;
  final bool? iluminacao;
  final bool? ativa;
  final String? observacoes;

  const UpdateQuadra({
    required this.id,
    this.nome,
    this.tipoPiso,
    this.valorHora,
    this.coberta,
    this.iluminacao,
    this.ativa,
    this.observacoes,
  });

  @override
  List<Object?> get props => [
        id,
        nome,
        tipoPiso,
        valorHora,
        coberta,
        iluminacao,
        ativa,
        observacoes,
      ];
}

class DeleteQuadra extends QuadraEvent {
  final String id;

  const DeleteQuadra(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleQuadraStatus extends QuadraEvent {
  final String id;
  final bool ativa;

  const ToggleQuadraStatus(this.id, this.ativa);

  @override
  List<Object?> get props => [id, ativa];
}
