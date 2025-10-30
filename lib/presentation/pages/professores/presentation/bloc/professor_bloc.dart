import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/get_professores_usecase.dart';
import 'professor_event.dart';
import 'professor_state.dart';

class ProfessorBloc extends Bloc<ProfessorEvent, ProfessorState> {
  final GetProfessoresUseCase getProfessoresUseCase;

  ProfessorBloc({
    required this.getProfessoresUseCase,
  }) : super(const ProfessorInitial()) {
    on<LoadProfessoresEvent>(_onLoadProfessores);
    on<SearchProfessoresEvent>(_onSearchProfessores);
    on<ClearFiltersEvent>(_onClearFilters);
  }

  /// Handler para carregar todos os professores
  Future<void> _onLoadProfessores(
    LoadProfessoresEvent event,
    Emitter<ProfessorState> emit,
  ) async {
    emit(const ProfessorLoading());

    final result = await getProfessoresUseCase();

    result.fold(
      (failure) => emit(ProfessorError(message: failure.message)),
      (professores) {
        if (professores.isEmpty) {
          emit(const ProfessorEmpty());
        } else {
          emit(ProfessorLoaded(professores: professores));
        }
      },
    );
  }

  /// Handler para buscar professores com filtros
  Future<void> _onSearchProfessores(
    SearchProfessoresEvent event,
    Emitter<ProfessorState> emit,
  ) async {
    emit(const ProfessorLoading());

    final result = await getProfessoresUseCase(
      cidade: event.cidade,
      estado: event.estado,
      precoMax: event.precoMax,
      ratingMin: event.ratingMin,
    );

    result.fold(
      (failure) => emit(ProfessorError(message: failure.message)),
      (professores) {
        if (professores.isEmpty) {
          emit(const ProfessorEmpty(
            message: 'Nenhum professor encontrado com os filtros aplicados',
          ));
        } else {
          emit(ProfessorLoaded(
            professores: professores,
            cidade: event.cidade,
            estado: event.estado,
          ));
        }
      },
    );
  }

  /// Handler para limpar filtros
  Future<void> _onClearFilters(
    ClearFiltersEvent event,
    Emitter<ProfessorState> emit,
  ) async {
    // Recarregar todos os professores
    add(const LoadProfessoresEvent());
  }
}
