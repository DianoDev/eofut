import 'package:eofut/domain/entities/user.dart';

class UserModel {
  final String id;
  final String firebaseUid;
  final String nome;
  final String email;
  final String tipoUsuario;

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

  UserModel({
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

  /// Converter de JSON do Supabase para Model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      firebaseUid: json['firebase_uid'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      tipoUsuario: json['tipo_usuario'] as String? ?? 'jogador',
      telefone: json['telefone'] as String?,
      fotoUrl: json['foto_url'] as String?,
      cidade: json['cidade'] as String?,
      estado: json['estado'] as String?,
      dataNascimento: json['data_nascimento'] != null ? DateTime.parse(json['data_nascimento'] as String) : null,
      genero: json['genero'] as String?,
      bio: json['bio'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalAvaliacoes: json['total_avaliacoes'] as int? ?? 0,
      nivelJogo: json['nivel_jogo'] as String?,
      posicaoPreferida: json['posicao_preferida'] as String?,
      cnpj: json['cnpj'] as String?,
      nomeEstabelecimento: json['nome_estabelecimento'] as String?,
      enderecoCompleto: json['endereco_completo'] as String?,
      horarioFuncionamento: json['horario_funcionamento'] as Map<String, dynamic>?,
      certificacoes: json['certificacoes'] != null ? List<String>.from(json['certificacoes'] as List) : null,
      especialidades: json['especialidades'] != null ? List<String>.from(json['especialidades'] as List) : null,
      valorHoraAula: (json['valor_hora_aula'] as num?)?.toDouble(),
      experienciaAnos: json['experiencia_anos'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converter Model para JSON do Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebase_uid': firebaseUid,
      'nome': nome,
      'email': email,
      'tipo_usuario': tipoUsuario,
      'telefone': telefone,
      'foto_url': fotoUrl,
      'cidade': cidade,
      'estado': estado,
      'data_nascimento': dataNascimento?.toIso8601String(),
      'genero': genero,
      'bio': bio,
      'rating': rating,
      'total_avaliacoes': totalAvaliacoes,
      'nivel_jogo': nivelJogo,
      'posicao_preferida': posicaoPreferida,
      'cnpj': cnpj,
      'nome_estabelecimento': nomeEstabelecimento,
      'endereco_completo': enderecoCompleto,
      'horario_funcionamento': horarioFuncionamento,
      'certificacoes': certificacoes,
      'especialidades': especialidades,
      'valor_hora_aula': valorHoraAula,
      'experiencia_anos': experienciaAnos,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Converter Model para Entity
  User toEntity() {
    return User(
      id: id,
      firebaseUid: firebaseUid,
      nome: nome,
      email: email,
      tipoUsuario: _stringToTipoUsuario(tipoUsuario),
      telefone: telefone,
      fotoUrl: fotoUrl,
      cidade: cidade,
      estado: estado,
      dataNascimento: dataNascimento,
      genero: genero,
      bio: bio,
      rating: rating,
      totalAvaliacoes: totalAvaliacoes,
      nivelJogo: nivelJogo,
      posicaoPreferida: posicaoPreferida,
      cnpj: cnpj,
      nomeEstabelecimento: nomeEstabelecimento,
      enderecoCompleto: enderecoCompleto,
      horarioFuncionamento: horarioFuncionamento,
      certificacoes: certificacoes,
      especialidades: especialidades,
      valorHoraAula: valorHoraAula,
      experienciaAnos: experienciaAnos,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Converter string para enum TipoUsuario
  static TipoUsuario _stringToTipoUsuario(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'arena':
        return TipoUsuario.arena;
      case 'professor':
        return TipoUsuario.professor;
      case 'jogador':
      default:
        return TipoUsuario.jogador;
    }
  }

  /// Converter enum TipoUsuario para string
  static String tipoUsuarioToString(TipoUsuario tipo) {
    switch (tipo) {
      case TipoUsuario.arena:
        return 'arena';
      case TipoUsuario.professor:
        return 'professor';
      case TipoUsuario.jogador:
        return 'jogador';
    }
  }
}
