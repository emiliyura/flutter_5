import 'package:get_it/get_it.dart';
import '../shared/services/app_config_service.dart';
import '../shared/state/booking_state.dart';
import '../shared/state/user_state.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<AppConfigService>(
    AppConfigService(
      appName: 'Booking App',
      appVersion: '1.0.0',
      apiBaseUrl: 'https://api.booking.example.com',
      isDebugMode: true,
    ),
  );

  // Инициализируем ThemeService с загрузкой сохранённой темы
  final themeService = ThemeService();
  await themeService.init();
  getIt.registerSingleton<ThemeService>(themeService);

  // Инициализируем AppSettingsService с загрузкой сохранённых настроек
  final settingsService = AppSettingsService();
  await settingsService.init();
  getIt.registerSingleton<AppSettingsService>(settingsService);

  getIt.registerSingleton<BookingState>(
    BookingState(),
  );

  getIt.registerSingleton<UserState>(
    UserState(),
  );
}

Future<void> resetServiceLocator() async {
  await getIt.reset();
}
