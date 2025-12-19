import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/di/app_module.dart' show getIt;
import '../../domain/entities/booking.dart';
import '../../domain/entities/room.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/get_bookings_usecase.dart';

part 'bookings_provider.g.dart';

/// Состояние процесса создания бронирования
enum BookingProcessState {
  idle,
  loading,
  success,
  error,
}

/// Состояние для бронирований в UI
class BookingsState {
  final List<Booking> bookings;
  final bool isLoading;
  final String? error;
  final BookingProcessState processState;
  final Booking? lastCreatedBooking;
  final String? processError;

  BookingsState({
    this.bookings = const [],
    this.isLoading = false,
    this.error,
    this.processState = BookingProcessState.idle,
    this.lastCreatedBooking,
    this.processError,
  });

  BookingsState copyWith({
    List<Booking>? bookings,
    bool? isLoading,
    String? error,
    BookingProcessState? processState,
    Booking? lastCreatedBooking,
    String? processError,
  }) {
    return BookingsState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      processState: processState ?? this.processState,
      lastCreatedBooking: lastCreatedBooking ?? this.lastCreatedBooking,
      processError: processError ?? this.processError,
    );
  }
}

/// Провайдер для управления состоянием бронирований
@riverpod
class BookingsNotifier extends _$BookingsNotifier {
  @override
  BookingsState build() {
    _loadBookings();
    return BookingsState();
  }

  Future<void> _loadBookings() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final useCase = getIt<GetBookingsUseCase>();
      final bookings = await useCase();
      
      state = state.copyWith(
        bookings: bookings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createBooking({
    required Room room,
    required String guestName,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    state = state.copyWith(
      processState: BookingProcessState.loading,
      processError: null,
    );

    try {
      final useCase = getIt<CreateBookingUseCase>();
      final booking = await useCase(
        room: room,
        guestName: guestName,
        checkIn: checkIn,
        checkOut: checkOut,
      );

      // Обновляем список бронирований
      final updatedBookings = [...state.bookings, booking];
      
      state = state.copyWith(
        bookings: updatedBookings,
        processState: BookingProcessState.success,
        lastCreatedBooking: booking,
      );

      // Перезагружаем список для синхронизации
      await _loadBookings();
    } catch (e) {
      state = state.copyWith(
        processState: BookingProcessState.error,
        processError: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await _loadBookings();
  }

  void resetProcess() {
    state = state.copyWith(
      processState: BookingProcessState.idle,
      processError: null,
      lastCreatedBooking: null,
    );
  }
}










