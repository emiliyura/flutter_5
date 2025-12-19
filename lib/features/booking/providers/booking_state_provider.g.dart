// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_state_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingProcessModel _$BookingProcessModelFromJson(Map<String, dynamic> json) =>
    BookingProcessModel(
      state: $enumDecode(_$BookingProcessStateEnumMap, json['state']),
      errorMessage: json['errorMessage'] as String?,
      booking: json['booking'] == null
          ? null
          : Booking.fromJson(json['booking'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookingProcessModelToJson(
  BookingProcessModel instance,
) => <String, dynamic>{
  'state': _$BookingProcessStateEnumMap[instance.state]!,
  'errorMessage': instance.errorMessage,
  'booking': instance.booking,
};

const _$BookingProcessStateEnumMap = {
  BookingProcessState.idle: 'idle',
  BookingProcessState.loading: 'loading',
  BookingProcessState.success: 'success',
  BookingProcessState.error: 'error',
};

BookingsStats _$BookingsStatsFromJson(Map<String, dynamic> json) =>
    BookingsStats(
      total: (json['total'] as num).toInt(),
      upcoming: (json['upcoming'] as num).toInt(),
      past: (json['past'] as num).toInt(),
    );

Map<String, dynamic> _$BookingsStatsToJson(BookingsStats instance) =>
    <String, dynamic>{
      'total': instance.total,
      'upcoming': instance.upcoming,
      'past': instance.past,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingStateProviderHash() =>
    r'edfe5e5e2c74e776ce93e099fe7928f2dce495c5';

/// See also [BookingStateProvider].
@ProviderFor(BookingStateProvider)
final bookingStateProviderProvider =
    AutoDisposeNotifierProvider<BookingStateProvider, BookingState>.internal(
      BookingStateProvider.new,
      name: r'bookingStateProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bookingStateProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BookingStateProvider = AutoDisposeNotifier<BookingState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
