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

  getIt.registerSingleton<ThemeService>(
    ThemeService(),
  );

  getIt.registerSingleton<AppSettingsService>(
    AppSettingsService(),
  );

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

