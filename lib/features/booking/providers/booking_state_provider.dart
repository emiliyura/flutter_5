import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/booking.dart';
import '../models/room.dart';

part 'booking_state_provider.g.dart';

@JsonEnum()
enum BookingProcessState {
  idle,
  loading,
  success,
  error,
}

@JsonSerializable()
class BookingProcessModel {
  final BookingProcessState state;
  final String? errorMessage;
  final Booking? booking;

  BookingProcessModel({
    required this.state,
    this.errorMessage,
    this.booking,
  });

  BookingProcessModel copyWith({
    BookingProcessState? state,
    String? errorMessage,
    Booking? booking,
  }) {
    return BookingProcessModel(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      booking: booking ?? this.booking,
    );
  }

  factory BookingProcessModel.fromJson(Map<String, dynamic> json) =>
      _$BookingProcessModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingProcessModelToJson(this);
}

@JsonSerializable()
class BookingsStats {
  final int total;
  final int upcoming;
  final int past;

  BookingsStats({
    required this.total,
    required this.upcoming,
    required this.past,
  });

  factory BookingsStats.fromJson(Map<String, dynamic> json) =>
      _$BookingsStatsFromJson(json);
  Map<String, dynamic> toJson() => _$BookingsStatsToJson(this);
}

class BookingState {
  final BookingProcessModel process;
  final List<Booking> bookings;
  final AsyncValue<List<Booking>> cache;

  BookingState({
    required this.process,
    required this.bookings,
    required this.cache,
  });

  BookingState copyWith({
    BookingProcessModel? process,
    List<Booking>? bookings,
    AsyncValue<List<Booking>>? cache,
  }) {
    return BookingState(
      process: process ?? this.process,
      bookings: bookings ?? this.bookings,
      cache: cache ?? this.cache,
    );
  }

  BookingsStats getBookingsStats() {
    return BookingsStats(
      total: bookings.length,
      upcoming: bookings.where((b) => b.checkIn.isAfter(DateTime.now())).length,
      past: bookings.where((b) => b.checkOut.isBefore(DateTime.now())).length,
    );
  }

  AsyncValue<List<Booking>> getBookingsCache() => cache;
}

@riverpod
class BookingStateProvider extends _$BookingStateProvider {
  @override
  BookingState build() {
    _loadCache();
    return BookingState(
      process: BookingProcessModel(state: BookingProcessState.idle),
      bookings: [],
      cache: const AsyncValue.loading(),
    );
  }

  Future<void> _loadCache() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      state = state.copyWith(cache: AsyncValue.data(state.bookings));
    } catch (e, stack) {
      state = state.copyWith(cache: AsyncValue.error(e, stack));
    }
  }

  Future<void> createBooking({
    required Room room,
    required String guestName,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    state = state.copyWith(
      process: state.process.copyWith(state: BookingProcessState.loading),
    );

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (guestName.toLowerCase().contains('error')) {
        throw Exception('Ошибка при создании бронирования');
      }

      final booking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        roomId: room.id,
        guestName: guestName,
        checkIn: checkIn,
        checkOut: checkOut,
      );

      final updatedBookings = [...state.bookings, booking];
      state = state.copyWith(
        bookings: updatedBookings,
        process: state.process.copyWith(
          state: BookingProcessState.success,
          booking: booking,
        ),
        cache: AsyncValue.data(updatedBookings),
      );
    } catch (e) {
      state = state.copyWith(
        process: state.process.copyWith(
          state: BookingProcessState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void resetProcess() {
    state = state.copyWith(
      process: BookingProcessModel(state: BookingProcessState.idle),
    );
  }

  void addBooking(Booking booking) {
    final updatedBookings = [...state.bookings, booking];
    state = state.copyWith(
      bookings: updatedBookings,
      cache: AsyncValue.data(updatedBookings),
    );
  }

  void removeBooking(String bookingId) {
    final updatedBookings = state.bookings.where((b) => b.id != bookingId).toList();
    state = state.copyWith(
      bookings: updatedBookings,
      cache: AsyncValue.data(updatedBookings),
    );
  }

  void clearAllBookings() {
    state = state.copyWith(
      bookings: [],
      cache: AsyncValue.data([]),
    );
  }

  Booking? getBookingById(String id) {
    try {
      return state.bookings.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  BookingsStats getBookingsStats() => state.getBookingsStats();

  AsyncValue<List<Booking>> getBookingsCache() => state.getBookingsCache();

  Future<void> refreshBookingsCache() async {
    state = state.copyWith(cache: const AsyncValue.loading());
    await _loadCache();
  }
}
