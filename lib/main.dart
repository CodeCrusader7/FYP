import 'package:flutter/material.dart';
import 'SignInPage.dart';
import 'homepage.dart';
import 'login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'signup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(VetConnectApp());
}

class VetConnectApp extends StatelessWidget {
  const VetConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'VetConnect',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignInPage(),
          '/signin': (context) => HomePage(),
          '/home': (context) => HomePage(),
        });
  }
}