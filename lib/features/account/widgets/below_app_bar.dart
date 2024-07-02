import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BelowAppBar extends StatelessWidget {
  const BelowAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
      decoration: const BoxDecoration(gradient: GlobalVariables.appBarGradient),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              text: 'Xin chào, ',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: user!.name,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
