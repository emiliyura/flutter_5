import 'package:flutter/material.dart';
import 'package:flutter_5/app/app_router.dart';
import 'package:flutter_5/core/service_locator.dart';
import 'package:flutter_5/shared/services/app_config_service.dart';
import 'package:flutter_5/shared/state/booking_state.dart';
import 'package:flutter_5/shared/state/user_state.dart';

/// Инициализация приложения с настройкой DI контейнера GetIt
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация GetIt DI контейнера
  await setupServiceLocator();
  
  runApp(const BookingApp());
}

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем конфигурацию через GetIt
    final appConfig = getIt<AppConfigService>();
    
    // Получаем состояния через GetIt и передаем их в InheritedWidget провайдеры
    final bookingState = getIt<BookingState>();
    final userState = getIt<UserState>();

    // Обёртываем приложение в InheritedWidget провайдеры для передачи параметров
    // через дерево виджетов (как показано в методичке - Рисунок 15)
    return BookingStateProvider(
      notifier: bookingState,
      child: UserStateProvider(
        userState: userState, // Предоставление экземпляра UserState
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: appConfig.fullAppName,
          theme: ThemeData(useMaterial3: true),
          routerConfig: appRouter,
        ),
      ),
    );
  }
}