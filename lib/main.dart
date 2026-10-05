import 'package:flutter/material.dart';

import 'features/home/screens/home_screen.dart';
import 'models/user.dart';

final RouteObserver<ModalRoute<dynamic>> routeObserver =
    RouteObserver<ModalRoute<dynamic>>();
void main() {
  runApp(const VowApp());
}

class VowApp extends StatelessWidget {
  const VowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
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