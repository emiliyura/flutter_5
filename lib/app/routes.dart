import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_5/app/root_shell.dart';
import 'package:flutter_5/features/booking/screens/home_screen.dart';
import 'package:flutter_5/features/booking/screens/room_list_screen.dart';
import 'package:flutter_5/features/booking/screens/booking_list_screen.dart';
import 'package:flutter_5/features/booking/screens/profile_screen.dart';
import 'package:flutter_5/features/booking/screens/settings_screen.dart';
import 'package:flutter_5/features/booking/screens/booking_step1_screen.dart';
import 'package:flutter_5/features/booking/screens/booking_step2_screen.dart';
import 'package:flutter_5/features/booking/screens/booking_step3_screen.dart';
import 'package:flutter_5/features/booking/models/app_data.dart';
import 'package:flutter_5/features/booking/models/room.dart';
import 'package:flutter_5/features/booking/models/booking.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => RootShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/rooms',
          name: 'rooms',
          builder: (context, state) => const RoomListScreen(),
        ),
        GoRoute(
          path: '/bookings',
          name: 'bookings',
          builder: (context, state) => const BookingListScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/book/:roomId/step1',
      name: 'bookingStep1',
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        final room = AppData.rooms.firstWhere((r) => r.id == roomId);
        return BookingStep1Screen(
          room: room,
          onNext: (guestName, checkIn, checkOut) {
            context.pushNamed(
              'bookingStep2',
              pathParameters: {'roomId': roomId},
              extra: {
                'guestName': guestName,
                'checkIn': checkIn,
                'checkOut': checkOut,
              },
            );
          },
          onCancel: () => context.pop(),
        );
      },
    ),
    GoRoute(
      path: '/book/:roomId/step2',
      name: 'bookingStep2',
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        final room = AppData.rooms.firstWhere((r) => r.id == roomId);
        final extra = state.extra as Map<String, dynamic>?;
        final guestName = extra?['guestName'] as String? ?? '';
        final checkIn = extra?['checkIn'] as DateTime?;
        final checkOut = extra?['checkOut'] as DateTime?;
        
        return BookingStep2Screen(
          room: room,
          initialGuestName: guestName,
          initialCheckIn: checkIn,
          initialCheckOut: checkOut,
          onNext: (name, ci, co) {
            context.pushNamed(
              'bookingStep3',
              pathParameters: {'roomId': roomId},
              extra: {
                'guestName': name,
                'checkIn': ci,
                'checkOut': co,
              },
            );
          },
          onCancel: () => context.pop(),
        );
      },
    ),
    GoRoute(
      path: '/book/:roomId/step3',
      name: 'bookingStep3',
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        final room = AppData.rooms.firstWhere((r) => r.id == roomId);
        final extra = state.extra as Map<String, dynamic>?;
        final guestName = extra?['guestName'] as String? ?? '';
        final checkIn = extra?['checkIn'] as DateTime?;
        final checkOut = extra?['checkOut'] as DateTime?;
        
        // Если данные не переданы, перенаправляем на шаг 2
        if (guestName.isEmpty || checkIn == null || checkOut == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed('bookingStep2', pathParameters: {'roomId': roomId}, extra: extra);
          });
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        return BookingStep3Screen(
          room: room,
          guestName: guestName,
          checkIn: checkIn,
          checkOut: checkOut,
          onSave: (name, ci, co) {
            final booking = Booking(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              roomId: room.id,
              guestName: name,
              checkIn: ci,
              checkOut: co,
            );
            AppData.addBooking(booking);
            context.goNamed('bookings');
          },
          onCancel: () => context.pop(),
        );
      },
    ),
  ],
);