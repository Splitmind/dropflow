import 'package:flutter/material.dart';

class DropFlowView extends StatelessWidget {
  const DropFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'DropFlow',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(height: 1, color: const Color(0xFF27272A)),
        const Expanded(
          child: Center(
            child: Text(
              '🧠 DropFlow workspace coming soon...',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
