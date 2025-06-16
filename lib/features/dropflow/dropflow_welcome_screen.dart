import 'package:flutter/material.dart';
import '../dashboard/dashboard_layout.dart';

class DropFlowWelcomeScreen extends StatefulWidget {
  final String shopOwner; // 🧠 From Supabase.shop_domain or shop_owner
  final bool spocketDetected; // ✅ Vendor flag

  const DropFlowWelcomeScreen({
    super.key,
    required this.shopOwner,
    required this.spocketDetected,
  });

  @override
  State<DropFlowWelcomeScreen> createState() => _DropFlowWelcomeScreenState();
}

class _DropFlowWelcomeScreenState extends State<DropFlowWelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardLayout()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: surface,
      body: Center(
        child: FadeTransition(
          opacity: _controller,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome to DropFlow, ${widget.shopOwner} 👋',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text('Shopify Connected'),
                ),
                ListTile(
                  leading: Icon(
                    widget.spocketDetected
                        ? Icons.check_circle
                        : Icons.warning_amber_rounded,
                    color: widget.spocketDetected
                        ? Colors.green
                        : Colors.orange,
                  ),
                  title: Text(
                    widget.spocketDetected
                        ? 'Spocket Detected'
                        : 'Spocket Not Detected',
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Loading your dashboard...',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
