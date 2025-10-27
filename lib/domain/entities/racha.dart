import 'package:equatable/equatable.dart';

enum StatusRacha {
  aberto,
  fechado,
  cancelado,
}

class Racha extends Equatable {
  final String id;
  final String criadorId;
  final String? arenaId;
  final DateTime dataJogo;
  final String horaJogo;
  final String? nivelDesejado;
  final int vagas;
  final String? descricao;
  final StatusRacha status;
  final String? cidade;
  final DateTime createdAt;

  const Racha({
    required this.id,
    required this.criadorId,
    this.arenaId,
    required this.dataJogo,
    required this.horaJogo,
    this.nivelDesejado,
    required this.vagas,
    this.descricao,
    this.status = StatusRacha.aberto,
    this.cidade,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        criadorId,
        arenaId,
        dataJogo,
        horaJogo,
        nivelDesejado,
        vagas,
        descricao,
        status,
        cidade,
        createdAt,
      ];

  Racha copyWith({
    String? id,
    String? criadorId,
    String? arenaId,
    DateTime? dataJogo,
    String? horaJogo,
    String? nivelDesejado,
    int? vagas,
    String? descricao,
    StatusRacha? status,
    String? cidade,
    DateTime? createdAt,
  }) {
    return Racha(
      id: id ?? this.id,
      criadorId: criadorId ?? this.criadorId,
      arenaId: arenaId ?? this.arenaId,
      dataJogo: dataJogo ?? this.dataJogo,
      horaJogo: horaJogo ?? this.horaJogo,
      nivelDesejado: nivelDesejado ?? this.nivelDesejado,
      vagas: vagas ?? this.vagas,
      descricao: descricao ?? this.descricao,
      status: status ?? this.status,
      cidade: cidade ?? this.cidade,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
