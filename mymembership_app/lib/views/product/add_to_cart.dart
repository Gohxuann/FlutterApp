import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymembership_app/myconfig.dart';
import 'package:mymembership_app/models/mycart.dart';

class AddToCartScreen extends StatefulWidget {
  const AddToCartScreen({Key? key}) : super(key: key);

  @override
  _AddToCartScreenState createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  List<MyCart> cartItems = [];
  bool isLoading = false;
  double totalAmount = 0.0;
  String status = "Loading...";
  List<bool> selectedItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('My Cart', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? _buildEmptyCartView()
              : _buildCartListView(),
      bottomNavigationBar:
          cartItems.isNotEmpty ? _buildBottomCheckoutBar() : null,
    );
  }

  Widget _buildEmptyCartView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Continue Shopping'),
          )
        ],
      ),
    );
  }

  Widget _buildCartListView() {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          child: Row(
            children: [
              // Checkbox for selection
              Checkbox(
                value:
                    selectedItems.length > index ? selectedItems[index] : false,
                onChanged: (value) {
                  setState(() {
                    if (selectedItems.length <= index) {
                      selectedItems.add(value ?? false);
                    } else {
                      selectedItems[index] = value ?? false;
                    }
                  });
                },
              ),
              // Product Image on the left
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  "${MyConfig.servername2}/membership/assets/product/${item.productFilename}",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    "assets/photo/na.jpg",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Product Details on the right
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        item.productName!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Product Price
                      Text(
                        'RM ${item.productPrice!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Quantity Update Row
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (item.quantity! > 1) {
                                setState(() {
                                  item.quantity = item.quantity! - 1;
                                });
                                updateQuantity(item.productId!, item.quantity!);
                              }
                            },
                          ),
                          Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() {
                                item.quantity = item.quantity! + 1;
                              });
                              updateQuantity(item.productId!, item.quantity!);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Text(
                'RM ${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              _showCheckoutDialog();
            },
            child: const Text(
              'Checkout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Checkout'),
          content: Text(
            'Total amount: RM ${totalAmount.toStringAsFixed(2)}\n\nProceed with checkout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Checkout successful!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity < 1) return; // Prevent negative quantities
    http.post(
      Uri.parse(
          "${MyConfig.servername2}/membership/api/update_cart_quantity.php"),
      body: {
        'product_id': productId,
        'quantity': newQuantity.toString(),
      },
    ).then((response) {
      if (response.statusCode == 200) {
        fetchCartItems(); // Refresh cart items after updating
      } else {
        print("Error updating quantity: ${response.statusCode}");
      }
    }).catchError((error) {
      print("Error: $error");
    });
  }

  void fetchCartItems() {
    http
        .get(Uri.parse(
            "${MyConfig.servername2}/membership/api/fetch_cart_items.php"))
        .then((response) {
      log(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['cart'];
          cartItems.clear();
          selectedItems = List.generate(result.length, (index) => false);
          for (var item in result) {
            MyCart mycart = MyCart.fromJson(item);
            cartItems.add(mycart);
          }
          calculateTotal(cartItems);
          setState(() {});
        } else {
          status = "No Data";
        }
      } else {
        status = "Error loading data";
        setState(() {});
      }
    }).catchError((error) {
      status = "Error: $error";
      setState(() {});
    });
  }

  void calculateTotal(List<MyCart> cartItems) {
    totalAmount = 0.0;
    for (var item in cartItems) {
      totalAmount += item.productPrice! * item.quantity!;
    }
    setState(() {});
  }
}
