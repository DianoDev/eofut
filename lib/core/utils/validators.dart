class Validators {
  // Email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    
    return null;
  }
  
  // Senha
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    
    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    
    return null;
  }
  
  // Nome
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    
    if (value.length < 3) {
      return 'Nome deve ter pelo menos 3 caracteres';
    }
    
    if (value.length > 100) {
      return 'Nome muito longo';
    }
    
    return null;
  }
  
  // Telefone
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }
    
    // Remove caracteres não numéricos
    final numbersOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numbersOnly.length < 10 || numbersOnly.length > 11) {
      return 'Telefone inválido';
    }
    
    return null;
  }
  
  // Genérico - campo obrigatório
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }
  
  // Valor monetário
  static String? validateMoneyValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Valor é obrigatório';
    }
    
    final numericValue = double.tryParse(
      value.replaceAll(RegExp(r'[^\d,.]'), '').replaceAll(',', '.'),
    );
    
    if (numericValue == null || numericValue <= 0) {
      return 'Valor inválido';
    }
    
    return null;
  }
  
  // CEP
  static String? validateCEP(String? value) {
    if (value == null || value.isEmpty) {
      return 'CEP é obrigatório';
    }
    
    final numbersOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numbersOnly.length != 8) {
      return 'CEP inválido';
    }
    
    return null;
  }
}
