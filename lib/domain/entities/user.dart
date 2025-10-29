import 'package:equatable/equatable.dart';

enum TipoUsuario { jogador, arena, professor }

class User extends Equatable {
  final String id;
  final String firebaseUid;
  final String nome;
  final String email;
  final TipoUsuario tipoUsuario;

  // Campos comuns
  final String? telefone;
  final String? fotoUrl;
  final String? cidade;
  final String? estado;
  final DateTime? dataNascimento;
  final String? genero;
  final String? bio;
  final double rating;
  final int totalAvaliacoes;

  // Campos específicos de Jogador
  final String? nivelJogo;
  final String? posicaoPreferida;

  // Campos específicos de Arena
  final String? cnpj;
  final String? nomeEstabelecimento;
  final String? enderecoCompleto;
  final Map<String, dynamic>? horarioFuncionamento;

  // Campos específicos de Professor
  final List<String>? certificacoes;
  final List<String>? especialidades;
  final double? valorHoraAula;
  final int? experienciaAnos;

  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.firebaseUid,
    required this.nome,
    required this.email,
    required this.tipoUsuario,
    this.telefone,
    this.fotoUrl,
    this.cidade,
    this.estado,
    this.dataNascimento,
    this.genero,
    this.bio,
    this.rating = 0.0,
    this.totalAvaliacoes = 0,
    this.nivelJogo,
    this.posicaoPreferida,
    this.cnpj,
    this.nomeEstabelecimento,
    this.enderecoCompleto,
    this.horarioFuncionamento,
    this.certificacoes,
    this.especialidades,
    this.valorHoraAula,
    this.experienciaAnos,
    required this.createdAt,
    required this.updatedAt,
  });

  // Helpers para verificar tipo de usuário
  bool get isJogador => tipoUsuario == TipoUsuario.jogador;
  bool get isArena => tipoUsuario == TipoUsuario.arena;
  bool get isProfessor => tipoUsuario == TipoUsuario.professor;

  // Verificar se pode criar eventos (Arena ou Professor)
  bool get podeCriarEventos => isArena || isProfessor;

  // Verificar se pode fazer rachas (Jogador ou Professor)
  bool get podeFazerRachas => isJogador || isProfessor;

  // Verificar se pode alugar quadras (Jogador ou Professor)
  bool get podeAlugarQuadras => isJogador || isProfessor;

  @override
  List<Object?> get props => [
        id,
        firebaseUid,
        nome,
        email,
        tipoUsuario,
        telefone,
        fotoUrl,
        cidade,
        estado,
        dataNascimento,
        genero,
        bio,
        rating,
        totalAvaliacoes,
        nivelJogo,
        posicaoPreferida,
        cnpj,
        nomeEstabelecimento,
        enderecoCompleto,
        horarioFuncionamento,
        certificacoes,
        especialidades,
        valorHoraAula,
        experienciaAnos,
        createdAt,
        updatedAt,
      ];

  User copyWith({
    String? id,
    String? firebaseUid,
    String? nome,
    String? email,
    TipoUsuario? tipoUsuario,
    String? telefone,
    String? fotoUrl,
    String? cidade,
    String? estado,
    DateTime? dataNascimento,
    String? genero,
    String? bio,
    double? rating,
    int? totalAvaliacoes,
    String? nivelJogo,
    String? posicaoPreferida,
    String? cnpj,
    String? nomeEstabelecimento,
    String? enderecoCompleto,
    Map<String, dynamic>? horarioFuncionamento,
    List<String>? certificacoes,
    List<String>? especialidades,
    double? valorHoraAula,
    int? experienciaAnos,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      tipoUsuario: tipoUsuario ?? this.tipoUsuario,
      telefone: telefone ?? this.telefone,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      genero: genero ?? this.genero,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      totalAvaliacoes: totalAvaliacoes ?? this.totalAvaliacoes,
      nivelJogo: nivelJogo ?? this.nivelJogo,
      posicaoPreferida: posicaoPreferida ?? this.posicaoPreferida,
      cnpj: cnpj ?? this.cnpj,
      nomeEstabelecimento: nomeEstabelecimento ?? this.nomeEstabelecimento,
      enderecoCompleto: enderecoCompleto ?? this.enderecoCompleto,
      horarioFuncionamento: horarioFuncionamento ?? this.horarioFuncionamento,
      certificacoes: certificacoes ?? this.certificacoes,
      especialidades: especialidades ?? this.especialidades,
      valorHoraAula: valorHoraAula ?? this.valorHoraAula,
      experienciaAnos: experienciaAnos ?? this.experienciaAnos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
