import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const AccountButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: OutlinedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black12.withOpacity(0.03),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            side: BorderSide(
              width: 1.2,
              color: Colors.black12.withOpacity(0.03),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
