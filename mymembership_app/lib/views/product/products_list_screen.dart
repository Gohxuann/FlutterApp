import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:mymembership_app/models/myproduct.dart';
import 'package:mymembership_app/myconfig.dart';
import 'package:mymembership_app/views/product/add_to_cart.dart';
import 'package:mymembership_app/views/product/product_screen.dart';
import 'package:mymembership_app/views/shared/mydrawer.dart';
import 'package:http/http.dart' as http;

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<MyProduct> productList = [];
  late double screenWidth, screenHeight;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  String status = "Loading...";
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;

  @override
  void initState() {
    super.initState();
    loadProductList();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text('Product List', style: TextStyle(color: Colors.white)),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (content) => AddToCartScreen()));
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: productList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, color: Colors.red, size: 80),
                  const SizedBox(height: 10),
                  Text(
                    "No Products Available",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Please check back later or refresh the page.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(productList.length, (index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          margin: const EdgeInsets.all(8),
                          child: InkWell(
                            splashColor: Colors.white,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      opaque: false,
                                      barrierDismissible: true,
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          FadeTransition(
                                              opacity: animation,
                                              child: ProductScreen(
                                                product: productList[index],
                                              ))));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      child: Image.network(
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                SizedBox(
                                          height: screenHeight / 4,
                                          child: Image.asset(
                                              "assets/photo/na.jpg"),
                                        ),
                                        width: double.infinity,
                                        height: screenHeight / 4.8,
                                        fit: BoxFit.cover,
                                        "${MyConfig.servername2}/membership/assets/product/${productList[index].productFilename}",
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 4),
                                          ),
                                          const SizedBox(width: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.deepPurple,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              '12% OFF',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              productList[index]
                                                  .productName
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "RM${productList[index].productPrice.toString()}",
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.deepPurple,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              'Cheapest on 12.12',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.blueGrey,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              'COD',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            productList[index]
                                                .productRate
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: curpage > 1
                            ? () {
                                setState(() {
                                  curpage = 1;
                                  loadProductList();
                                });
                              }
                            : null,
                        icon: const Icon(Icons.first_page),
                      ),
                      IconButton(
                        onPressed: curpage > 1
                            ? () {
                                setState(() {
                                  curpage--;
                                  loadProductList();
                                });
                              }
                            : null,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Text("$curpage of $numofpage"),
                      IconButton(
                        onPressed: curpage < numofpage
                            ? () {
                                setState(() {
                                  curpage++;
                                  loadProductList();
                                });
                              }
                            : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                      IconButton(
                        onPressed: curpage < numofpage
                            ? () {
                                setState(() {
                                  curpage = numofpage;
                                  loadProductList();
                                });
                              }
                            : null,
                        icon: const Icon(Icons.last_page),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      drawer: MyDrawer(),
    );
  }

  void loadProductList() {
    http
        .get(Uri.parse(
            "${MyConfig.servername2}/membership/api/load_product.php?pageno=$curpage"))
        .then((response) {
      log(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['product'];
          productList.clear();
          for (var item in result) {
            MyProduct myproduct = MyProduct.fromJson(item);
            productList.add(myproduct);
          }
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());
          setState(() {});
        } else {
          status = "No Data";
        }
      } else {
        status = "Error loading data";
        print("Error");
        setState(() {});
      }
    });
  }
}
