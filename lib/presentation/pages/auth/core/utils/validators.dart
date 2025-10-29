/// Classe utilitária para validações de formulários
class Validators {
  /// Valida email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }

    // Regex para validação de email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }

    return null;
  }

  /// Valida senha
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }

    return null;
  }

  /// Valida nome
  static String? validateNome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }

    if (value.trim().length < 3) {
      return 'Nome deve ter no mínimo 3 caracteres';
    }

    // Verifica se contém apenas letras e espaços
    final nomeRegex = RegExp(r'^[a-zA-ZÀ-ÿ\s]+$');
    if (!nomeRegex.hasMatch(value)) {
      return 'Nome deve conter apenas letras';
    }

    return null;
  }

  /// Valida telefone
  static String? validateTelefone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }

    // Remove caracteres especiais para validação
    final numbersOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbersOnly.length < 10 || numbersOnly.length > 11) {
      return 'Telefone inválido';
    }

    return null;
  }

  /// Valida CNPJ
  static String? validateCNPJ(String? value) {
    if (value == null || value.isEmpty) {
      return 'CNPJ é obrigatório';
    }

    // Remove caracteres especiais
    final cnpj = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cnpj.length != 14) {
      return 'CNPJ deve ter 14 dígitos';
    }

    // Validação básica - verifica se não são todos iguais
    if (RegExp(r'^(\d)\1{13}$').hasMatch(cnpj)) {
      return 'CNPJ inválido';
    }

    // Validação completa dos dígitos verificadores
    if (!_validarDigitosCNPJ(cnpj)) {
      return 'CNPJ inválido';
    }

    return null;
  }

  /// Valida CPF
  static String? validateCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }

    // Remove caracteres especiais
    final cpf = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cpf.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }

    // Validação básica - verifica se não são todos iguais
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) {
      return 'CPF inválido';
    }

    // Validação completa dos dígitos verificadores
    if (!_validarDigitosCPF(cpf)) {
      return 'CPF inválido';
    }

    return null;
  }

  /// Valida CEP
  static String? validateCEP(String? value) {
    if (value == null || value.isEmpty) {
      return null; // CEP é opcional
    }

    // Remove caracteres especiais
    final cep = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cep.length != 8) {
      return 'CEP inválido';
    }

    return null;
  }

  /// Valida campo obrigatório genérico
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  /// Valida campo numérico
  static String? validateNumber(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // Opcional por padrão
    }

    if (double.tryParse(value) == null) {
      return fieldName != null 
          ? '$fieldName deve ser um número válido'
          : 'Valor inválido';
    }

    return null;
  }

  /// Valida valor mínimo
  static String? validateMinValue(String? value, double min, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Valor inválido';
    }

    if (number < min) {
      return fieldName != null
          ? '$fieldName deve ser no mínimo $min'
          : 'Valor mínimo: $min';
    }

    return null;
  }

  /// Valida valor máximo
  static String? validateMaxValue(String? value, double max, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Valor inválido';
    }

    if (number > max) {
      return fieldName != null
          ? '$fieldName deve ser no máximo $max'
          : 'Valor máximo: $max';
    }

    return null;
  }

  /// Valida URL
  static String? validateURL(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL é opcional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'URL inválida';
    }

    return null;
  }

  /// Valida comprimento mínimo
  static String? validateMinLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length < minLength) {
      return fieldName != null
          ? '$fieldName deve ter no mínimo $minLength caracteres'
          : 'Mínimo de $minLength caracteres';
    }

    return null;
  }

  /// Valida comprimento máximo
  static String? validateMaxLength(String? value, int maxLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > maxLength) {
      return fieldName != null
          ? '$fieldName deve ter no máximo $maxLength caracteres'
          : 'Máximo de $maxLength caracteres';
    }

    return null;
  }

  // ==========================================
  // MÉTODOS PRIVADOS DE VALIDAÇÃO
  // ==========================================

  /// Valida dígitos verificadores do CNPJ
  static bool _validarDigitosCNPJ(String cnpj) {
    // Cálculo do primeiro dígito verificador
    int soma = 0;
    int peso = 5;

    for (int i = 0; i < 12; i++) {
      soma += int.parse(cnpj[i]) * peso;
      peso = peso == 2 ? 9 : peso - 1;
    }

    int digito1 = soma % 11 < 2 ? 0 : 11 - (soma % 11);

    if (digito1 != int.parse(cnpj[12])) {
      return false;
    }

    // Cálculo do segundo dígito verificador
    soma = 0;
    peso = 6;

    for (int i = 0; i < 13; i++) {
      soma += int.parse(cnpj[i]) * peso;
      peso = peso == 2 ? 9 : peso - 1;
    }

    int digito2 = soma % 11 < 2 ? 0 : 11 - (soma % 11);

    return digito2 == int.parse(cnpj[13]);
  }

  /// Valida dígitos verificadores do CPF
  static bool _validarDigitosCPF(String cpf) {
    // Cálculo do primeiro dígito verificador
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }

    int digito1 = 11 - (soma % 11);
    if (digito1 >= 10) digito1 = 0;

    if (digito1 != int.parse(cpf[9])) {
      return false;
    }

    // Cálculo do segundo dígito verificador
    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }

    int digito2 = 11 - (soma % 11);
    if (digito2 >= 10) digito2 = 0;

    return digito2 == int.parse(cpf[10]);
  }
}
