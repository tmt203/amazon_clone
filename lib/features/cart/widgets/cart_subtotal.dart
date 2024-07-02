import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int subTotal = user!.cart.isEmpty
        ? 0
        : user.cart.fold<int>(
            0,
            (subtotal, cartItem) => subtotal + (cartItem['product']['price'] as int) * (cartItem['quantity'] as int),
          ); // num subTotal = 0;

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            'Tổng tiền: ',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            '${currencyFormat.format(subTotal)}VND',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
