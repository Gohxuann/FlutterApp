import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mymembership_app/myconfig.dart';

class NewNewsScreen extends StatefulWidget {
  const NewNewsScreen({super.key});

  @override
  State<NewNewsScreen> createState() => _NewNewsScreenState();
}

class _NewNewsScreenState extends State<NewNewsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool showWarning1 = false;
  bool showWarning2 = false;
  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "New Newsletter",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title TextField
              _buildTextField(
                controller: titleController,
                label: "Title",
                hintText: "News Title",
                icon: Icons.title,
                showWarning: showWarning1,
                warningText: "* Please insert a title.",
                onChanged: (value) {
                  setState(() {
                    showWarning1 = value.isEmpty;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Description TextField
              _buildTextField(
                controller: descriptionController,
                label: "Details",
                hintText: "News Details",
                icon: Icons.description,
                showWarning: showWarning2,
                warningText: "* Please insert details.",
                onChanged: (value) {
                  setState(() {
                    showWarning2 = value.isEmpty;
                  });
                },
                maxLines: 16,
              ),
              const SizedBox(height: 30),

              // Insert Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    minimumSize: Size(screenWidth * 0.8, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: onInsertNewsDialog,
                  child: const Text(
                    "Insert Newsletter",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    required bool showWarning,
    required String warningText,
    required void Function(String) onChanged,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black54),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black38),
            prefixIcon: Icon(icon, color: Colors.black54),
            filled: true,
            fillColor: Colors.grey.shade200,
            contentPadding: const EdgeInsets.all(15),
          ),
          maxLines: maxLines,
          onChanged: onChanged,
        ),
        if (showWarning)
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              warningText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  void onInsertNewsDialog() {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter title and details"),
      ));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const Text(
            "Insert Newsletter",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          ),
          content: const Text(
            "Are you sure you want to insert this news?",
            style: TextStyle(color: Colors.black54),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                insertNews();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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

  void insertNews() {
    String title = titleController.text;
    String description = descriptionController.text;

    http.post(
        Uri.parse("${MyConfig.servername2}/membership/api/insert_news.php"),
        body: {"title": title, "description": description}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Success"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
