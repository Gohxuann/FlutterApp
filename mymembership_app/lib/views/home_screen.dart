import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mymembership_app/models/news.dart';
import 'package:mymembership_app/myconfig.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
//import 'package:mymembership_app/views/auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, String? title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //final GoogleSignIn _googleSignIn = GoogleSignIn();

  List<News> newsList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.logout),
          //   onPressed: () {
          //     _googleSignIn.signOut();
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (content) => const LoginScreen()));
          //   },
          // ),
        ],
      ),
      body: newsList.isEmpty
          ? const Center(
              child: Text("Loading..."),
            )
          : ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                return Card(
                    child: Column(children: [
                  Text(newsList[index].newsTitle.toString()),
                  Text(newsList[index].newsDescription.toString()),
                  Text(newsList[index].newsDate.toString()),
                ]));
              },
            ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Newsletter 1'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Newsletter 2'),
              onTap: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            loadNewsData();
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const NewNewsScreen(),
            //     ));
          },
          child: const Icon(Icons.add)),
    );
  }

  void loadNewsData() {
    http
        .get(
      Uri.parse("${MyConfig.servername2}/membership/api/load_news.php"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['news'];
          newsList.clear();
          for (var item in result) {
            News news = News.fromJson(item);
            newsList.add(news);
            //print(news.newsDate);
          }
        }
        setState(() {});
      } else {
        print("Error");
      }
    });
  }
}
