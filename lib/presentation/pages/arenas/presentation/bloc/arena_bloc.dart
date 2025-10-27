import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/get_arenas_usecase.dart';
import 'arena_event.dart';
import 'arena_state.dart';

class ArenaBloc extends Bloc<ArenaEvent, ArenaState> {
  final GetArenasUseCase getArenasUseCase;

  ArenaBloc({
    required this.getArenasUseCase,
  }) : super(const ArenaInitial()) {
    on<LoadArenasEvent>(_onLoadArenas);
    on<SearchArenasEvent>(_onSearchArenas);
    on<ClearFiltersEvent>(_onClearFilters);
  }

  /// Handler para carregar todas as arenas
  Future<void> _onLoadArenas(
    LoadArenasEvent event,
    Emitter<ArenaState> emit,
  ) async {
    emit(const ArenaLoading());

    final result = await getArenasUseCase();

    result.fold(
      (failure) => emit(ArenaError(message: failure.message)),
      (arenas) {
        if (arenas.isEmpty) {
          emit(const ArenaEmpty());
        } else {
          emit(ArenaLoaded(arenas: arenas));
        }
      },
    );
  }

  /// Handler para buscar arenas com filtros
  Future<void> _onSearchArenas(
    SearchArenasEvent event,
    Emitter<ArenaState> emit,
  ) async {
    emit(const ArenaLoading());

    final result = await getArenasUseCase(
      cidade: event.cidade,
      estado: event.estado,
      precoMax: event.precoMax,
      ratingMin: event.ratingMin,
    );

    result.fold(
      (failure) => emit(ArenaError(message: failure.message)),
      (arenas) {
        if (arenas.isEmpty) {
          emit(const ArenaEmpty(
            message: 'Nenhuma arena encontrada com os filtros aplicados',
          ));
        } else {
          emit(ArenaLoaded(
            arenas: arenas,
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
    Emitter<ArenaState> emit,
  ) async {
    // Recarregar todas as arenas
    add(const LoadArenasEvent());
  }
}
