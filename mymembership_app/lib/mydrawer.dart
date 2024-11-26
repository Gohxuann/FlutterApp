import 'package:flutter/material.dart';
import 'package:mymembership_app/new_news.dart';
import 'package:mymembership_app/views/home_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

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
          const ListTile(
            title: Text("Members"),
          ),
          const ListTile(
            title: Text("Payments"),
          ),
          const ListTile(
            title: Text("Products"),
          ),
          const ListTile(
            title: Text("Vetting"),
          ),
          const ListTile(
            title: Text("Settings"),
          ),
          const ListTile(
            title: Text("Logout"),
          ),
        ],
      ),
    );
  }
}
