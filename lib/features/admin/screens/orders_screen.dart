import 'package:amazon_clone/commons/widgets/loader.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/admin/services/admin_service.dart';
import 'package:amazon_clone/features/order_detail/screens/order_detail_screen.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final AdminService _adminService = AdminService();
  List<Order>? orders;

  void fetchAllOrders() async {
    orders = await _adminService.fetchAllOrders(context: context);
    setState(() {});
  }

  void openOrderDetailScreen(int index) {
    Navigator.pushNamed(context, OrderDetailScreen.routeName, arguments: orders![index]);
  }

  @override
  void initState() {
    super.initState();
    fetchAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : GridView.builder(
            padding: const EdgeInsets.all(5.0),
            itemCount: orders!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1 / 1.05, mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              final order = orders![index];

              return GestureDetector(
                onTap: () => openOrderDetailScreen(index),
                child: SizedBox(
                  height: 140,
                  child: SingleProduct(
                    image: order.products[0].images[0],
                  ),
                ),
              );
            },
          );
  }
}
