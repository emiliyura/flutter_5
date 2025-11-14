import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_5/core/service_locator.dart';
import 'package:flutter_5/shared/services/app_config_service.dart';
import '../providers/rooms_provider.dart';
import '../providers/booking_state_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appConfig = getIt<AppConfigService>();
    
    final roomsState = ref.watch(roomsProviderProvider);
    final roomsAsync = roomsState.rooms;
    final bookingState = ref.watch(bookingStateProviderProvider);
    final stats = bookingState.getBookingsStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        automaticallyImplyLeading: false,
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
            roomsAsync.when(
              data: (rooms) => Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Всего номеров',
                      rooms.length.toString(),
                      Icons.hotel,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Доступно',
                      (rooms.length - stats.total).toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Бронирований',
                      stats.total.toString(),
                      Icons.bookmark,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Ошибка загрузки: ${error.toString()}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Приложение: ${appConfig.fullAppName}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
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
    final appConfig = getIt<AppConfigService>();
    
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
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appConfig.appInfo,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                'Версия: ${appConfig.appVersion}',
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