import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mymembership_app/myconfig.dart';
import 'package:mymembership_app/views/home_screen.dart';
import 'package:mymembership_app/views/auth/otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool rememberme = false;
  bool _isObscure = true;
  bool _isLoading = false; // Loading state variable
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPref();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.1), // Add spacing to center the content
                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/logos/logopic.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Welcome Text
                  const Text(
                    "Welcome!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 5),

                  // Subtitle Text
                  const Text(
                    "We're glad to have you here. Let's get started!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  // Email TextField
                  TextField(
                    controller: emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "E-Mail",
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Password TextField
                  TextField(
                    obscureText: _isObscure,
                    controller: passwordcontroller,
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

                  const SizedBox(height: 10),

                  // Remember Me & Forgot Password Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Checkbox(value: true, onChanged: (value) {}),
                          Checkbox(
                              value: rememberme,
                              onChanged: (bool? value) {
                                setState(() {
                                  String email = emailcontroller.text;
                                  String pass = passwordcontroller.text;
                                  if (value!) {
                                    if (email.isNotEmpty && pass.isNotEmpty) {
                                      storeSharedPrefs(value, email, pass);
                                    } else {
                                      rememberme = false;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Please enter your credention"),
                                        backgroundColor: Colors.red,
                                      ));
                                      return;
                                    }
                                  } else {
                                    email = "";
                                    pass = "";
                                    storeSharedPrefs(value, email, pass);
                                  }
                                  rememberme = value ?? false;
                                  setState(() {});
                                });
                              }),
                          const Text("Remember Me",
                              style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OtpScreen(),
                            ),
                          );
                        },
                        child: const Text("Forget Password?"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Colors.black, width: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      shadowColor: Colors.grey.withOpacity(0.5),
                    ),
                    child: const Text("Sign In"),
                  ),
                  const SizedBox(height: 20),

                  // Create Account Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // background color
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      //foregroundColor: Colors.black, // text color
                      side: const BorderSide(color: Colors.black, width: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5, // shadow
                      shadowColor: Colors.grey.withOpacity(0.5),
                    ),
                    child: const Text("Create Account"),
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

                  // Sign In with Google & Facebook
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: IconButton(
                          onPressed: () {
                            _handleSignIn();
                          },
                          icon: Image.asset('assets/logos/google.png',
                              width: 80, height: 80, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset('assets/logos/facebook.png',
                            width: 53, height: 53, fit: BoxFit.cover),
                      ),
                    ],
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

  void onLogin() async {
    //print("Login button pressed");
    String email = emailcontroller.text;
    String password = passwordcontroller.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter email and password"),
      ));
      return;
    }
    //print("Starting HTTP request...");
    setState(() => _isLoading = true); // Show loading indicator
    try {
      http.Response response = await http.post(
        Uri.parse("${MyConfig.servername2}/membership/api/login_user.php"),
        body: {"email": email, "password": password},
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success"),
            backgroundColor: Colors.green,
          ));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (content) => const HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    } finally {
      setState(() => _isLoading = false); // Hide loading indicator
    }
  }

  Future<void> storeSharedPrefs(bool value, String email, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      prefs.setString("email", email);
      prefs.setString("password", pass);
      prefs.setBool("rememberme", value);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Saved"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ));
    } else {
      prefs.setString("email", email);
      prefs.setString("password", pass);
      prefs.setBool("rememberme", value);
      emailcontroller.text = "";
      passwordcontroller.text = "";
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences is Removed"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailcontroller.text = prefs.getString("email") ?? "";
    passwordcontroller.text = prefs.getString("password") ?? "";
    rememberme = prefs.getBool("rememberme") ?? false;

    setState(() {});
  }

  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
