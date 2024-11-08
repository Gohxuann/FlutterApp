import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mymembership_app/myconfig.dart';
import 'package:mymembership_app/views/emailotp_verify_screen.dart';
import 'package:mymembership_app/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'register_screen.dart';
import 'package:email_auth/email_auth.dart';

class EmailOtpVerificationPage extends StatefulWidget {
  final String email;
  const EmailOtpVerificationPage({super.key, required this.email});

  @override
  State<EmailOtpVerificationPage> createState() =>
      _EmailOtpVerificationPageState();
}

class _EmailOtpVerificationPageState extends State<EmailOtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    sendOtp; // Send OTP when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      'Verify Your Email',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'An OTP has been sent to your email: ${widget.email}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter OTP",
                      prefixIcon: const Icon(Icons.verified_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _isLoading ? 'Verifying...' : 'Verify OTP',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _isLoading ? null : sendOtp,
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void sendOtp() async {
    setState(() => _isLoading = true);
    try {
      EmailAuth emailAuth = EmailAuth(sessionName: "MyMembership");
      bool res = await emailAuth.sendOtp(recipientMail: widget.email.trim());
      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("OTP Sent"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("We could not send the OTP"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error sending OTP: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _verifyOtp() async {
    String enteredOtp = _otpController.text;
    if (enteredOtp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter the OTP"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      EmailAuth emailAuth = EmailAuth(sessionName: "MyMembership");
      bool res = emailAuth.validateOtp(
        recipientMail: widget.email.trim(),
        userOtp: enteredOtp.trim(),
      );
      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("OTP Verification Successful"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid OTP"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("OTP Verification Failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
