import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/booking/screens/home_screen.dart';
import '../features/booking/screens/room_list_screen.dart';
import '../features/booking/screens/booking_list_screen.dart';
import '../features/booking/screens/profile_screen.dart';
import '../features/booking/screens/edit_profile_screen.dart';
import '../features/booking/screens/favorites_screen.dart';
import '../features/booking/screens/loyalty_screen.dart';
import '../features/booking/screens/room_detail_screen.dart';
import '../features/booking/screens/settings_screen.dart';
import '../features/booking/screens/booking_step1_screen.dart';
import '../features/booking/screens/booking_step2_screen.dart';
import '../features/booking/screens/booking_step3_screen.dart';
import '../features/booking/providers/rooms_provider.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/providers/auth_provider.dart';
import 'bottom_nav_shell.dart';

final authNotifierProvider = Provider<ValueNotifier<bool>>((ref) {
  final authState = ref.watch(authProviderProvider);
  final notifier = ValueNotifier<bool>(authState);
  
  // Обновляем notifier при изменении состояния аутентификации
  ref.listen<bool>(authProviderProvider, (previous, next) {
    notifier.value = next;
  });
  
  ref.onDispose(() {
    notifier.dispose();
  });
  
  return notifier;
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProviderProvider);
  final authNotifier = ref.watch(authNotifierProvider);
  
  return GoRouter(
    initialLocation: authState ? '/' : '/login',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      // Получаем текущее состояние аутентификации
      final isAuthenticated = authNotifier.value;
      final isLoginRoute = state.matchedLocation == '/login';
      final isRegisterRoute = state.matchedLocation == '/register';
      
      // Если не авторизован и пытается зайти на защищенный маршрут
      if (!isAuthenticated && !isLoginRoute && !isRegisterRoute) {
        return '/login';
      }
      
      // Если авторизован и пытается зайти на страницы входа/регистрации
      if (isAuthenticated && (isLoginRoute || isRegisterRoute)) {
        return '/';
      }
      
      return null;
    },
    routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    // Вложенные маршруты с нижней панелью навигации
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _buildShellWithNav(context, state, navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/rooms',
              builder: (context, state) => const RoomListScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/bookings',
              builder: (context, state) => const BookingListScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/loyalty',
      builder: (context, state) => const LoyaltyScreen(),
    ),
    GoRoute(
      path: '/room/:roomId',
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        final rooms = getRoomsData();
        final room = rooms.firstWhere(
          (r) => r.id == roomId,
          orElse: () => throw Exception('Room not found: $roomId'),
        );
        return RoomDetailScreen(room: room);
      },
    ),
    GoRoute(
      path: '/booking/step1/:roomId',
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        final rooms = getRoomsData();
        final room = rooms.firstWhere(
          (r) => r.id == roomId,
          orElse: () => throw Exception('Room not found: $roomId'),
        );
        return BookingStep1Screen(room: room);
      },
    ),
    GoRoute(
      path: '/booking/step2/:roomId',
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        final rooms = getRoomsData();
        final room = rooms.firstWhere(
          (r) => r.id == roomId,
          orElse: () => throw Exception('Room not found: $roomId'),
        );
        
        final checkInStr = state.uri.queryParameters['checkIn'];
        final checkOutStr = state.uri.queryParameters['checkOut'];
        final guestName = state.uri.queryParameters['guestName'];
        
        if (checkInStr == null || checkOutStr == null) {
          throw Exception('Missing required parameters: checkIn, checkOut');
        }
        
        final checkIn = DateTime.parse(checkInStr);
        final checkOut = DateTime.parse(checkOutStr);
        
        return BookingStep2Screen(
          room: room,
          initialCheckIn: checkIn,
          initialCheckOut: checkOut,
          initialGuestName: guestName,
        );
      },
    ),
    GoRoute(
      path: '/booking/step3/:roomId',
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        final rooms = getRoomsData();
        final room = rooms.firstWhere(
          (r) => r.id == roomId,
          orElse: () => throw Exception('Room not found: $roomId'),
        );
        
        final checkInStr = state.uri.queryParameters['checkIn'];
        final checkOutStr = state.uri.queryParameters['checkOut'];
        final guestName = state.uri.queryParameters['guestName'];
        
        if (checkInStr == null || checkOutStr == null || guestName == null) {
          throw Exception('Missing required parameters: checkIn, checkOut, guestName');
        }
        
        final checkIn = DateTime.parse(checkInStr);
        final checkOut = DateTime.parse(checkOutStr);
        
        return BookingStep3Screen(
          room: room,
          checkIn: checkIn,
          checkOut: checkOut,
          guestName: guestName,
        );
      },
    ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
});

// Для обратной совместимости
final appRouter = appRouterProvider;

Widget _buildShellWithNav(
  BuildContext context,
  GoRouterState state,
  StatefulNavigationShell navigationShell,
) {
  return BottomNavShell(
    currentIndex: navigationShell.currentIndex,
    navigationShell: navigationShell,
    child: navigationShell,
  );
}

