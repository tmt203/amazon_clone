import 'package:flutter/material.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Amazon Clone',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          const Center(child: Text("Hello world")),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AuthScreen.routeName);
            },
            child: const Text('Click'),
          ),
        ],
      ),
    );
  }
}
