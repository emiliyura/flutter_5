// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_dates_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingDatesModel _$BookingDatesModelFromJson(Map<String, dynamic> json) =>
    BookingDatesModel(
      checkIn: json['checkIn'] == null
          ? null
          : DateTime.parse(json['checkIn'] as String),
      checkOut: json['checkOut'] == null
          ? null
          : DateTime.parse(json['checkOut'] as String),
      nightsCount: (json['nightsCount'] as num?)?.toInt() ?? 0,
      validationError: json['validationError'] as String?,
    );

Map<String, dynamic> _$BookingDatesModelToJson(BookingDatesModel instance) =>
    <String, dynamic>{
      'checkIn': instance.checkIn?.toIso8601String(),
      'checkOut': instance.checkOut?.toIso8601String(),
      'nightsCount': instance.nightsCount,
      'validationError': instance.validationError,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingDatesProviderHash() =>
    r'689fa0f04e774dbc4eb8be0e4ec8093e5adddde0';

/// See also [BookingDatesProvider].
@ProviderFor(BookingDatesProvider)
final bookingDatesProviderProvider =
    AutoDisposeNotifierProvider<
      BookingDatesProvider,
      BookingDatesState
    >.internal(
      BookingDatesProvider.new,
      name: r'bookingDatesProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bookingDatesProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BookingDatesProvider = AutoDisposeNotifier<BookingDatesState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
