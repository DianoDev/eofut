import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/network/supabase_config.dart';
import 'injection_container.dart' as di;
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
  await di.init();

  runApp(const MyApp());
}
