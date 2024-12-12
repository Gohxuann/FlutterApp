class MyCart {
  String? productId;
  String? productName;
  String? productType;
  String? addedDate;
  double? productPrice; // Change to double
  int? quantity; // Change to int
  String? productFilename;

  MyCart({
    this.productId,
    this.productName,
    this.productType,
    this.addedDate,
    this.productPrice,
    this.quantity,
    this.productFilename,
  });

  MyCart.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productType = json['product_type'];
    addedDate = json['added_date'];
    productPrice = double.tryParse(json['product_price']); // Parse as double
    quantity = int.tryParse(json['quantity']); // Parse as int
    productFilename = json['product_filename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_type'] = productType;
    data['added_date'] = addedDate;
    data['product_price'] =
        productPrice?.toString(); // Convert back to String for JSON
    data['quantity'] = quantity?.toString(); // Convert back to String for JSON
    data['product_filename'] = productFilename;
    return data;
  }
}
