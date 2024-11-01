import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mymembership_app/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Lottie.asset('assets/video/splash_animation.json', repeat: false),
            SizedBox(
              height: 20,
            ),
            const Text(
              "My Membership",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ]),
        ));
  }
}
