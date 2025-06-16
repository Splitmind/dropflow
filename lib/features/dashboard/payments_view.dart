import 'package:flutter/material.dart';

class PaymentsView extends StatelessWidget {
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '💸 Payments View',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}
