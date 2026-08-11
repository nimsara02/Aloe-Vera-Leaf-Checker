import 'package:flutter/material.dart';
import 'system_controller.dart';
import 'login_screen.dart';

void main() async {
  // Ensure Flutter engine bindings are initialized before async tasks
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local notifications plugin (FR43)
  await SystemController.instance.initNotifications();

  runApp(const AloeCheckApp());
}

class AloeCheckApp extends StatelessWidget {
  const AloeCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AloeCheck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF2C7A59),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C7A59),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      // Starts on the Login Screen
      home: const LoginScreen(),
    );
  }
}