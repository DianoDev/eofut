import 'package:equatable/equatable.dart';

class Quadra extends Equatable {
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

  const Quadra({
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

  @override
  List<Object?> get props => [
        id,
        arenaId,
        nome,
        tipoPiso,
        valorHora,
        coberta,
        iluminacao,
        ativa,
        observacoes,
        createdAt,
        updatedAt,
      ];
}
