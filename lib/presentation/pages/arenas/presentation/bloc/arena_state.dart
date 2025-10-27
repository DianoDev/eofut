import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/arena.dart';

abstract class ArenaState extends Equatable {
  const ArenaState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class ArenaInitial extends ArenaState {
  const ArenaInitial();
}

/// Estado de carregamento
class ArenaLoading extends ArenaState {
  const ArenaLoading();
}

/// Estado com arenas carregadas
class ArenaLoaded extends ArenaState {
  final List<Arena> arenas;
  final String? cidade;
  final String? estado;

  const ArenaLoaded({
    required this.arenas,
    this.cidade,
    this.estado,
  });

  @override
  List<Object?> get props => [arenas, cidade, estado];
}

/// Estado vazio (sem arenas)
class ArenaEmpty extends ArenaState {
  final String message;

  const ArenaEmpty({
    this.message = 'Nenhuma arena encontrada',
  });

  @override
  List<Object?> get props => [message];
}

/// Estado de erro
class ArenaError extends ArenaState {
  final String message;

  const ArenaError({required this.message});

  @override
  List<Object?> get props => [message];
}
