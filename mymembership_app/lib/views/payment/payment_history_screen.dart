import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mymembership_app/myconfig.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List<dynamic> payments = [];
  List<dynamic> filteredPayments = [];
  bool isLoading = true;
  String selectedStatus = "success"; // Default filter to "Success"
  final DateFormat df = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  void initState() {
    super.initState();
    fetchPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Payment History",
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
          : payments.isEmpty
              ? const Center(child: Text("No payment history found"))
              : Column(
                  children: [
                    // Toggle Buttons for Filtering
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChoiceChip(
                            label: const Text("Success"),
                            selected: selectedStatus == "success",
                            onSelected: (isSelected) {
                              if (isSelected) {
                                setState(() {
                                  selectedStatus = "success";
                                  filterPayments();
                                });
                              }
                            },
                            selectedColor: Colors.green.shade200,
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: const Text("Pending"),
                            selected: selectedStatus == "pending",
                            onSelected: (isSelected) {
                              if (isSelected) {
                                setState(() {
                                  selectedStatus = "pending";
                                  filterPayments();
                                });
                              }
                            },
                            selectedColor: Colors.orange.shade200,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredPayments.length,
                        itemBuilder: (context, index) {
                          final payment = filteredPayments[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            elevation: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.deepPurple.shade400,
                                    Colors.blueGrey.shade400
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Receipt ID: ${payment['receipt_id']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: payment['payment_status'] ==
                                                    'success'
                                                ? Colors.green.shade100
                                                : Colors.red.shade100,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            payment['payment_status'],
                                            style: TextStyle(
                                              color:
                                                  payment['payment_status'] ==
                                                          'success'
                                                      ? Colors.green.shade700
                                                      : Colors.orange.shade700,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Membership: ${payment['membership_name'] ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Date: ${df.format(DateTime.parse(payment['payment_date']))}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'RM ${payment['amount']}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Future<void> fetchPaymentHistory() async {
    try {
      final response = await http.get(
        Uri.parse("${MyConfig.servername2}/membership/api/payment_history.php"),
      );

      if (response.statusCode == 200) {
        setState(() {
          payments = json.decode(response.body)['data'];
          filterPayments();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterPayments() {
    setState(() {
      filteredPayments = payments
          .where((payment) => payment['payment_status'] == selectedStatus)
          .toList();
    });
  }
}
