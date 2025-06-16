import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppHeader({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Material(
      color: colorScheme.surfaceContainerHighest,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: preferredSize.height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (isMobile)
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white70),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  Text(
                    title,
                    style:
                        Theme.of(context).appBarTheme.titleTextStyle ??
                        const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.account_circle, color: Colors.white70),
                tooltip: 'Profile',
                onPressed: () {
                  showMenu(
                    context: context,
                    position: const RelativeRect.fromLTRB(1000, 60, 16, 0),
                    items: [
                      const PopupMenuItem(child: Text('Account Settings')),
                      const PopupMenuItem(child: Text('Logout')),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
