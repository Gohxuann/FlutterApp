import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mymembership_app/views/newsletter/edit_news.dart';
import 'package:mymembership_app/models/news.dart';
import 'package:mymembership_app/myconfig.dart';
import 'package:http/http.dart' as http;
import 'package:mymembership_app/mydrawer.dart';
import 'package:mymembership_app/views/newsletter/new_news.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, String? title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<News> newsList = [];
  List<News> filteredNewsList = [];
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  late double screenWidth, screenHeight;
  var color;

  @override
  void initState() {
    super.initState();
    loadNewsData(); // Load all news data initially
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Newsletter",
            style: TextStyle(color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                loadNewsData();
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search News...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (value) {
                  setState(() {
                    loadAllNewsData();
                    filteredNewsList = newsList
                        .where((news) =>
                            (news.newsTitle?.toLowerCase() ?? '')
                                .contains(value.toLowerCase()) ||
                            (news.newsDescription?.toLowerCase() ?? '')
                                .contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
            Expanded(
              child: filteredNewsList.isEmpty
                  ? const Center(
                      child: Text("Loading..."),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredNewsList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                onLongPress: () {
                                  deleteDialog(index);
                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        truncateString(
                                            filteredNewsList[index]
                                                .newsTitle
                                                .toString(),
                                            50),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      df.format(DateTime.parse(
                                          filteredNewsList[index]
                                              .newsDate
                                              .toString())),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      truncateString(
                                          filteredNewsList[index]
                                              .newsDescription
                                              .toString(),
                                          100),
                                      style: const TextStyle(fontSize: 14),
                                      textAlign: TextAlign.justify,
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                  ),
                                  onPressed: () {
                                    showNewsDesDialog(filteredNewsList[index]);
                                  },
                                ),
                              ));
                            },
                          ),
                        ),
                        // Pagination widget
                        Container(
                          height: screenHeight * 0.08,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.first_page),
                                color: curpage > 1 ? Colors.blue : Colors.grey,
                                onPressed: curpage > 1
                                    ? () {
                                        setState(() {
                                          curpage = 1;
                                          loadNewsData();
                                        });
                                      }
                                    : null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                color: curpage > 1 ? Colors.blue : Colors.grey,
                                onPressed: curpage > 1
                                    ? () {
                                        setState(() {
                                          curpage--;
                                          loadNewsData();
                                        });
                                      }
                                    : null,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  '$curpage of $numofpage',
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                color: curpage < numofpage
                                    ? Colors.blue
                                    : Colors.grey,
                                onPressed: curpage < numofpage
                                    ? () {
                                        setState(() {
                                          curpage++;
                                          loadNewsData();
                                        });
                                      }
                                    : null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.last_page),
                                color: curpage < numofpage
                                    ? Colors.blue
                                    : Colors.grey,
                                onPressed: curpage < numofpage
                                    ? () {
                                        setState(() {
                                          curpage = numofpage;
                                          loadNewsData();
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
        drawer: MyDrawer(),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          overlayOpacity: 0.1,
          spacing: 12,
          spaceBetweenChildren: 5,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.deepPurple,
              label: 'Add News',
              labelStyle: const TextStyle(fontSize: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewNewsScreen(),
                  ),
                );
                loadNewsData();
              },
            ),
          ],
        ));
  }

  String truncateString(String str, int length) {
    if (str.length > length) {
      str = str.substring(0, length);
      return "$str...";
    } else {
      return str;
    }
  }

  void loadAllNewsData() {
    // Load all news data to support searching from all pages
    http
        .get(Uri.parse(
            "${MyConfig.servername2}/membership/api/load_all_news.php"))
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
          setState(() {});
        }
      } else {
        print("Error");
      }
    });
  }

  void loadNewsData() {
    http
        .get(Uri.parse(
            "${MyConfig.servername2}/membership/api/load_news.php?pageno=$curpage"))
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['news'];
          newsList.clear();
          filteredNewsList.clear();
          for (var item in result) {
            News news = News.fromJson(item);
            news.likes = item['likes'] ?? 0;
            news.dislikes = item['dislikes'] ?? 0;
            newsList.add(news);
          }
          filteredNewsList = List.from(newsList);
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());
          setState(() {});
        }
      } else {
        print("Error");
      }
    });
  }

  void showNewsDesDialog(News news) {
    // Load likes and dislikes before showing dialog
    loadLikesDislikes(news);
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
              news.newsTitle.toString(),
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
                df.format(DateTime.parse(news.newsDate.toString())),
                style: const TextStyle(fontSize: 12.0, color: Colors.black54),
              ),
              const Divider(thickness: 2),
              SizedBox(height: 8.0),
              SingleChildScrollView(
                child: Text(
                  news.newsDescription.toString(),
                  style: const TextStyle(fontSize: 14.0, height: 1.5),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up, color: Colors.green.shade700),
                    onPressed: () {
                      updateLikeDislike(news, 'like');
                    },
                  ),
                  Text(
                    '${news.likes}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  IconButton(
                    icon: Icon(Icons.thumb_down, color: Colors.red.shade700),
                    onPressed: () {
                      updateLikeDislike(news, 'dislike');
                    },
                  ),
                  Text(
                    '${news.dislikes}',
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
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
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

  void loadLikesDislikes(News news) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      news.likes = prefs.getInt('likes_${news.newsId}') ?? 0;
      news.dislikes = prefs.getInt('dislikes_${news.newsId}') ?? 0;
    });
  }

  void updateLikeDislike(News news, String action) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (action == 'like') {
        news.likes += 1;
      } else if (action == 'dislike') {
        news.dislikes += 1;
      }
    });

    await prefs.setInt('likes_${news.newsId}', news.likes);
    await prefs.setInt('dislikes_${news.newsId}', news.dislikes);
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
          loadNewsData();
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
