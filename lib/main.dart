import 'package:app_flutter/pages/usuario/cadastro_user.dart';
import 'package:app_flutter/services/user_service.dart';
import 'package:app_flutter/theme/app-theme.dart';
import 'package:app_flutter/widgets/auth_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserService())],
      child: const MyApp()));
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
