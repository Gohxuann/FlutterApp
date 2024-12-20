import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mymembership_app/views/auth/otp_verification.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Lottie.asset(
                'assets/video/email.json',
                height: 325,
                width: 325,
              ),
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              const Text(
                'We will send you an *One Time Passcode* via this email address',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  sendOTP();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: Colors.black, width: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  shadowColor: Colors.grey.withOpacity(0.5),
                ),
                child: const Text(
                  'Send OTP',
                  style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendOTP() async {
    if (await EmailOTP.sendOTP(email: emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP has been sent"),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (content) =>
              OtpVerificationScreen(email: emailController.text),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("OTP failed sent")));
    }
  }
}
