import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final background = Theme.of(context).colorScheme.surface;

    if (isMobile) {
      return Drawer(backgroundColor: background, child: _buildSidebarContent());
    }

    return Container(
      color: background,
      width: isExpanded ? 160 : 72,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(child: _buildSidebarContent()),

          // Bottom soft divider & sidebar toggle icon
          Container(height: 1, color: const Color(0xFF27272A)),
          IconButton(
            icon: const Icon(Icons.view_sidebar_outlined),
            tooltip: isExpanded ? 'Collapse Sidebar' : 'Expand Sidebar',
            onPressed: () => setState(() => isExpanded = !isExpanded),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSidebarContent() {
    final background = Theme.of(context).colorScheme.surface;

    return NavigationRail(
      backgroundColor: background,
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: widget.onDestinationSelected,
      labelType: isExpanded
          ? NavigationRailLabelType.all
          : NavigationRailLabelType.none,
      useIndicator: true,
      indicatorColor: Colors.white24,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard),
          selectedIcon: Icon(Icons.dashboard, color: Colors.white),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.shopping_cart),
          selectedIcon: Icon(Icons.shopping_cart, color: Colors.white),
          label: Text('Shopify'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.extension),
          selectedIcon: Icon(Icons.extension, color: Colors.white),
          label: Text('Spocket'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.grid_view), // ✅ DropFlow tab
          selectedIcon: Icon(Icons.grid_view, color: Colors.white),
          label: Text('DropFlow'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.attach_money),
          selectedIcon: Icon(Icons.attach_money, color: Colors.white),
          label: Text('Payments'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.storage),
          selectedIcon: Icon(Icons.storage, color: Colors.white),
          label: Text('Supabase'),
        ),
      ],
    );
  }
}
