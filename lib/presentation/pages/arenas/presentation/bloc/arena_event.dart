import 'package:equatable/equatable.dart';

abstract class ArenaEvent extends Equatable {
  const ArenaEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para carregar todas as arenas
class LoadArenasEvent extends ArenaEvent {
  const LoadArenasEvent();
}

/// Evento para buscar arenas com filtros
class SearchArenasEvent extends ArenaEvent {
  final String? cidade;
  final String? estado;
  final double? precoMax;
  final double? ratingMin;

  const SearchArenasEvent({
    this.cidade,
    this.estado,
    this.precoMax,
    this.ratingMin,
  });

  @override
  List<Object?> get props => [cidade, estado, precoMax, ratingMin];
}

/// Evento para limpar filtros
class ClearFiltersEvent extends ArenaEvent {
  const ClearFiltersEvent();
}
