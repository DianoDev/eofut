import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eofut/presentation/pages/quadras/domain/get_quadras_by_arena_usecase.dart';
import 'package:eofut/presentation/pages/quadras/domain/create_quadra_usecase.dart';
import 'package:eofut/presentation/pages/quadras/domain/update_quadra_usecase.dart';
import 'package:eofut/presentation/pages/quadras/domain/delete_quadra_usecase.dart';
import 'package:eofut/presentation/pages/quadras/domain/toggle_quadra_status_usecase.dart';
import 'quadra_event.dart';
import 'quadra_state.dart';

class QuadraBloc extends Bloc<QuadraEvent, QuadraState> {
  final GetQuadrasByArenaUseCase getQuadrasByArenaUseCase;
  final CreateQuadraUseCase createQuadraUseCase;
  final UpdateQuadraUseCase updateQuadraUseCase;
  final DeleteQuadraUseCase deleteQuadraUseCase;
  final ToggleQuadraStatusUseCase toggleQuadraStatusUseCase;

  QuadraBloc({
    required this.getQuadrasByArenaUseCase,
    required this.createQuadraUseCase,
    required this.updateQuadraUseCase,
    required this.deleteQuadraUseCase,
    required this.toggleQuadraStatusUseCase,
  }) : super(QuadraInitial()) {
    on<LoadQuadras>(_onLoadQuadras);
    on<CreateQuadra>(_onCreateQuadra);
    on<UpdateQuadra>(_onUpdateQuadra);
    on<DeleteQuadra>(_onDeleteQuadra);
    on<ToggleQuadraStatus>(_onToggleQuadraStatus);
  }

  Future<void> _onLoadQuadras(
    LoadQuadras event,
    Emitter<QuadraState> emit,
  ) async {
    emit(QuadraLoading());
    final result = await getQuadrasByArenaUseCase(event.arenaId);
    result.fold(
      (failure) => emit(QuadraError(failure.message)),
      (quadras) => emit(QuadrasLoaded(quadras)),
    );
  }

  Future<void> _onCreateQuadra(
    CreateQuadra event,
    Emitter<QuadraState> emit,
  ) async {
    emit(QuadraLoading());
    final result = await createQuadraUseCase(
      arenaId: event.arenaId,
      nome: event.nome,
      tipoPiso: event.tipoPiso,
      valorHora: event.valorHora,
      coberta: event.coberta,
      iluminacao: event.iluminacao,
      ativa: event.ativa,
      observacoes: event.observacoes,
    );
    result.fold(
      (failure) => emit(QuadraError(failure.message)),
      (_) {
        emit(const QuadraOperationSuccess('Quadra criada com sucesso!'));
        add(LoadQuadras(event.arenaId));
      },
    );
  }

  Future<void> _onUpdateQuadra(
    UpdateQuadra event,
    Emitter<QuadraState> emit,
  ) async {
    final currentState = state;
    emit(QuadraLoading());
    final result = await updateQuadraUseCase(
      id: event.id,
      nome: event.nome,
      tipoPiso: event.tipoPiso,
      valorHora: event.valorHora,
      coberta: event.coberta,
      iluminacao: event.iluminacao,
      ativa: event.ativa,
      observacoes: event.observacoes,
    );
    result.fold(
      (failure) => emit(QuadraError(failure.message)),
      (_) {
        emit(const QuadraOperationSuccess('Quadra atualizada com sucesso!'));
        if (currentState is QuadrasLoaded) {
          final quadras = currentState.quadras;
          if (quadras.isNotEmpty) {
            add(LoadQuadras(quadras.first.arenaId));
          }
        }
      },
    );
  }

  Future<void> _onDeleteQuadra(
    DeleteQuadra event,
    Emitter<QuadraState> emit,
  ) async {
    final currentState = state;
    emit(QuadraLoading());
    final result = await deleteQuadraUseCase(event.id);
    result.fold(
      (failure) => emit(QuadraError(failure.message)),
      (_) {
        emit(const QuadraOperationSuccess('Quadra deletada com sucesso!'));
        if (currentState is QuadrasLoaded) {
          final quadras = currentState.quadras;
          if (quadras.isNotEmpty) {
            add(LoadQuadras(quadras.first.arenaId));
          }
        }
      },
    );
  }

  Future<void> _onToggleQuadraStatus(
    ToggleQuadraStatus event,
    Emitter<QuadraState> emit,
  ) async {
    final currentState = state;
    emit(QuadraLoading());
    final result = await toggleQuadraStatusUseCase(event.id, event.ativa);
    result.fold(
      (failure) => emit(QuadraError(failure.message)),
      (_) {
        emit(QuadraOperationSuccess(event.ativa ? 'Quadra ativada!' : 'Quadra desativada!'));
        if (currentState is QuadrasLoaded) {
          final quadras = currentState.quadras;
          if (quadras.isNotEmpty) {
            add(LoadQuadras(quadras.first.arenaId));
          }
        }
      },
    );
  }
}
