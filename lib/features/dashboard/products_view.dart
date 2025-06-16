import 'package:flutter/material.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '🛍️ Products View',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}
