import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_campeonato_usecase.dart';
import '../../domain/usecases/delete_campeonato_usecase.dart';
import '../../domain/usecases/get_campeonato_by_id_usecase.dart';
import '../../domain/usecases/get_campeonatos_usecase.dart';
import '../../domain/usecases/get_meus_campeonatos_usecase.dart';
import '../../domain/usecases/update_campeonato_usecase.dart';
import 'campeonato_event.dart';
import 'campeonato_state.dart';

class CampeonatoBloc extends Bloc<CampeonatoEvent, CampeonatoState> {
  final GetCampeonatosUseCase getCampeonatosUseCase;
  final GetCampeonatoByIdUseCase getCampeonatoByIdUseCase;
  final GetMeusCampeonatosUseCase getMeusCampeonatosUseCase;
  final CreateCampeonatoUseCase createCampeonatoUseCase;
  final UpdateCampeonatoUseCase updateCampeonatoUseCase;
  final DeleteCampeonatoUseCase deleteCampeonatoUseCase;

  CampeonatoBloc({
    required this.getCampeonatosUseCase,
    required this.getCampeonatoByIdUseCase,
    required this.getMeusCampeonatosUseCase,
    required this.createCampeonatoUseCase,
    required this.updateCampeonatoUseCase,
    required this.deleteCampeonatoUseCase,
  }) : super(const CampeonatoInitial()) {
    on<LoadCampeonatosEvent>(_onLoadCampeonatos);
    on<LoadMeusCampeonatosEvent>(_onLoadMeusCampeonatos);
    on<LoadCampeonatoByIdEvent>(_onLoadCampeonatoById);
    on<SearchCampeonatosEvent>(_onSearchCampeonatos);
    on<CreateCampeonatoEvent>(_onCreateCampeonato);
    on<UpdateCampeonatoEvent>(_onUpdateCampeonato);
    on<DeleteCampeonatoEvent>(_onDeleteCampeonato);
  }

  Future<void> _onLoadCampeonatos(
    LoadCampeonatosEvent event,
    Emitter<CampeonatoState> emit,
  ) async {
    emit(const CampeonatoLoading());

    final result = await getCampeonatosUseCase();

    result.fold(
      (failure) => emit(CampeonatoError(message: failure.message)),
      (campeonatos) {
        if (campeonatos.isEmpty) {
          emit(const CampeonatoEmpty());
        } else {
          emit(CampeonatosLoaded(campeonatos: campeonatos));
        }
      },
    );
  }

  Future<void> _onLoadMeusCampeonatos(
    LoadMeusCampeonatosEvent event,
    Emitter<CampeonatoState> emit,
  ) async {
    emit(const CampeonatoLoading());

    final result = await getMeusCampeonatosUseCase(event.organizadorId);

    result.fold(
      (failure) => emit(CampeonatoError(message: failure.message)),
      (campeonatos) {
        if (campeonatos.isEmpty) {
          emit(const CampeonatoEmpty(
            message: 'Você ainda não criou nenhum campeonato',
          ));
        } else {
          emit(CampeonatosLoaded(campeonatos: campeonatos));
        }
      },
    );
  }

  Future<void> _onLoadCampeonatoById(
    LoadCampeonatoByIdEvent event,
    Emitter<CampeonatoState> emit,
  ) async {
    emit(const CampeonatoLoading());

    final result = await getCampeonatoByIdUseCase(event.id);

    result.fold(
      (failure) => emit(CampeonatoError(message: failure.message)),
      (campeonato) => emit(CampeonatoDetailLoaded(campeonato: campeonato)),
    );
  }

  Future<void> _onSearchCampeonatos(
    SearchCampeonatosEvent event,
    Emitter<CampeonatoState> emit,
  ) async {
    emit(const CampeonatoLoading());

    final result = await getCampeonatosUseCase(
      cidade: event.cidade,
      estado: event.estado,
      status: event.status,
    );

    result.fold(
      (failure) => emit(CampeonatoError(message: failure.message)),
      (campeonatos) {
        if (campeonatos.isEmpty) {
          emit(const CampeonatoEmpty(
            message: 'Nenhum campeonato encontrado com os filtros aplicados',
          ));
        } else {
          emit(CampeonatosLoaded(
            campeonatos: campeonatos,
            cidade: event.cidade,
            estado: event.estado,
            status: event.status,
          ));
        }
      },
    );
  }

  Future<void> _onCreateCampeonato(
    CreateCampeonatoEvent event,
    Emitter<CampeonatoState> emit,
  ) async {
    emit(const CampeonatoLoading());

    final result = await createCampeonatoUseCase(
      nome: event.nome,
      descricao: event.descricao,
      dataInicio: event.dataInicio,
      dataFim: event.dataFim,
      localArenaId: event.localArenaId,
      organizadorId: event.organizadorId,
      cidade: event.cidade,
      estado: event.estado,
      categorias: event.categorias,
      nivelMinimo: event.nivelMinimo,
      vagas: event.vagas,
      valorInscricao: event.valorInscricao,
      premiacao: event.premiacao,
      regras: event.regras,
      fotos: event.fotos,
    );

    result.fold(
      (failure) => emit(CampeonatoError(message: failure.message)),
      (campeonato) => emit(CampeonatoCreated(campeonato: campeonato)),
    );
  }

  Future<void> _onUpdateCampeonato(
    UpdateCampeonatoEvent event,
    Emitter<CampeonatoState> emit,
  ) async {
    emit(const CampeonatoLoading());

    final result = await updateCampeonatoUseCase(
      id: event.id,
      nome: event.nome,
      descricao: event.descricao,
      dataInicio: event.dataInicio,
      dataFim: event.dataFim,
      localArenaId: event.localArenaId,
      cidade: event.cidade,
      estado: event.estado,
      categorias: event.categorias,
      nivelMinimo: event.nivelMinimo,
      vagas: event.vagas,
      valorInscricao: event.valorInscricao,
      status: event.status,
      premiacao: event.premiacao,
      regras: event.regras,
      fotos: event.fotos,
    );

    result.fold(
      (failure) => emit(CampeonatoError(message: failure.message)),
      (campeonato) => emit(CampeonatoUpdated(campeonato: campeonato)),
    );
  }

  Future<void> _onDeleteCampeonato(
    DeleteCampeonatoEvent event,
    Emitter<CampeonatoState> emit,
  ) async {
    emit(const CampeonatoLoading());

    final result = await deleteCampeonatoUseCase(event.id);

    result.fold(
      (failure) => emit(CampeonatoError(message: failure.message)),
      (_) => emit(const CampeonatoDeleted()),
    );
  }
}
