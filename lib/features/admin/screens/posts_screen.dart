import 'package:amazon_clone/commons/widgets/loader.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/providers/admin/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/services/admin_service.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:provider/provider.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final AdminService adminService = AdminService();
  bool isLoading = false;

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  void getAllProducts() async {
    isLoading = true;
    List<Product> fetchProducts = await adminService.getAllProducts(context: context);
    Provider.of<ProductProvider>(context, listen: false).setProducts(fetchProducts);
    isLoading = false;

    setState(() {});
  }

  void deleteProduct(Product product) {
    adminService.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        Provider.of<ProductProvider>(context, listen: false).removeProduct(product);
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<ProductProvider>(context).products;

    return Scaffold(
      body: isLoading
          ? const Loader()
          : GridView.builder(
              padding: const EdgeInsets.all(5.0),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1 / 1.05),
              itemBuilder: (context, index) {
                final Product product = products[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 140,
                      child: SingleProduct(image: product.images[0]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => deleteProduct(product),
                            child: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddProduct,
        tooltip: 'Thêm sản phẩm',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
