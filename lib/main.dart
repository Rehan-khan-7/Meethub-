import 'package:flutter/material.dart';

import 'features/home/screens/home_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'models/user.dart';
void main() {
  runApp(const VowApp());
}

class VowApp extends StatelessWidget {
  const VowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        user: User(
          id: 'test-user',
          name: 'Test User',
          email: 'test@example.com',
          role: 'manager',
        ),
      ),
    );
  }
}
