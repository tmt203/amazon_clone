import 'package:amazon_clone/commons/widgets/loader.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/services/account_service.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/order_detail/screens/order_detail_screen.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final AccountService _accountService = AccountService();
  List<Order>? orders;

  void fetchMyOrders() async {
    orders = await _accountService.fetchMyOrders(context: context);
    setState(() {});
  }

  void openOrderDetailScreen(int index) {
    Navigator.pushNamed(context, OrderDetailScreen.routeName, arguments: orders![index]);
  }

  @override
  void initState() {
    super.initState();
    fetchMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Đơn hàng của bạn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Xem tất cả',
                      style: TextStyle(
                        color: GlobalVariables.selectedNavBarColor,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Transform.translate(
                  offset: const Offset(-5, 0),
                  child: SizedBox(
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: orders!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () => openOrderDetailScreen(index), child: SingleProduct(image: orders![index].products[0].images[0]));
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
