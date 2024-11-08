import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController otpController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Email OTP')),
      body: ListView(
        children: [
          TextFormField(controller: emailController),
          ElevatedButton(
            onPressed: () async {
              if (await EmailOTP.sendOTP(email: emailController.text)) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("OTP has been sent")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("OTP failed sent")));
              }
            },
            child: const Text('Send OTP'),
          ),
          TextFormField(controller: otpController),
          ElevatedButton(
            onPressed: () => EmailOTP.verifyOTP(otp: otpController.text),
            child: const Text('Verify OTP'),
          ),
        ],
      ),
    );
  }
}
