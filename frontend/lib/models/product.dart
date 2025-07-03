class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['PRODUCTID'] as int,
      name: json['PRODUCTNAME'] as String,
      price: (json['PRICE'] as num).toDouble(),
      stock: json['STOCK'] as int,
    );
  }
  //CONVERT A PRODUCT INSTANCE TO A MAP (JSON)
  // The backend uses 'productName', so I match that.
  Map<String, dynamic> toJson() {
    return {
      'productName': name,
      'price': price,
      'stock': stock,
    };
  }
}
