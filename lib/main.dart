// main.dart
import 'package:flutter/material.dart';
// import 'screens/crop_price_screen.dart';
// import 'package:agri_app/videos_page.dart';
import 'package:agri_app/login_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}