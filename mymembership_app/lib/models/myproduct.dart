class MyProduct {
  String? productId;
  String? productName;
  String? productDescription;
  String? productType;
  String? productPrice;
  String? productFilename;
  String? productRate;
  String? productDate;

  MyProduct(
      {this.productId,
      this.productName,
      this.productDescription,
      this.productType,
      this.productPrice,
      this.productFilename,
      this.productRate,
      this.productDate});

  MyProduct.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    productType = json['product_type'];
    productPrice = json['product_price'];
    productFilename = json['product_filename'];
    productRate = json['product_rate'];
    productDate = json['product_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_description'] = productDescription;
    data['product_type'] = productType;
    data['product_price'] = productPrice;
    data['product_filename'] = productFilename;
    data['product_rate'] = productRate;
    data['product_date'] = productDate;
    return data;
  }
}
