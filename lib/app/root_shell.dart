import 'package:flutter/material.dart';
import 'package:flutter_5/features/booking/screens/home_screen.dart';
import 'package:flutter_5/features/booking/screens/room_list_screen.dart';
import 'package:flutter_5/features/booking/screens/booking_list_screen.dart';
import 'package:flutter_5/features/booking/screens/profile_screen.dart';
import 'package:flutter_5/features/booking/screens/settings_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    RoomListScreen(),
    BookingListScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
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
            ...List.generate(_pages.length, (index) {
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
                  setState(() {
                    _currentIndex = index;
                  });
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

