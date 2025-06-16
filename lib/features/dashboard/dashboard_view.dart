import 'package:flutter/material.dart';
import '../../services/ecommerce_connector.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(
        context,
      ).colorScheme.surface, // ✅ Consistent dark theme background
      child: FutureBuilder<List<String>>(
        future: EcommerceConnector().fetchProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) =>
                ListTile(title: Text(products[index])),
          );
        },
      ),
    );
  }
}
