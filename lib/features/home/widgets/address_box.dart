import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class AddressBox extends StatelessWidget {
  const AddressBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 114, 226, 221),
            Color.fromARGB(255, 162, 236, 233),
          ],
        ),
      ),
      child: Marquee(
        text: 'Khuyến mãi 10% cho toàn bộ sản phẩm vào ngày 14/2',
        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        blankSpace: 50,
      ),
    );
  }
}
