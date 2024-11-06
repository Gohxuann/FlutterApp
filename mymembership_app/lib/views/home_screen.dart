//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mymembership_app/views/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, String? title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyMembership',
      color: Colors.white,
    );
  }
}
