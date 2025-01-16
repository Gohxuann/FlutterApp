import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mymembership_app/myconfig.dart';
import 'package:mymembership_app/views/payment/payment_history_screen.dart';

class ProceedPaymentScreen extends StatefulWidget {
  final String amount;
  final String membershipName;
  final String membershipId;
  final String email;

  const ProceedPaymentScreen({
    Key? key,
    required this.amount,
    required this.membershipName,
    required this.membershipId,
    required this.email,
  }) : super(key: key);

  @override
  State<ProceedPaymentScreen> createState() => _ProceedPaymentScreenState();
}

class _ProceedPaymentScreenState extends State<ProceedPaymentScreen> {
  late WebViewController webcontroller;
  //late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    String email = widget.email.toString();
    String amount = widget.amount.toString();
    String membershipName = widget.membershipName.toString();
    String membershipId = widget.membershipId.toString();

    print(email);
    print(amount);
    print(membershipName);
    print(membershipId);

    super.initState();
    webcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://mymember.threelittlecar.com/membership/api/create_bill.php?email=$email&amount=$amount&membershipName=$membershipName&membershipId=$membershipId'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Payment",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        body: WebViewWidget(controller: webcontroller));
  }
}
