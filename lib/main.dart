import 'package:app_flutter/services/agenda_service.dart';
import 'package:app_flutter/services/escala_service.dart';
import 'package:app_flutter/services/firebase_messaging_service.dart';
import 'package:app_flutter/services/notification_service.dart';
import 'package:app_flutter/services/projetos_service.dart';
import 'package:app_flutter/services/user_service.dart';
import 'package:app_flutter/theme/app_theme.dart';
import 'package:app_flutter/widgets/auth_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting().then((_) {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => UserService()),
      ChangeNotifierProvider(create: (context) => ProjetoService()),
      ChangeNotifierProvider(create: (context) => AgendaService()),
      ChangeNotifierProvider(create: (context) => EscalaService()),
      ChangeNotifierProvider(create: (context) => NotificationService()),
      ChangeNotifierProvider(
          create: (context) =>
              FirebaseMessagingService(context.read<NotificationService>())),
    ], child: const MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'C.E.EFRAIM',
      theme: AppTheme(context).defaultTheme(),
      home: const AuthCheck(),
    );
  }
}
