import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mymembership_app/myconfig.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  bool privacyPolicy = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Let's create your account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // First Name and Last Name Fields
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: firstnameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Username Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-Mail',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Email Field
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 15),
              // Password Field
              TextField(
                controller: passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Phone Number Field
              TextField(
                controller: confirmpasswordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Privacy Policy Checkbox
              Row(
                children: [
                  Checkbox(
                    value: privacyPolicy,
                    onChanged: (value) {
                      setState(() {
                        privacyPolicy = value ?? false;
                      });
                    },
                  ),
                  const Text("I agree to "),
                  GestureDetector(
                    onTap: () {
                      // Open Privacy Policy
                    },
                    child: const Text(
                      "Privacy Policy",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Text(" and "),
                  GestureDetector(
                    onTap: () {
                      // Open Terms of Use
                    },
                    child: const Text(
                      "Terms of use",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Create Account Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onRegisterDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                      endIndent: 10,
                    ),
                  ),
                  Text(
                    "Or Sign Up With",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Social Media Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/logos/google.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ), // Add Google icon image in assets
                    iconSize: 40,
                    onPressed: () {
                      // Handle Google Sign Up
                    },
                  ),
                  // Uncomment to add Facebook button
                  // IconButton(
                  //   icon: Image.asset(
                  //       'assets/facebook_icon.png'), // Add Facebook icon image in assets
                  //   iconSize: 40,
                  //   onPressed: () {
                  //     // Handle Facebook Sign Up
                  //   },
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onRegisterDialog() {
    String email = emailController.text;
    String password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter email and password"),
      ));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                userRegistration();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //   content: Text("Registration Canceled"),
                //   backgroundColor: Colors.red,
                // ));
              },
            ),
          ],
        );
      },
    );
  }

  void userRegistration() {
    String email = emailController.text;
    String password = passwordController.text;
    String firstname = firstnameController.text;
    String lastname = lastNameController.text;
    String phone = phoneController.text;
    String confirmpass = confirmpasswordController.text;

    http.post(
        Uri.parse("${MyConfig.servername2}/membership/api/register_user.php"),
        body: {
          "firstname": firstname,
          "lastname": lastname,
          "email": email,
          "password": password,
          "phone": phone
        }).then((response) {
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          // User user = User.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Success"),
            backgroundColor: Color.fromARGB(255, 12, 12, 12),
          ));
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (content) => const MainScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
