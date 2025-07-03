import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/product_provider.dart';
import '../models/product.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String searchQuery = ''; // State variable to store search input

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title:
            const Text('Product List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null && provider.products.isEmpty) {
            return Center(
              child: Text('An Error Occurred: ${provider.errorMessage}'),
            );
          }

          // Filter products based on search query
          final filteredProducts = provider.products
              .where((product) => product.name
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
              .toList();

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12), // Border radius
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none, // No border outline
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value; // Update search query on input change
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => provider.fetchProducts(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 16),
                    itemCount: filteredProducts.length, // Use filtered list
                    itemBuilder: (context, index) {
                      final Product product =
                          filteredProducts[index]; // Use filtered list
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          title: Text(
                            product.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Stock: ${product.stock}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          trailing: Wrap(
                            spacing: 12,
                            children: [
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue[50],
                                  foregroundColor: Colors.blueAccent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(Icons.edit,
                                    color: Colors.blueAccent),
                                label: const Text('Edit'),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ProductFormScreen(product: product),
                                  ));
                                },
                              ),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red[50],
                                  foregroundColor: Colors.blueAccent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                label: const Text('Delete',
                                    style: TextStyle(color: Colors.redAccent)),
                                onPressed: () => _showDeleteConfirmation(
                                    context, product.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ProductFormScreen()),
                        );
                      },
                      label: const Text(
                        'Add Product',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 4,
                        shadowColor: Colors.blueAccent.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.blueAccent)),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: const Text('Delete',
                  style: TextStyle(color: Colors.redAccent)),
              onPressed: () async {
                await Provider.of<ProductProvider>(context, listen: false)
                    .deleteProduct(productId);
                if (context.mounted) {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product deleted')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
