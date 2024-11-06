import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mymembership_app/myconfig.dart';
import 'package:mymembership_app/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool rememberme = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPref();
  }

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                                    content:
                                        Text("Please enter your credention"),
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
                      const Text("Remember Me", style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Forget Password?"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Sign In Button
              ElevatedButton(
                onPressed: onLogin,
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
                child: const Text("Sign In"),
              ),

              const SizedBox(height: 15),

              // Create Account Button
              ElevatedButton(
                onPressed: () {},
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

              //const SizedBox(height: 20),

              // Sign In with Google & Facebook
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: IconButton(
                      onPressed: () {
                        // signInWithGoogle();
                      },
                      icon: Image.asset('assets/logos/google.png',
                          width: 80, height: 80, fit: BoxFit.cover),
                    ),
                  ),
                  //const SizedBox(width: 20),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Image.network('https://i.ibb.co/5sR7JqK/facebook.png'),
                  //   iconSize: 40,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // signInWithGoogle() async {
  //   GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  //   // Define credential as `final`
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   // Sign in with the credential
  //   UserCredential userCredential =
  //       await FirebaseAuth.instance.signInWithCredential(credential);
  //   print(userCredential.user?.displayName);

  //   if (userCredential.user != null) {
  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //       return const HomeScreen();
  //     }));
  //   }
  // }

  void onLogin() {
    print("Login button pressed");
    String email = emailcontroller.text;
    String password = passwordcontroller.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter email and password"),
      ));
      return;
    }
    print("Starting HTTP request...");
    http.post(
        //Uri.parse("${MyConfig}/membership_db/api/login_user.php"),
        Uri.parse("http://172.20.10.5/membership/api/login_user.php"),
        body: {"email": email, "password": password}).then((response) {
      // print(response.statusCode);
      // print(response.body);to check if it is working or not
      print("Received response: ${response.body}"); // Debugging response
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          // User user = User.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success"),
            backgroundColor: Colors.green,
          ));
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => const HomeScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
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
}
