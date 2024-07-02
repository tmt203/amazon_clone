import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/cart/services/cart_service.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({
    super.key,
    required this.index,
  });

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final CartService cartService = CartService();

  void increaseQuantity(Product product) {
    cartService.addToCart(context: context, product: product);
  }

  void decreaseQuantity(Product product) {
    cartService.removeFromCart(context: context, product: product);
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<UserProvider>().user!.cart[widget.index];
    final product = Product.fromMap(cart['product']);
    final quantity = cart['quantity'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product.images[0],
                fit: BoxFit.cover,
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
                      child: Text(
                        '${currencyFormat.format(product.price)} VND',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
        ),
        Container(
          width: 135,
          margin: const EdgeInsets.only(right: 10, left: 10, top: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => decreaseQuantity(product),
                      child: Container(
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.remove,
                          size: 18,
                        ),
                      ),
                    ),
                    Container(
                      width: 35,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          vertical: BorderSide(
                            color: Colors.black12,
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Text(quantity.toString()),
                    ),
                    InkWell(
                      onTap: () => increaseQuantity(product),
                      child: Container(
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
