class ApiConstants {
  // TODO: Substituir com suas credenciais do Supabase
  static const String supabaseUrl = 'https://xugmoorfznosftaoitps.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh1Z21vb3Jmem5vc2Z0YW9pdHBzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1NzkzODksImV4cCI6MjA3NzE1NTM4OX0.DUsfapiMeF7vKWnQzPJmvqvwZJSz9jerXU4SY0SpPuk';

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
