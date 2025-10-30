import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/professor.dart';

abstract class ProfessorState extends Equatable {
  const ProfessorState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class ProfessorInitial extends ProfessorState {
  const ProfessorInitial();
}

/// Estado de carregamento
class ProfessorLoading extends ProfessorState {
  const ProfessorLoading();
}

/// Estado com professores carregados
class ProfessorLoaded extends ProfessorState {
  final List<Professor> professores;
  final String? cidade;
  final String? estado;

  const ProfessorLoaded({
    required this.professores,
    this.cidade,
    this.estado,
  });

  @override
  List<Object?> get props => [professores, cidade, estado];
}

/// Estado vazio (sem professores)
class ProfessorEmpty extends ProfessorState {
  final String message;

  const ProfessorEmpty({
    this.message = 'Nenhum professor encontrado',
  });

  @override
  List<Object?> get props => [message];
}

/// Estado de erro
class ProfessorError extends ProfessorState {
  final String message;

  const ProfessorError({required this.message});

  @override
  List<Object?> get props => [message];
}
