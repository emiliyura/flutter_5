import 'package:flutter/material.dart';
import 'package:flutter_5/app/app_router.dart';
import 'package:flutter_5/core/service_locator.dart';
import 'package:flutter_5/shared/services/app_config_service.dart';
import 'package:flutter_5/shared/state/booking_state.dart';
import 'package:flutter_5/shared/state/user_state.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const BookingApp());
}

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appConfig = getIt<AppConfigService>();
    final bookingState = getIt<BookingState>();
    final userState = getIt<UserState>();

    return BookingStateProvider(
      notifier: bookingState,
      child: UserStateProvider(
        userState: userState,
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