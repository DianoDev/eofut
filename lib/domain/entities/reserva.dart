import 'package:equatable/equatable.dart';

enum StatusReserva {
  pendente,
  confirmada,
  cancelada,
  concluida,
}

class Reserva extends Equatable {
  final String id;
  final String arenaId;
  final String usuarioId;
  final DateTime dataReserva;
  final String horaInicio;
  final String horaFim;
  final double valor;
  final StatusReserva status;
  final String? metodoPagamento;
  final bool pagamentoConfirmado;
  final String? observacoes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Reserva({
    required this.id,
    required this.arenaId,
    required this.usuarioId,
    required this.dataReserva,
    required this.horaInicio,
    required this.horaFim,
    required this.valor,
    this.status = StatusReserva.pendente,
    this.metodoPagamento,
    this.pagamentoConfirmado = false,
    this.observacoes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        arenaId,
        usuarioId,
        dataReserva,
        horaInicio,
        horaFim,
        valor,
        status,
        metodoPagamento,
        pagamentoConfirmado,
        observacoes,
        createdAt,
        updatedAt,
      ];

  Reserva copyWith({
    String? id,
    String? arenaId,
    String? usuarioId,
    DateTime? dataReserva,
    String? horaInicio,
    String? horaFim,
    double? valor,
    StatusReserva? status,
    String? metodoPagamento,
    bool? pagamentoConfirmado,
    String? observacoes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Reserva(
      id: id ?? this.id,
      arenaId: arenaId ?? this.arenaId,
      usuarioId: usuarioId ?? this.usuarioId,
      dataReserva: dataReserva ?? this.dataReserva,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFim: horaFim ?? this.horaFim,
      valor: valor ?? this.valor,
      status: status ?? this.status,
      metodoPagamento: metodoPagamento ?? this.metodoPagamento,
      pagamentoConfirmado: pagamentoConfirmado ?? this.pagamentoConfirmado,
      observacoes: observacoes ?? this.observacoes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
