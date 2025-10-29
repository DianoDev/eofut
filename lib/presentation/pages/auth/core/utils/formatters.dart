import 'package:intl/intl.dart';

/// Classe utilitária para formatação de dados
class Formatters {
  // ==========================================
  // FORMATADORES DE TEXTO
  // ==========================================

  /// Formata telefone: (99) 99999-9999
  static String formatTelefone(String? telefone) {
    if (telefone == null || telefone.isEmpty) {
      return '';
    }

    // Remove tudo que não é número
    final numbers = telefone.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers.length == 11) {
      // Celular: (99) 99999-9999
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7)}';
    } else if (numbers.length == 10) {
      // Fixo: (99) 9999-9999
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 6)}-${numbers.substring(6)}';
    }

    return telefone;
  }

  /// Formata CPF: 999.999.999-99
  static String formatCPF(String? cpf) {
    if (cpf == null || cpf.isEmpty) {
      return '';
    }

    // Remove tudo que não é número
    final numbers = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers.length == 11) {
      return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9)}';
    }

    return cpf;
  }

  /// Formata CNPJ: 99.999.999/9999-99
  static String formatCNPJ(String? cnpj) {
    if (cnpj == null || cnpj.isEmpty) {
      return '';
    }

    // Remove tudo que não é número
    final numbers = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers.length == 14) {
      return '${numbers.substring(0, 2)}.${numbers.substring(2, 5)}.${numbers.substring(5, 8)}/${numbers.substring(8, 12)}-${numbers.substring(12)}';
    }

    return cnpj;
  }

  /// Formata CEP: 99999-999
  static String formatCEP(String? cep) {
    if (cep == null || cep.isEmpty) {
      return '';
    }

    // Remove tudo que não é número
    final numbers = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers.length == 8) {
      return '${numbers.substring(0, 5)}-${numbers.substring(5)}';
    }

    return cep;
  }

  // ==========================================
  // FORMATADORES DE NÚMERO/MOEDA
  // ==========================================

  /// Formata valor monetário: R$ 1.234,56
  static String formatCurrency(double? value, {String? symbol = 'R\$'}) {
    if (value == null) {
      return symbol != null ? '$symbol 0,00' : '0,00';
    }

    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: symbol ?? '',
      decimalDigits: 2,
    );

    return formatter.format(value);
  }

  /// Formata valor monetário compacto: R$ 1,2k ou R$ 1,2M
  static String formatCurrencyCompact(double? value, {String? symbol = 'R\$'}) {
    if (value == null) {
      return symbol != null ? '$symbol 0' : '0';
    }

    final formatter = NumberFormat.compact(locale: 'pt_BR');
    final formatted = formatter.format(value);
    
    return symbol != null ? '$symbol $formatted' : formatted;
  }

  /// Formata número com separador de milhares: 1.234.567
  static String formatNumber(num? value) {
    if (value == null) {
      return '0';
    }

    final formatter = NumberFormat.decimalPattern('pt_BR');
    return formatter.format(value);
  }

  /// Formata percentual: 45,67%
  static String formatPercentage(double? value, {int decimals = 2}) {
    if (value == null) {
      return '0%';
    }

    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Formata rating: 4.5
  static String formatRating(double? value) {
    if (value == null) {
      return '0.0';
    }

    return value.toStringAsFixed(1);
  }

  // ==========================================
  // FORMATADORES DE DATA/HORA
  // ==========================================

  /// Formata data: 29/10/2024
  static String formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    final formatter = DateFormat('dd/MM/yyyy', 'pt_BR');
    return formatter.format(date);
  }

  /// Formata data completa: 29 de outubro de 2024
  static String formatDateFull(DateTime? date) {
    if (date == null) {
      return '';
    }

    final formatter = DateFormat('dd \'de\' MMMM \'de\' yyyy', 'pt_BR');
    return formatter.format(date);
  }

  /// Formata data abreviada: 29/out/24
  static String formatDateShort(DateTime? date) {
    if (date == null) {
      return '';
    }

    final formatter = DateFormat('dd/MMM/yy', 'pt_BR');
    return formatter.format(date);
  }

  /// Formata hora: 14:30
  static String formatTime(DateTime? time) {
    if (time == null) {
      return '';
    }

    final formatter = DateFormat('HH:mm', 'pt_BR');
    return formatter.format(time);
  }

  /// Formata data e hora: 29/10/2024 14:30
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }

    final formatter = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');
    return formatter.format(dateTime);
  }

  /// Formata data relativa: "há 2 dias", "há 3 horas"
  static String formatRelativeDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'há ${years} ${years == 1 ? 'ano' : 'anos'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'há ${months} ${months == 1 ? 'mês' : 'meses'}';
    } else if (difference.inDays > 0) {
      return 'há ${difference.inDays} ${difference.inDays == 1 ? 'dia' : 'dias'}';
    } else if (difference.inHours > 0) {
      return 'há ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inMinutes > 0) {
      return 'há ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'agora';
    }
  }

  /// Formata duração: "2h 30min"
  static String formatDuration(Duration? duration) {
    if (duration == null) {
      return '0min';
    }

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}min';
    } else {
      return '${minutes}min';
    }
  }

  // ==========================================
  // FORMATADORES DE TEXTO
  // ==========================================

  /// Formata nome (primeira letra de cada palavra maiúscula)
  static String formatName(String? name) {
    if (name == null || name.isEmpty) {
      return '';
    }

    return name
        .toLowerCase()
        .split(' ')
        .map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  /// Trunca texto com reticências
  static String truncate(String? text, int maxLength) {
    if (text == null || text.isEmpty) {
      return '';
    }

    if (text.length <= maxLength) {
      return text;
    }

    return '${text.substring(0, maxLength)}...';
  }

  /// Remove acentos de texto
  static String removeAccents(String text) {
    const withAccents = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const withoutAccents = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    var result = text;
    for (int i = 0; i < withAccents.length; i++) {
      result = result.replaceAll(withAccents[i], withoutAccents[i]);
    }

    return result;
  }

  /// Capitaliza primeira letra
  static String capitalize(String? text) {
    if (text == null || text.isEmpty) {
      return '';
    }

    return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
  }

  // ==========================================
  // FORMATADORES ESPECÍFICOS
  // ==========================================

  /// Formata nível de jogo
  static String formatNivelJogo(String? nivel) {
    if (nivel == null || nivel.isEmpty) {
      return 'Não informado';
    }

    switch (nivel.toLowerCase()) {
      case 'iniciante':
        return 'Iniciante';
      case 'intermediario':
      case 'intermediário':
        return 'Intermediário';
      case 'avancado':
      case 'avançado':
        return 'Avançado';
      case 'profissional':
        return 'Profissional';
      default:
        return capitalize(nivel);
    }
  }

  /// Formata tipo de usuário
  static String formatTipoUsuario(String? tipo) {
    if (tipo == null || tipo.isEmpty) {
      return 'Usuário';
    }

    switch (tipo.toLowerCase()) {
      case 'jogador':
        return 'Jogador';
      case 'arena':
        return 'Arena';
      case 'professor':
        return 'Professor';
      default:
        return capitalize(tipo);
    }
  }

  /// Formata status
  static String formatStatus(String? status) {
    if (status == null || status.isEmpty) {
      return 'Indefinido';
    }

    switch (status.toLowerCase()) {
      case 'ativo':
        return 'Ativo';
      case 'inativo':
        return 'Inativo';
      case 'pendente':
        return 'Pendente';
      case 'confirmado':
      case 'confirmada':
        return 'Confirmado';
      case 'cancelado':
      case 'cancelada':
        return 'Cancelado';
      case 'concluido':
      case 'concluida':
      case 'concluído':
      case 'concluída':
        return 'Concluído';
      default:
        return capitalize(status);
    }
  }

  /// Formata lista de strings em texto: "item1, item2 e item3"
  static String formatList(List<String>? items) {
    if (items == null || items.isEmpty) {
      return '';
    }

    if (items.length == 1) {
      return items[0];
    }

    if (items.length == 2) {
      return '${items[0]} e ${items[1]}';
    }

    final allButLast = items.sublist(0, items.length - 1).join(', ');
    return '$allButLast e ${items.last}';
  }

  // ==========================================
  // MÁSCARAS DE INPUT (para TextFormField)
  // ==========================================

  /// Aplica máscara de telefone em tempo real
  static String applyTelefoneMask(String text) {
    final numbers = text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numbers.length <= 2) {
      return numbers;
    } else if (numbers.length <= 7) {
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2)}';
    } else if (numbers.length <= 11) {
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, numbers.length > 6 ? 7 : 6)}-${numbers.substring(numbers.length > 6 ? 7 : 6)}';
    }
    
    return formatTelefone(numbers);
  }

  /// Aplica máscara de CPF em tempo real
  static String applyCPFMask(String text) {
    final numbers = text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numbers.length <= 3) {
      return numbers;
    } else if (numbers.length <= 6) {
      return '${numbers.substring(0, 3)}.${numbers.substring(3)}';
    } else if (numbers.length <= 9) {
      return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6)}';
    } else if (numbers.length <= 11) {
      return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9)}';
    }
    
    return formatCPF(numbers);
  }

  /// Aplica máscara de CNPJ em tempo real
  static String applyCNPJMask(String text) {
    final numbers = text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numbers.length <= 2) {
      return numbers;
    } else if (numbers.length <= 5) {
      return '${numbers.substring(0, 2)}.${numbers.substring(2)}';
    } else if (numbers.length <= 8) {
      return '${numbers.substring(0, 2)}.${numbers.substring(2, 5)}.${numbers.substring(5)}';
    } else if (numbers.length <= 12) {
      return '${numbers.substring(0, 2)}.${numbers.substring(2, 5)}.${numbers.substring(5, 8)}/${numbers.substring(8)}';
    } else if (numbers.length <= 14) {
      return '${numbers.substring(0, 2)}.${numbers.substring(2, 5)}.${numbers.substring(5, 8)}/${numbers.substring(8, 12)}-${numbers.substring(12)}';
    }
    
    return formatCNPJ(numbers);
  }

  /// Aplica máscara de CEP em tempo real
  static String applyCEPMask(String text) {
    final numbers = text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numbers.length <= 5) {
      return numbers;
    } else if (numbers.length <= 8) {
      return '${numbers.substring(0, 5)}-${numbers.substring(5)}';
    }
    
    return formatCEP(numbers);
  }
}
