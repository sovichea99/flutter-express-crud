import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters to access the private state variables
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // --- THE PROVIDER PATTERN ---
  // A generic method to handle loading and error states for API calls
  Future<void> _handleApiCall(Future<void> apiCall) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify UI that is loading

    try {
      await apiCall;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI that loading is finished
    }
  }

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

  Future<void> addProduct(Product product) async {
    await _handleApiCall(_apiService.addProduct(product));
    if (_errorMessage == null) {
      fetchProducts(); // Refresh the list after adding
    }
  }

  Future<void> updateProduct(int id, Product product) async {
    await _handleApiCall(_apiService.updateProduct(id, product));
    if (_errorMessage == null) {
      fetchProducts(); // Refresh the list after updating
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    await _handleApiCall(_apiService.deleteProduct(id));
    if (_errorMessage == null) {
      _products.removeWhere((product) => product.id == id);
      notifyListeners(); // Optimistic update
    }
  }
}
