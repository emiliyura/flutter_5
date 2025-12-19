// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rooms_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomsLoadingModel _$RoomsLoadingModelFromJson(Map<String, dynamic> json) =>
    RoomsLoadingModel(
      state: $enumDecode(_$RoomsLoadingStateEnumMap, json['state']),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$RoomsLoadingModelToJson(RoomsLoadingModel instance) =>
    <String, dynamic>{
      'state': _$RoomsLoadingStateEnumMap[instance.state]!,
      'errorMessage': instance.errorMessage,
    };

const _$RoomsLoadingStateEnumMap = {
  RoomsLoadingState.initial: 'initial',
  RoomsLoadingState.loading: 'loading',
  RoomsLoadingState.loaded: 'loaded',
  RoomsLoadingState.error: 'error',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$roomsProviderHash() => r'b5946aa2a9dc51f6cc45ddfc2c99da259bde0074';

/// See also [RoomsProvider].
@ProviderFor(RoomsProvider)
final roomsProviderProvider =
    AutoDisposeNotifierProvider<RoomsProvider, RoomsState>.internal(
      RoomsProvider.new,
      name: r'roomsProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$roomsProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RoomsProvider = AutoDisposeNotifier<RoomsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
