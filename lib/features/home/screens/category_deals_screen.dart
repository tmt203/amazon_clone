import 'package:amazon_clone/features/product_detail/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:amazon_clone/commons/widgets/loader.dart';
import 'package:amazon_clone/features/home/services/home_service.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/constants/global_variables.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String category;
  const CategoryDealsScreen({super.key, required this.category});

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  final HomeService homeService = HomeService();
  List<Product>? products;

  void fetchProductsByCategory() async {
    products = await homeService.fetchProductsByCategory(context: context, category: widget.category);
    setState(() {});
  }

  void openProductDetailScreen(Product product) {
    Navigator.pushNamed(context, ProductDetailScreen.routeName, arguments: product);
  }

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Text(
            widget.category,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: products == null
          ? const Loader()
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Tìm sản phẩm theo '${widget.category}'",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  shrinkWrap: true,
                  itemCount: products!.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1 / 1.25,
                  ),
                  itemBuilder: (_, index) {
                    final Product product = products![index];
                    return GestureDetector(
                      onTap: () => openProductDetailScreen(product),
                      child: Card(
                        surfaceTintColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.network(product.images[0], height: 130, fit: BoxFit.cover),
                              const SizedBox(height: 5),
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
