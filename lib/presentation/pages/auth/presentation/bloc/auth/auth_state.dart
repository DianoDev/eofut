import 'package:equatable/equatable.dart';
import '../../../../../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Estado de carregamento
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Estado autenticado
class Authenticated extends AuthState {
  final User user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Estado não autenticado
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Estado de erro
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Estado de sucesso no registro (antes de autenticar)
class RegistrationSuccess extends AuthState {
  final String message;

  const RegistrationSuccess({
    this.message = 'Conta criada com sucesso! Faça login para continuar.',
  });

  @override
  List<Object?> get props => [message];
}
