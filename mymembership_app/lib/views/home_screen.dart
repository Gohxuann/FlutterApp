import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mymembership_app/edit_news.dart';
import 'package:mymembership_app/models/news.dart';
import 'package:mymembership_app/myconfig.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mymembership_app/mydrawer.dart';
import 'package:mymembership_app/new_news.dart';
import 'package:mymembership_app/views/auth/login_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, String? title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
        title: const Text("Newsletter"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _googleSignIn.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (content) => const LoginScreen()));
            },
          ),
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
                    child: ListTile(
                  onLongPress: () {
                    deleteDialog(index);
                  },
                  title: Text(
                      truncateString(newsList[index].newsTitle.toString(), 50),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        truncateString(
                            newsList[index].newsDescription.toString(), 100),
                        style: const TextStyle(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.thumb_up,
                              color: Colors.green.shade700, size: 16),
                          const SizedBox(width: 4),
                          Text('${newsList[index].likes}'),
                          const SizedBox(width: 16),
                          Icon(Icons.thumb_down,
                              color: Colors.red.shade700, size: 16),
                          const SizedBox(width: 4),
                          Text('${newsList[index].dislikes}'),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.arrow_forward,
                    ),
                    onPressed: () {
                      showNewsDesDialog(index);
                    },
                  ),
                ));
              },
            ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewNewsScreen(),
                ));
            loadNewsData();
          },
          child: const Icon(Icons.add)),
    );
  }

  String truncateString(String str, int length) {
    if (str.length > length) {
      str = str.substring(0, length);
      return "$str...";
    } else {
      return str;
    }
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
            news.likes = item['likes'] ?? 0;
            news.dislikes = item['dislikes'] ?? 0;
            newsList.add(news);
          }
        }
        setState(() {});
      } else {
        print("Error");
      }
    });
  }

  void showNewsDesDialog(int index) {
    // Load likes and dislikes before showing dialog
    loadLikesDislikes(index);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          titlePadding: const EdgeInsets.all(0),
          title: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Text(
              newsList[index].newsTitle.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('yyyy-MM-dd HH:mm').format(
                    DateTime.parse(newsList[index].newsDate.toString())),
                style: const TextStyle(fontSize: 14.0, color: Colors.black54),
              ),
              const Divider(thickness: 2),
              SizedBox(height: 8.0),
              SingleChildScrollView(
                child: Text(
                  newsList[index].newsDescription.toString(),
                  style: const TextStyle(fontSize: 16.0, height: 1.5),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up, color: Colors.green.shade700),
                    onPressed: () {
                      updateLikeDislike(index, 'like');
                    },
                  ),
                  Text(
                    '${newsList[index].likes}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  IconButton(
                    icon: Icon(Icons.thumb_down, color: Colors.red.shade700),
                    onPressed: () {
                      updateLikeDislike(index, 'dislike');
                    },
                  ),
                  Text(
                    '${newsList[index].dislikes}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Edit",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.pop(context);
                News news = newsList[index];

                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => EditNewsScreen(news: news)));
                loadNewsData();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void loadLikesDislikes(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      newsList[index].likes =
          prefs.getInt('likes_${newsList[index].newsId}') ?? 0;
      newsList[index].dislikes =
          prefs.getInt('dislikes_${newsList[index].newsId}') ?? 0;
    });
  }

  void updateLikeDislike(int index, String action) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (action == 'like') {
        newsList[index].likes += 1;
      } else if (action == 'dislike') {
        newsList[index].dislikes += 1;
      }
    });

    // Save the updated values
    await prefs.setInt(
        'likes_${newsList[index].newsId}', newsList[index].likes);
    await prefs.setInt(
        'dislikes_${newsList[index].newsId}', newsList[index].dislikes);
  }

  void deleteDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Delete \"${truncateString(newsList[index].newsTitle.toString(), 20)}\"",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: const Text("Are you sure you want to delete this news?"),
            actions: [
              TextButton(
                  onPressed: () {
                    deleteNews(index);
                    Navigator.pop(context);
                  },
                  child: const Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"))
            ],
          );
        });
  }

  void deleteNews(int index) {
    http.post(
        Uri.parse("${MyConfig.servername2}/membership/api/delete_news.php"),
        body: {"newsid": newsList[index].newsId.toString()}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        log(data.toString());
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          ));
          loadNewsData(); //reload data
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
