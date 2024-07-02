import 'package:amazon_clone/commons/widgets/stars.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/product_detail/screens/product_detail_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

class SearchProduct extends StatelessWidget {
  final Product product;
  const SearchProduct({
    super.key,
    required this.product,
  });

  void openProductDetailScreen(BuildContext context) {
    Navigator.pushNamed(context, ProductDetailScreen.routeName, arguments: product);
  }

  double calculateAvgRating() {
    if (product.ratings == null || product.ratings!.isEmpty) {
      return 0.0;
    }

    final totalRating = product.ratings!.map((rating) => rating.rating).reduce((a, b) => a + b);
    return totalRating / product.ratings!.length;
  }

  @override
  Widget build(BuildContext context) {
    final double avgRating = calculateAvgRating();

    return GestureDetector(
      onTap: () => openProductDetailScreen(context),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  product.images[0],
                  fit: BoxFit.contain,
                  width: 135,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          product.name,
                          style: const TextStyle(fontSize: 16),
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Stars(rating: avgRating),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          '${currencyFormat.format(product.price)} VND',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: const Text('Miễn phí giao hàng'),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: const Text(
                          'Còn hàng',
                          style: TextStyle(color: Colors.teal),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
