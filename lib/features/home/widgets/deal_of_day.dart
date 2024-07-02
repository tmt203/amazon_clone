import 'package:amazon_clone/commons/widgets/loader.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/home/services/home_service.dart';
import 'package:amazon_clone/features/product_detail/screens/product_detail_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({super.key});

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  HomeService homeService = HomeService();
  Product? product;

  void fetchDealOfDay() async {
    product = await homeService.fetchDealOfDay(context: context);
    setState(() {});
  }

  void openProductDetailScreen() {
    Navigator.pushNamed(context, ProductDetailScreen.routeName, arguments: product);
  }

  @override
  void initState() {
    super.initState();
    fetchDealOfDay();
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? const Loader()
        : product!.name.isEmpty
            ? const SizedBox()
            : GestureDetector(
                onTap: openProductDetailScreen,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: const Text(
                        'Sản phẩm HOT gần đây',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Image.network(
                      product!.images[0],
                      height: 235,
                      fit: BoxFit.fitHeight,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 15, top: 5, right: 40),
                      child: Text(
                        product!.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        '${currencyFormat.format(product!.price)}VND',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: product!.images
                            .map((url) {
                              return Image.network(
                                url,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitWidth,
                              );
                            })
                            .skip(1)
                            .toList(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15).copyWith(left: 15),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Xem tất cả đơn',
                        style: TextStyle(color: Colors.cyan[800]),
                      ),
                    ),
                  ],
                ),
              );
  }
}
