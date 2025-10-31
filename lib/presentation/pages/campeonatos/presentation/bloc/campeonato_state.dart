import 'package:equatable/equatable.dart';
import '../../domain/entities/campeonato.dart';

abstract class CampeonatoState extends Equatable {
  const CampeonatoState();

  @override
  List<Object?> get props => [];
}

class CampeonatoInitial extends CampeonatoState {
  const CampeonatoInitial();
}

class CampeonatoLoading extends CampeonatoState {
  const CampeonatoLoading();
}

class CampeonatosLoaded extends CampeonatoState {
  final List<Campeonato> campeonatos;
  final String? cidade;
  final String? estado;
  final String? status;

  const CampeonatosLoaded({
    required this.campeonatos,
    this.cidade,
    this.estado,
    this.status,
  });

  @override
  List<Object?> get props => [campeonatos, cidade, estado, status];
}

class CampeonatoDetailLoaded extends CampeonatoState {
  final Campeonato campeonato;

  const CampeonatoDetailLoaded({required this.campeonato});

  @override
  List<Object?> get props => [campeonato];
}

class CampeonatoEmpty extends CampeonatoState {
  final String message;

  const CampeonatoEmpty({
    this.message = 'Nenhum campeonato encontrado',
  });

  @override
  List<Object?> get props => [message];
}

class CampeonatoError extends CampeonatoState {
  final String message;

  const CampeonatoError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CampeonatoCreated extends CampeonatoState {
  final Campeonato campeonato;

  const CampeonatoCreated({required this.campeonato});

  @override
  List<Object?> get props => [campeonato];
}

class CampeonatoUpdated extends CampeonatoState {
  final Campeonato campeonato;

  const CampeonatoUpdated({required this.campeonato});

  @override
  List<Object?> get props => [campeonato];
}

class CampeonatoDeleted extends CampeonatoState {
  const CampeonatoDeleted();
}
