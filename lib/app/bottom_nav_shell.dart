import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final StatefulNavigationShell? navigationShell;

  const BottomNavShell({
    super.key,
    required this.child,
    required this.currentIndex,
    this.navigationShell,
  });

  static const List<BottomNavItem> navItems = [
    BottomNavItem(
      icon: Icons.home,
      label: 'Главная',
      route: '/',
    ),
    BottomNavItem(
      icon: Icons.hotel,
      label: 'Номера',
      route: '/rooms',
    ),
    BottomNavItem(
      icon: Icons.list_alt,
      label: 'Брони',
      route: '/bookings',
    ),
    BottomNavItem(
      icon: Icons.person,
      label: 'Профиль',
      route: '/profile',
    ),
  ];

  void _onItemTapped(BuildContext context, int index) {
    if (navigationShell != null) {
      // Используем StatefulNavigationShell для навигации
      navigationShell!.goBranch(
        index,
        // Если уже на этой ветке, не пересоздаем состояние
        initialLocation: index == navigationShell!.currentIndex,
      );
    } else {
      // Fallback на обычную навигацию через GoRouter
      final route = navItems[index].route;
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        type: BottomNavigationBarType.fixed,
        items: navItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final String label;
  final String route;

  const BottomNavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

