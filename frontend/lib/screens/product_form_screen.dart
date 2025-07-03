import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../Providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  // Constructor is used for both Add (product is null) and Edit (product is not null)
  ProductFormScreen({super.key, this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _price = 0.0;
  int _stock = 0;

  // Controllers to pre-fill form fields when editing
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      // Fetch fresh data from API instead of using passed product
      Provider.of<ProductProvider>(context, listen: false)
          .getProductById(widget.product!.id)
          .then((freshProduct) {
        if (mounted) {
          setState(() {
            _nameController.text = freshProduct!.name;
            _priceController.text = freshProduct.price.toString();
            _stockController.text = freshProduct.stock.toString();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final productProvider = Provider.of<ProductProvider>(context, listen: false);

      if (widget.product == null) {
        // This is a new product
        final newProduct = Product(id: 0, name: _name, price: _price, stock: _stock);
        productProvider.addProduct(newProduct);
      } else {
        // This is an existing product, update it
        final updatedProduct = Product(
          id: widget.product!.id, // Pass the existing product ID
          name: _name,
          price: _price,
          stock: _stock,
        );
        productProvider.updateProduct(widget.product!.id, updatedProduct); // Pass id and product
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Match ProductListScreen background
      appBar: AppBar(
        title: Text(
          widget.product == null ? 'Add Product' : 'Edit Product',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent, // Match ProductListScreen app bar
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Card(
          color: Colors.white, // Match ProductListScreen card color
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Match ProductListScreen card radius
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Prevent column from taking full height
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      prefixIcon: const Icon(Icons.label, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product name.';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      prefixIcon: const Icon(Icons.attach_money, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null ||
                          double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return 'Please enter a valid positive price.';
                      }
                      return null;
                    },
                    onSaved: (value) => _price = double.parse(value!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _stockController,
                    decoration: InputDecoration(
                      labelText: 'Stock',
                      prefixIcon: const Icon(Icons.inventory, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          int.tryParse(value) == null ||
                          int.parse(value) < 0) {
                        return 'Please enter a valid, non-negative stock amount.';
                      }
                      return null;
                    },
                    onSaved: (value) => _stock = int.parse(value!),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent, // Match ProductListScreen button
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0), // Match ProductListScreen button
                        ),
                        elevation: 4,
                        shadowColor: Colors.blueAccent.withOpacity(0.3),
                      ),
                      child: Text(
                        widget.product == null ? 'Add' : 'Save',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
