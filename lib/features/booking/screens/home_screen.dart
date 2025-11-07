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
      appBar: AppBar(
        title: const Text('Главная'),
        automaticallyImplyLeading: false, // Убираем кнопку назад на главном экране
      ),
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
              () => context.push('/rooms'),
            ),
            const SizedBox(height: 12),
            _buildQuickActionCard(
              context,
              'Мои бронирования',
              'Управляйте своими бронированиями',
              Icons.list_alt,
              Colors.orange,
              () => context.push('/bookings'),
            ),
            const SizedBox(height: 12),
            _buildQuickActionCard(
              context,
              'Профиль',
              'Информация о вашем аккаунте',
              Icons.person,
              Colors.purple,
              () => context.push('/profile'),
            ),
            const SizedBox(height: 12),
            _buildQuickActionCard(
              context,
              'Настройки',
              'Настройки приложения',
              Icons.settings,
              Colors.grey,
              () => context.push('/settings'),
            ),
            const SizedBox(height: 12),
            _buildQuickActionCard(
              context,
              'Справка',
              'Информация о приложении и помощь',
              Icons.help_outline,
              Colors.teal,
              () => _showHelpDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Colors.teal),
            SizedBox(width: 8),
            Text('Справка'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Приложение для бронирования номеров',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 12),
              Text('Основные возможности:'),
              SizedBox(height: 8),
              Text('• Просмотр доступных номеров'),
              Text('• Бронирование номеров'),
              Text('• Управление бронированиями'),
              Text('• Просмотр профиля'),
              Text('• Настройки приложения'),
              SizedBox(height: 12),
              Text(
                'Навигация:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Используйте кнопку "Назад" для возврата на предыдущий экран.'),
              Text('Для быстрого доступа используйте карточки на главном экране.'),
              SizedBox(height: 12),
              Text(
                'Версия: 1.0.0',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Закрыть'),
          ),
        ],
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