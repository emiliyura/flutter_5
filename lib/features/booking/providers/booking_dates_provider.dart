import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_dates_provider.g.dart';

@JsonSerializable()
class BookingDatesModel {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int nightsCount;
  final String? validationError;

  BookingDatesModel({
    this.checkIn,
    this.checkOut,
    this.nightsCount = 0,
    this.validationError,
  });

  factory BookingDatesModel.fromJson(Map<String, dynamic> json) =>
      _$BookingDatesModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingDatesModelToJson(this);
}

class BookingDatesState {
  final DateTime? checkIn;
  final DateTime? checkOut;

  BookingDatesState({
    this.checkIn,
    this.checkOut,
  });

  BookingDatesState copyWith({
    DateTime? checkIn,
    DateTime? checkOut,
  }) {
    return BookingDatesState(
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
    );
  }

  int get nightsCount {
    if (checkIn == null || checkOut == null) return 0;
    if (!checkOut!.isAfter(checkIn!)) return 0;
    return checkOut!.difference(checkIn!).inDays;
  }

  String? get validationError {
    if (checkIn == null || checkOut == null) {
      return 'Выберите даты заезда и выезда';
    }
    if (!checkOut!.isAfter(checkIn!)) {
      return 'Дата выезда должна быть позже даты заезда';
    }
    return null;
  }

  double getTotalPrice(double roomPrice) {
    return roomPrice * nightsCount;
  }
}

@riverpod
class BookingDatesProvider extends _$BookingDatesProvider {
  @override
  BookingDatesState build() => BookingDatesState();

  DateTime? getCheckIn() => state.checkIn;
  
  DateTime? getCheckOut() => state.checkOut;

  void setCheckIn(DateTime? value) {
    state = state.copyWith(checkIn: value);
  }

  void setCheckOut(DateTime? value) {
    state = state.copyWith(checkOut: value);
  }

  int getNightsCount() => state.nightsCount;

  String? getDatesValidation() => state.validationError;

  double getTotalPrice(double roomPrice) => state.getTotalPrice(roomPrice);
}
