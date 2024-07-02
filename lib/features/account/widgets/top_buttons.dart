import 'package:flutter/material.dart';
import 'package:amazon_clone/features/account/services/account_service.dart';
import 'package:amazon_clone/features/account/widgets/account_button.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: 'Đơn hàng', onTap: () {}),
            AccountButton(text: 'Bán hàng', onTap: () {}),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(text: 'Thoát', onTap: () => AccountService().logOut(context)),
            AccountButton(text: 'Giỏ hàng', onTap: () {}),
          ],
        )
      ],
    );
  }
}
