import 'package:flutter/material.dart';
import 'package:mymembership_app/views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MyMembership',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
