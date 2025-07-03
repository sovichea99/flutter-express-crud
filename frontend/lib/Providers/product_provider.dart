import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  //Getters to access private variables
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  //Method that handle loading and error states for API calls
  Future<void> _handleApiCall(Future<void> apiCall) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); //Notify UI that is loading

    try {
      await apiCall;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); //Notify UI that loading is done
    }
  }

  //Fetch products from API
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _apiService.getProducts();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Add a new product
  Future<void> addProduct(Product product) async {
    await _handleApiCall(_apiService.addProduct(product));
    if (_errorMessage == null){
      fetchProducts(); // Refresh the product list after adding
    }
  }
}
