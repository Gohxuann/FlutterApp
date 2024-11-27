import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mymembership_app/views/auth/login_screen.dart';
import 'package:mymembership_app/views/newsletter/news_screen.dart';

class MyDrawer extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
                // You can add color or other styling here if needed
                ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            onTap: () {
              // Define onTap actions here if needed
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const HomeScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0); // Slide in from the right
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            title: const Text("Newsletter"),
          ),
          ListTile(
            title: const Text("Events"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Members"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Payments"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Products"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Vetting"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Logout"),
            onTap: () {
              _googleSignIn.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (content) => const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
