import 'package:equatable/equatable.dart';

abstract class ProfessorEvent extends Equatable {
  const ProfessorEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para carregar todos os professores
class LoadProfessoresEvent extends ProfessorEvent {
  const LoadProfessoresEvent();
}

/// Evento para buscar professores com filtros
class SearchProfessoresEvent extends ProfessorEvent {
  final String? cidade;
  final String? estado;
  final double? precoMax;
  final double? ratingMin;

  const SearchProfessoresEvent({
    this.cidade,
    this.estado,
    this.precoMax,
    this.ratingMin,
  });

  @override
  List<Object?> get props => [cidade, estado, precoMax, ratingMin];
}

/// Evento para limpar filtros
class ClearFiltersEvent extends ProfessorEvent {
  const ClearFiltersEvent();
}
