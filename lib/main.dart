import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/network/supabase_config.dart';
import 'package:eofut/presentation/pages/auth/injection_container.dart' as auth_di;
import 'package:eofut/presentation/pages/arenas/injection_container.dart' as arena_di;
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar orientação
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inicializar Supabase
  await SupabaseConfig.initialize();

  // Inicializar Dependency Injection
  await auth_di.init();
  await arena_di.init();
  runApp(const MyApp());
}
