class AppConstants {
  // App Info
  static const String appName = 'FutApp';
  static const String appVersion = '1.0.0';
  
  // Preferências
  static const String prefKeyThemeMode = 'theme_mode';
  static const String prefKeyOnboardingCompleted = 'onboarding_completed';
  static const String prefKeyUserLocation = 'user_location';
  
  // Níveis de Jogo
  static const List<String> niveisJogo = [
    'Iniciante',
    'Intermediário',
    'Avançado',
  ];
  
  // Posições
  static const List<String> posicoes = [
    'Frente',
    'Fundo',
    'Ambos',
  ];
  
  // Validações
  static const int minIdadeJogador = 12;
  static const int maxCaracteresNome = 100;
  static const int maxCaracteresBio = 500;
  
  // Filtros e Limites
  static const double maxRadiusBuscaKm = 50.0;
  static const double defaultRadiusBuscaKm = 10.0;
  static const int maxResultadosBusca = 50;
  
  // Rating
  static const double minRating = 0.0;
  static const double maxRating = 5.0;
}
