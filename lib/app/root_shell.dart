import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootShell extends StatefulWidget {
  final Widget child;
  const RootShell({super.key, required this.child});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 0;

  final List<String> _routes = ['/home', '/rooms', '/bookings', '/profile', '/settings'];
  final List<IconData> _icons = [
    Icons.home,
    Icons.hotel,
    Icons.list_alt,
    Icons.person,
    Icons.settings,
  ];
  final List<String> _labels = [
    'Главная',
    'Номера',
    'Брони',
    'Профиль',
    'Настройки',
  ];

  int _getCurrentIndex(String location) {
    if (location.startsWith('/rooms')) return 1;
    if (location.startsWith('/bookings')) return 2;
    if (location.startsWith('/profile')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0; // '/home'
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    _currentIndex = _getCurrentIndex(location);

    return Scaffold(
      body: widget.child,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.hotel,
                    size: 48,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Бронирование номеров',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ],
              ),
            ),
            ...List.generate(_routes.length, (index) {
              final isSelected = _currentIndex == index;
              return ListTile(
                leading: Icon(
                  _icons[index],
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                title: Text(_labels[index]),
                selected: isSelected,
                selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
                onTap: () {
                  Navigator.pop(context); // Закрыть drawer
                  context.go(_routes[index]);
                },
              );
            }),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(_labels[_currentIndex]),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
    );
  }
}

