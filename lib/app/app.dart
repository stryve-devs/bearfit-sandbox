import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Frontend',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/auth/login',
      routes: {
        '/': (c) => const HomeScreen(),
        '/auth/login': (c) => const LoginScreen(),
        '/auth/register': (c) => const RegisterScreen(),
      },
    );
  }
}
