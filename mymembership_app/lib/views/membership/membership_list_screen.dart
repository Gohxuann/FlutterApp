import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'membership_details_screen.dart';
import 'package:mymembership_app/myconfig.dart';

class MembershipListScreen extends StatefulWidget {
  const MembershipListScreen({Key? key}) : super(key: key);

  @override
  State<MembershipListScreen> createState() => _MembershipListScreenState();
}

class _MembershipListScreenState extends State<MembershipListScreen> {
  List memberships = [];
  bool isLoading = true;
  String status = "Loading memberships...";
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchMemberships();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text("Membership Plans",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.blueGrey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : memberships.isEmpty
              ? Center(child: Text(status))
              : Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        itemCount: memberships.length,
                        controller: PageController(viewportFraction: 0.9),
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final membership = memberships[index];
                          return TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            tween: Tween<double>(
                              begin: currentIndex == index ? 0.9 : 1.0,
                              end: currentIndex == index ? 1.0 : 0.9,
                            ),
                            builder: (context, double value, child) {
                              return Transform.scale(
                                scale: value,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeOutCubic,
                                  child: Card(
                                    elevation: currentIndex == index ? 16 : 8,
                                    shadowColor:
                                        Colors.deepPurple.withOpacity(0.4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(
                                        color:
                                            Colors.deepPurple.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 100, horizontal: 1),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white,
                                            Colors.deepPurple.withOpacity(0.05),
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color.fromARGB(
                                                      0, 102, 103, 154),
                                                  Color(0xFF4A148C),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF6A1B9A)
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 24, horizontal: 16),
                                            child: Column(
                                              children: [
                                                Text(
                                                  membership[
                                                          'membership_name'] ??
                                                      'N/A',
                                                  style: const TextStyle(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.white,
                                                    letterSpacing: 1.5,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.black26,
                                                        offset: Offset(0, 2),
                                                        blurRadius: 4,
                                                      ),
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 24),
                                            child: Column(
                                              children: [
                                                const Text(
                                                  "PRICE",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(
                                                        0xFF9575CD), // Deep Purple 300
                                                    letterSpacing: 4,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  "RM ${membership['membership_price'] ?? '0.00'}",
                                                  style: TextStyle(
                                                    fontSize: 48,
                                                    color: const Color(
                                                        0xFF4A148C), // Deep Purple 900
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: -0.5,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.deepPurple
                                                            .withOpacity(0.2),
                                                        offset:
                                                            const Offset(0, 3),
                                                        blurRadius: 6,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "BENEFITS",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(
                                                          0xFF7E57C2), // Deep Purple 400
                                                      letterSpacing: 3,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  if (membership[
                                                          'membership_benefit'] !=
                                                      null)
                                                    ...membership[
                                                            'membership_benefit']
                                                        .split(',')
                                                        .map(
                                                            (benefit) =>
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          6.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            6),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          gradient:
                                                                              const LinearGradient(
                                                                            colors: [
                                                                              Color(0xFFFFA000), // Amber 700
                                                                              Color(0xFFFFB300), // Amber 600
                                                                            ],
                                                                            begin:
                                                                                Alignment.topLeft,
                                                                            end:
                                                                                Alignment.bottomRight,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.amber.withOpacity(0.3),
                                                                              blurRadius: 4,
                                                                              offset: const Offset(0, 2),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .star,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              18,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              12),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          benefit
                                                                              .trim(),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            height:
                                                                                1.5,
                                                                            color:
                                                                                Color(0xFF424242), // Grey 800
                                                                            letterSpacing:
                                                                                0.3,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ))
                                                        .toList(),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MembershipDetailsScreen(
                                                      membershipId: membership[
                                                          'membership_id'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF6A1B9A),
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 32,
                                                        vertical: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                elevation: 8,
                                                shadowColor:
                                                    const Color(0xFF6A1B9A)
                                                        .withOpacity(0.5),
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "VIEW DETAILS",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      letterSpacing: 2,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Icon(Icons.arrow_forward,
                                                      size: 20),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          memberships.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentIndex == index ? 16 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: currentIndex == index
                                  ? Colors.deepPurple
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  void fetchMemberships() async {
    try {
      final response = await http.get(
        Uri.parse(
            "${MyConfig.servername2}/membership/api/fetch_memberships.php"),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == "success") {
          setState(() {
            memberships = jsonData['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            status = "No memberships available.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          status = "Failed to load memberships.";
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        status = "Error loading memberships.";
        isLoading = false;
      });
    }
  }
}
