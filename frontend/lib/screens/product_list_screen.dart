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
  @override
  void initState() {
    super.initState();
    //fetch products when the screen is initialized
    // Using addPostFrameCallback to ensure the context is fully built before fetching
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product List'),
        ),
        //Consumer widget rebuilds its child when the provider notifies listeners
        body: Consumer<ProductProvider>(
          builder: (context, provider, child) {
          if (provider.isLoading && provider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null && provider.products.isEmpty) {
            return Center(
                child: Text('An Error Occurred: ${provider.errorMessage}'));
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchProducts(),
            child: ListView.builder(
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final Product product = provider.products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Stock: ${product.stock}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\$${product.price.toStringAsFixed(2)}'),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ProductFormScreen(product: product),
                          ));
                        },
                      ),
                      /*IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () =>
                            _showDeleteConfirmation(contex, product.id),
                      ),*/
                    ],
                  ),
                );
              },
            ),
          );
        }));
  }
}
