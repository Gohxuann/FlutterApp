//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, String? title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // body: newsList.isEmpty
      //     ? const Center(
      //         child: Text("Loading..."),
      //       )
      //     : ListView.builder(
      //         itemCount: newsList.length,
      //         itemBuilder: (context, index) {
      //           return Card(
      //             child: ListTile(
      //               title: Text(newsList[index].newsTitle.toString()),
      //               subtitle: Text(newsList[index].newsDetails.toString()),
      //             ),
      //           );
      //         }),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              onTap: () {},
              title: const Text("Newsletter"),
              leading: const Icon(Icons.newspaper),
            ),
            ListTile(
              onTap: () {},
              title: const Text("Events"),
            ),
            ListTile(
              onTap: () {},
              title: const Text("Members"),
            ),
            ListTile(
              onTap: () {},
              title: const Text("Vetting"),
            ),
            ListTile(
              onTap: () {},
              title: const Text("Members"),
            ),
            ListTile(
              onTap: () {},
              title: const Text("Payment"),
            ),
            ListTile(
              onTap: () {},
              title: const Text("Product"),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     // loadNewsData();
      //     await Navigator.push(context,
      //         MaterialPageRoute(builder: (content) => const NewNewsScreen()));
      //     loadNewsData();
      //   },
      //   child: const Icon(Icons.add),
      // )
    );
  }
}
