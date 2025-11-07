import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../booking/models/app_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final totalRooms = AppData.rooms.length;
    final totalBookings = AppData.bookings.length;
    final availableRooms = totalRooms - totalBookings;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Добро пожаловать!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Управляйте бронированиями номеров',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            // Статистика
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Всего номеров',
                    totalRooms.toString(),
                    Icons.hotel,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Доступно',
                    availableRooms.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Бронирований',
                    totalBookings.toString(),
                    Icons.bookmark,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Быстрый доступ',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildQuickActionCard(
              context,
              'Просмотреть номера',
              'Выберите номер для бронирования',
              Icons.hotel,
              Colors.blue,
              () => context.goNamed('rooms'),
            ),
            const SizedBox(height: 12),
            _buildQuickActionCard(
              context,
              'Мои бронирования',
              'Управляйте своими бронированиями',
              Icons.list_alt,
              Colors.orange,
              () => context.goNamed('bookings'),
            ),
            const SizedBox(height: 12),
            _buildQuickActionCard(
              context,
              'Профиль',
              'Информация о вашем аккаунте',
              Icons.person,
              Colors.purple,
              () => context.goNamed('profile'),
            ),
            const SizedBox(height: 12),
            _buildQuickActionCard(
              context,
              'Настройки',
              'Настройки приложения',
              Icons.settings,
              Colors.grey,
              () => context.goNamed('settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}