import 'package:flutter/material.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '📦 Orders View',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}
