import 'package:flutter/material.dart';
import 'dashboard_view.dart';
import 'products_view.dart';
import 'orders_view.dart';
import 'payments_view.dart';
import '../dropflow/dropflow_view.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/app_header.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  int _selectedIndex = 0;

  final List<Widget> _views = [
    const DashboardView(),
    const ProductsView(),
    const OrdersView(),
    const DropFlowView(),
    const PaymentsView(),
    const Placeholder(), // Supabase
  ];

  final List<String> _titles = [
    'Dashboard',
    'Shopify',
    'Spocket',
    'DropFlow',
    'Payments',
    'Supabase',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      drawer: isMobile ? _buildMobileDrawer(context) : null,
      body: Row(
        children: [
          if (!isMobile)
            Sidebar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) =>
                  setState(() => _selectedIndex = index),
            ),

          if (!isMobile)
            Container(
              width: 1,
              height: double.infinity,
              color: const Color(0xFF27272A),
            ),

          Expanded(
            child: Column(
              children: [
                AppHeader(title: _titles[_selectedIndex]),
                Container(height: 1, color: const Color(0xFF27272A)),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: _views[_selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(
              'Splitmind AI',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
          _buildDrawerItem(Icons.shopping_cart, 'Shopify', 1),
          _buildDrawerItem(Icons.extension, 'Spocket', 2),
          _buildDrawerItem(Icons.grid_view, 'DropFlow', 3),
          _buildDrawerItem(Icons.attach_money, 'Payments', 4),
          _buildDrawerItem(Icons.storage, 'Supabase', 5),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(label),
      selected: _selectedIndex == index,
      selectedTileColor: Colors.white10,
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
    );
  }
}
