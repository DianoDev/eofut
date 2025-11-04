import 'package:equatable/equatable.dart';
import 'package:eofut/domain/entities/quadra.dart';

abstract class QuadraState extends Equatable {
  const QuadraState();

  @override
  List<Object?> get props => [];
}

class QuadraInitial extends QuadraState {}

class QuadraLoading extends QuadraState {}

class QuadrasLoaded extends QuadraState {
  final List<Quadra> quadras;

  const QuadrasLoaded(this.quadras);

  @override
  List<Object?> get props => [quadras];
}

class QuadraOperationSuccess extends QuadraState {
  final String message;

  const QuadraOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class QuadraError extends QuadraState {
  final String message;

  const QuadraError(this.message);

  @override
  List<Object?> get props => [message];
}
