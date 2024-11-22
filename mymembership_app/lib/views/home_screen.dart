//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mymembership_app/new_news.dart';
import 'package:mymembership_app/views/auth/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, String? title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isCollapsed = true; // Tracks the state of the sidebar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content area
          Positioned.fill(
            child: Center(
              child: const Text(
                "Welcome to the Home Page!",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          // Floating Sidebar
          Positioned(
            top: 20,
            left: isCollapsed ? 5 : 20, // Adjust for collapse/expand
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isCollapsed ? 60 : 200,
              height: MediaQuery.of(context).size.height -
                  40, // Full height with some padding
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16), // Rounded edges
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(2, 4), // Shadow offset
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top navigation items
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            isCollapsed = !isCollapsed;
                          });
                        },
                      ),
                      const Divider(color: Colors.white),
                      _buildSidebarItem(Icons.home, "Home"),
                      _buildSidebarItem(Icons.edit, "Edit"),
                      _buildSidebarItem(Icons.payment, "Payment"),
                      _buildSidebarItem(Icons.notifications, "Notifications"),
                      _buildSidebarItem(Icons.info, "About"),
                    ],
                  ),
                  // Bottom profile and settings
                  Column(
                    children: [
                      _buildSidebarItem(Icons.person, "Profile"),
                      _buildSidebarItem(Icons.settings, "Settings"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewNewsScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // return Scaffold(
  //   appBar: AppBar(
  //     title: const Text("Home"),
  //     actions: [
  //       IconButton(
  //         icon: const Icon(Icons.logout),
  //         onPressed: () {
  //           _googleSignIn.signOut();
  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (content) => const LoginScreen()));
  //         },
  //       ),
  //     ],
  //   ),
  //   drawer: Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: [
  //         const DrawerHeader(
  //           decoration: BoxDecoration(
  //             color: Colors.grey,
  //           ),
  //           child: Text('Drawer Header'),
  //         ),
  //         ListTile(
  //           title: const Text('Newsletter 1'),
  //           onTap: () {},
  //         ),
  //         ListTile(
  //           title: const Text('Newsletter 2'),
  //           onTap: () {},
  //         ),
  //       ],
  //     ),
  //   ),
  //   floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => const NewNewsScreen(),
  //             ));
  //       },
  //       child: const Icon(Icons.add)),
  // );
  Widget _buildSidebarItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          if (!isCollapsed) const SizedBox(width: 10),
          if (!isCollapsed)
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
        ],
      ),
    );
  }
}
