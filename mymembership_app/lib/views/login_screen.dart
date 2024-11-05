import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo
            Center(
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 10,
                    width: 10,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Welcome Text
            Text(
              "Welcome!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 5),

            // Subtitle Text
            Text(
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
              decoration: InputDecoration(
                labelText: "E-Mail",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Password TextField
            TextField(
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock_outline),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text("Remember Me"),
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
              // children: [
              //   IconButton(
              //     onPressed: () {},
              //     icon: Image.network('https://i.ibb.co/5sR7JqK/google.png'),
              //     iconSize: 40,
              //   ),
              //   const SizedBox(width: 20),
              //   IconButton(
              //     onPressed: () {},
              //     icon: Image.network('https://i.ibb.co/5sR7JqK/facebook.png'),
              //     iconSize: 40,
              //   ),
              // ],
            ),
          ],
        ),
      ),
    );
  }
}
