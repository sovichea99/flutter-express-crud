import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  final Map<String, String> headers = {'Content-Type': 'application/json'};
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> getProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Product not found');
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: headers,
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 201){
      throw Exception('Failed to add product');
    }
  }

  Future<void> updateProduct(int id, Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: headers,
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }


  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode != 200 && response.statusCode != 204){
      throw Exception('Failed to delete product!');
    }
  }
}
