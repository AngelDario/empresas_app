import 'package:flutter/material.dart';
import 'package:empresas_cliente/screens/login.dart';
import 'package:empresas_cliente/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:empresas_cliente/services/auth_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: AuthService().handleAuthState(),
    );
  }
}

