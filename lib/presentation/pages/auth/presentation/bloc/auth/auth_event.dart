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

/// Evento para registrar JOGADOR
class RegisterJogadorEvent extends AuthEvent {
  final String nome;
  final String email;
  final String password;
  final String telefone;
  final String? cidade;
  final String? estado;
  final String? nivelJogo;

  const RegisterJogadorEvent({
    required this.nome,
    required this.email,
    required this.password,
    required this.telefone,
    this.cidade,
    this.estado,
    this.nivelJogo,
  });

  @override
  List<Object?> get props => [nome, email, password, telefone, cidade, estado, nivelJogo];
}

/// Evento para registrar ARENA
class RegisterArenaEvent extends AuthEvent {
  final String nomeEstabelecimento;
  final String email;
  final String password;
  final String telefone;
  final String cnpj;
  final String enderecoCompleto;
  final String cidade;
  final String estado;
  final Map<String, dynamic>? horarioFuncionamento;

  const RegisterArenaEvent({
    required this.nomeEstabelecimento,
    required this.email,
    required this.password,
    required this.telefone,
    required this.cnpj,
    required this.enderecoCompleto,
    required this.cidade,
    required this.estado,
    this.horarioFuncionamento,
  });

  @override
  List<Object?> get props => [
        nomeEstabelecimento,
        email,
        password,
        telefone,
        cnpj,
        enderecoCompleto,
        cidade,
        estado,
        horarioFuncionamento,
      ];
}

/// Evento para registrar PROFESSOR
class RegisterProfessorEvent extends AuthEvent {
  final String nome;
  final String email;
  final String password;
  final String telefone;
  final List<String>? certificacoes;
  final List<String>? especialidades;
  final double? valorHoraAula;
  final int? experienciaAnos;
  final String? cidade;
  final String? estado;

  const RegisterProfessorEvent({
    required this.nome,
    required this.email,
    required this.password,
    required this.telefone,
    this.certificacoes,
    this.especialidades,
    this.valorHoraAula,
    this.experienciaAnos,
    this.cidade,
    this.estado,
  });

  @override
  List<Object?> get props => [
        nome,
        email,
        password,
        telefone,
        certificacoes,
        especialidades,
        valorHoraAula,
        experienciaAnos,
        cidade,
        estado,
      ];
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
