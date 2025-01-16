import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymembership_app/myconfig.dart';
import 'package:mymembership_app/views/payment/email_input_screen.dart';
import 'package:shimmer/shimmer.dart';

class MembershipDetailsScreen extends StatefulWidget {
  final String membershipId;

  const MembershipDetailsScreen({Key? key, required this.membershipId})
      : super(key: key);

  @override
  State<MembershipDetailsScreen> createState() =>
      _MembershipDetailsScreenState();
}

class _MembershipDetailsScreenState extends State<MembershipDetailsScreen> {
  Map<String, dynamic>? membershipDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMembershipDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Membership Details",
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
          ? ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            )
          : membershipDetails == null
              ? const Center(child: Text("Details not available"))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Membership Card
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.deepPurple, Colors.blueGrey],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Membership: ${membershipDetails!['membership_name'] ?? "N/A"}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/photo/chip.png',
                                    height: 40,
                                    width: 40,
                                  ),
                                  const SizedBox(width: 16),
                                  const Text(
                                    "5% OFF ALL ORDERS",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Valid Thru: ${membershipDetails!['membership_duration'] ?? "N/A"}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Membership Details
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("Description"),
                            const SizedBox(height: 8),
                            _buildSectionContent(
                              membershipDetails!['membership_description'] ??
                                  "N/A",
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle("Benefits"),
                            const SizedBox(height: 8),
                            ExpansionTile(
                              title: const Text(
                                "View Benefits",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              children: membershipDetails!['membership_benefit']
                                  .split(',')
                                  .map<Widget>(
                                    (benefit) => ListTile(
                                      leading: const Icon(Icons.check_circle,
                                          color: Colors.green),
                                      title: Text(
                                        benefit.trim(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle("Price"),
                            const SizedBox(height: 8),
                            Text(
                              "RM ${membershipDetails!['membership_price'] ?? "0.00"}",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle("Duration"),
                            const SizedBox(height: 8),
                            Text(
                              membershipDetails!['membership_duration'] ??
                                  "N/A",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle("Terms & Conditions"),
                            const SizedBox(height: 8),
                            _buildSectionContent(
                              membershipDetails!['membership_term'] ?? "N/A",
                            ),
                          ],
                        ),
                      ),

                      // Subscribe Button
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: _handlePayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.card_membership,
                                    color: Colors.white),
                                const SizedBox(width: 10),
                                const Text(
                                  "Subscribe Now",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void fetchMembershipDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
            "${MyConfig.servername2}/membership/api/fetch_membership_details.php?membership_id=${widget.membershipId}"),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        setState(() {
          membershipDetails = jsonData['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handlePayment() {
    if (membershipDetails != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmailInputScreen(
            amount: membershipDetails!['membership_price'] ?? '0.00',
            membershipName:
                membershipDetails!['membership_name'] ?? 'Membership',
            membershipId: widget.membershipId,
          ),
        ),
      );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.black87,
      ),
    );
  }
}
