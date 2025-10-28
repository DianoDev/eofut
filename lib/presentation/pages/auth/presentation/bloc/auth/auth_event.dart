import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para fazer login
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Evento para fazer registro
class RegisterEvent extends AuthEvent {
  final String nome;
  final String email;
  final String password;
  final String telefone;

  const RegisterEvent({
    required this.nome,
    required this.email,
    required this.password,
    required this.telefone,
  });

  @override
  List<Object?> get props => [nome, email, password, telefone];
}

/// Evento para fazer logout
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

/// Evento para verificar status de autenticação
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

/// Evento para limpar mensagens de erro
class ClearAuthErrorEvent extends AuthEvent {
  const ClearAuthErrorEvent();
}
