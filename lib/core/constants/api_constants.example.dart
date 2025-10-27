// INSTRUÇÕES:
// 1. Copie este arquivo e renomeie para api_constants.dart
// 2. Preencha com suas credenciais do Supabase
// 3. NUNCA commit o arquivo api_constants.dart

class ApiConstants {
  // Supabase Credentials
  // Obtenha em: https://app.supabase.com/project/_/settings/api
  static const String supabaseUrl = 'https://SEU-PROJETO.supabase.co';
  static const String supabaseAnonKey = 'SUA-ANON-KEY-AQUI';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Tabelas Supabase
  static const String tableUsers = 'users';
  static const String tableArenas = 'arenas';
  static const String tableReservas = 'reservas';
  static const String tableProfessores = 'professores';
  static const String tableCampeonatos = 'campeonatos';
  static const String tablePosts = 'posts';
  static const String tableProcuraParceiros = 'procura_parceiros';
  static const String tableAvaliacoes = 'avaliacoes';
  
  // Storage Buckets
  static const String bucketAvatars = 'avatars';
  static const String bucketArenaPhotos = 'arena-photos';
  static const String bucketPostMedia = 'post-media';
}
