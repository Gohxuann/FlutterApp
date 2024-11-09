import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:mymembership_app/views/splash_screen.dart';

void main() {
  EmailOTP.config(
    appName: 'MyMembership',
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v4,
  );
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
