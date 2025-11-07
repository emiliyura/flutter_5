import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_5/core/service_locator.dart';
import 'package:flutter_5/shared/services/app_config_service.dart';
import 'package:flutter_5/shared/state/user_state.dart';
import 'package:flutter_5/shared/state/booking_state.dart';
import 'package:flutter_5/features/booking/models/booking.dart';

/// Страница профиля пользователя - демонстрирует использование InheritedWidget
/// с подпиской на изменения через addListener/removeListener
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserState? _userState;
  final TextEditingController _nameController = TextEditingController();
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Получаем UserState через UserStateProvider.of(context)
    if (!_isInitialized) {
      _userState = UserStateProvider.of(context);
      _userState?.addListener(_onUserStateChanged); // Подписка на изменения
      _nameController.text = _userState?.name ?? '';
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _userState?.removeListener(_onUserStateChanged); // Отписка от изменений
    _nameController.dispose();
    super.dispose();
  }

  /// Обработчик изменения UserState
  void _onUserStateChanged() {
    if (mounted) {
      setState(() {
        _nameController.text = _userState?.name ?? '';
      });
    }
  }

  /// Сохранение имени пользователя
  void _saveName() {
    if (_nameController.text.trim().isNotEmpty && _userState != null) {
      _userState!.updateUser(name: _nameController.text.trim()); // Обновление состояния
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Имя сохранено успешно!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _navigateToSettings() {
    context.push('/settings');
  }

  void _navigateToRooms() {
    context.push('/rooms');
  }

  void _navigateToBookings() {
    context.push('/bookings');
  }

  @override
  Widget build(BuildContext context) {
    // Получаем состояние через InheritedWidget
    final state = UserStateProvider.of(context);
    final user = state;

    // Получаем конфигурацию через GetIt
    final appConfig = getIt<AppConfigService>();

    // Получаем состояние бронирований через InheritedWidget для статистики
    final bookingState = BookingStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Заголовок профиля с информацией о пользователе
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Поле ввода имени с кнопкой сохранения (как в методичке)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Имя',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Введите имя',
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _saveName,
                        icon: const Icon(Icons.save),
                        label: const Text('Сохранить'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Информация из GetIt
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
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
            ),
            const SizedBox(height: 16),

            // Статистика (реактивно обновляется через InheritedWidget)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListenableBuilder(
                listenable: bookingState,
                builder: (context, child) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(context, 'Бронирований', '${bookingState.totalBookings}'),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[300],
                          ),
                          _buildStatItem(context, 'Статус', 'Активен'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Информация о пользователе
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Информация',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoTile(
                    context,
                    Icons.phone,
                    'Телефон',
                    user.phone,
                  ),
                  _buildInfoTile(
                    context,
                    Icons.calendar_today,
                    'Дата регистрации',
                    '${user.registrationDate.day}.${user.registrationDate.month}.${user.registrationDate.year}',
                  ),
                  _buildInfoTile(
                    context,
                    Icons.location_on,
                    'Город',
                    user.city,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Настройки'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: _navigateToSettings,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.hotel),
                          title: const Text('Номера'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: _navigateToRooms,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.list_alt),
                          title: const Text('Мои бронирования'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: _navigateToBookings,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Демонстрация работы InheritedWidget и GetIt
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок раздела демонстрации
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.science, color: Colors.purple, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Демонстрация работы',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // GetIt Demo
                  _buildSectionHeader('GetIt DI Container', Icons.storage, Colors.blue),
                  const SizedBox(height: 12),
                  const GetItDemoWidget(),
                  const SizedBox(height: 24),

                  // InheritedWidget Demo
                  _buildSectionHeader('InheritedWidget', Icons.account_tree, Colors.green),
                  const SizedBox(height: 12),
                  InheritedWidgetDemoWidget(userState: state),
                  const SizedBox(height: 24),

                  // Combined Usage Demo
                  _buildSectionHeader('Комбинированное использование', Icons.link, Colors.orange),
                  const SizedBox(height: 12),
                  CombinedUsageDemoWidget(userState: state, appConfig: appConfig, bookingState: bookingState),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}

/// Виджет демонстрации GetIt
class GetItDemoWidget extends StatefulWidget {
  const GetItDemoWidget({super.key});

  @override
  State<GetItDemoWidget> createState() => _GetItDemoWidgetState();
}

class _GetItDemoWidgetState extends State<GetItDemoWidget> {
  int _updateCounter = 0;

  @override
  Widget build(BuildContext context) {
    // Получаем сервисы через GetIt
    final appConfig = getIt<AppConfigService>();
    final themeService = getIt<ThemeService>();
    final settingsService = getIt<AppSettingsService>();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Имя приложения', appConfig.appName, Icons.apps),
            const Divider(),
            _buildInfoRow('Версия', appConfig.appVersion, Icons.info),
            const Divider(),
            _buildInfoRow('API URL', appConfig.apiBaseUrl, Icons.link),
            const Divider(),
            _buildInfoRow('Режим отладки', appConfig.isDebugMode ? 'Включен' : 'Выключен', Icons.bug_report),
            const Divider(),
            _buildInfoRow('Темная тема', themeService.isDarkMode ? 'Да' : 'Нет', Icons.dark_mode),
            const Divider(),
            _buildInfoRow('Язык', settingsService.language, Icons.language),
            const Divider(),
            _buildInfoRow('Уведомления', settingsService.notificationsEnabled ? 'Включены' : 'Выключены', Icons.notifications),
            const SizedBox(height: 16),
            const Text(
              'Тестирование изменений:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    themeService.toggleTheme();
                    setState(() {
                      _updateCounter++;
                    });
                    _showSnackBar(context, 'Тема переключена через GetIt!');
                  },
                  icon: const Icon(Icons.palette),
                  label: const Text('Переключить тему'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    settingsService.setLanguage(settingsService.language == 'ru' ? 'en' : 'ru');
                    setState(() {
                      _updateCounter++;
                    });
                    _showSnackBar(context, 'Язык изменен через GetIt!');
                  },
                  icon: const Icon(Icons.language),
                  label: const Text('Изменить язык'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    settingsService.setNotificationsEnabled(!settingsService.notificationsEnabled);
                    setState(() {
                      _updateCounter++;
                    });
                    _showSnackBar(context, 'Уведомления изменены через GetIt!');
                  },
                  icon: const Icon(Icons.notifications),
                  label: const Text('Уведомления'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.update, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    'Обновлений через GetIt: $_updateCounter',
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

/// Виджет демонстрации InheritedWidget
class InheritedWidgetDemoWidget extends StatefulWidget {
  final UserState userState;

  const InheritedWidgetDemoWidget({
    super.key,
    required this.userState,
  });

  @override
  State<InheritedWidgetDemoWidget> createState() => _InheritedWidgetDemoWidgetState();
}

class _InheritedWidgetDemoWidgetState extends State<InheritedWidgetDemoWidget> {
  late UserState _userState;
  late BookingState _bookingState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userState = widget.userState;
    _bookingState = BookingStateProvider.of(context);
    _userState.addListener(_onUserStateChanged);
    _bookingState.addListener(_onBookingStateChanged);
  }

  @override
  void dispose() {
    _userState.removeListener(_onUserStateChanged);
    _bookingState.removeListener(_onBookingStateChanged);
    super.dispose();
  }

  void _onUserStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onBookingStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Данные пользователя (InheritedWidget):',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                _buildUserInfoRow('Имя', _userState.name, Icons.person),
                _buildUserInfoRow('Email', _userState.email, Icons.email),
                _buildUserInfoRow('Телефон', _userState.phone, Icons.phone),
                _buildUserInfoRow('Город', _userState.city, Icons.location_city),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Бронирования (InheritedWidget):',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                _buildInfoRow('Всего бронирований', '${_bookingState.totalBookings}', Icons.bookmark),
                if (_bookingState.bookings.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text('Список бронирований:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  ..._bookingState.bookings.map((booking) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '• Бронирование ${booking.id.substring(0, 8)}...',
                      style: const TextStyle(fontSize: 12),
                    ),
                  )),
                ],
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Тестирование изменений:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _userState.updateCity(_userState.city == 'Москва' ? 'Санкт-Петербург' : 'Москва');
                    _showSnackBar(context, 'Город изменен через InheritedWidget!');
                  },
                  icon: const Icon(Icons.location_city),
                  label: const Text('Изменить город'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final booking = Booking(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      roomId: 'r1',
                      guestName: _userState.name,
                      checkIn: DateTime.now(),
                      checkOut: DateTime.now().add(const Duration(days: 2)),
                    );
                    _bookingState.addBooking(booking);
                    _showSnackBar(context, 'Бронирование добавлено через InheritedWidget!');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Добавить бронирование'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                if (_bookingState.bookings.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () {
                      _bookingState.clearAllBookings();
                      _showSnackBar(context, 'Бронирования очищены через InheritedWidget!');
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Очистить'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }
}

/// Виджет демонстрации комбинированного использования
class CombinedUsageDemoWidget extends StatelessWidget {
  final UserState userState;
  final AppConfigService appConfig;
  final BookingState bookingState;

  const CombinedUsageDemoWidget({
    super.key,
    required this.userState,
    required this.appConfig,
    required this.bookingState,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.link, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Комбинированное использование',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Этот виджет использует данные из обоих источников одновременно:',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCombinedRow(
                  'Приложение',
                  appConfig.fullAppName,
                  Icons.apps,
                  'GetIt',
                ),
                _buildCombinedRow(
                  'Пользователь',
                  userState.name,
                  Icons.person,
                  'InheritedWidget',
                ),
                _buildCombinedRow(
                  'Бронирований',
                  '${bookingState.totalBookings}',
                  Icons.bookmark,
                  'InheritedWidget',
                ),
                _buildCombinedRow(
                  'Email',
                  userState.email,
                  Icons.email,
                  'InheritedWidget',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✅ Проверка работоспособности:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• GetIt: Данные доступны глобально\n'
                    '• InheritedWidget: Данные реактивно обновляются\n'
                    '• Оба метода работают независимо и вместе',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombinedRow(String label, String value, IconData icon, String source) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: source == 'GetIt' ? Colors.blue.shade100 : Colors.green.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              source,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: source == 'GetIt' ? Colors.blue.shade700 : Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
