// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettingsModel _$AppSettingsModelFromJson(Map<String, dynamic> json) =>
    AppSettingsModel(
      notificationsEnabled: json['notificationsEnabled'] as bool,
      darkModeEnabled: json['darkModeEnabled'] as bool,
      language: json['language'] as String,
      autoSaveEnabled: json['autoSaveEnabled'] as bool,
    );

Map<String, dynamic> _$AppSettingsModelToJson(AppSettingsModel instance) =>
    <String, dynamic>{
      'notificationsEnabled': instance.notificationsEnabled,
      'darkModeEnabled': instance.darkModeEnabled,
      'language': instance.language,
      'autoSaveEnabled': instance.autoSaveEnabled,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsProviderHash() => r'e72fc983276e58056e0111d8836fdc0227b063a3';

/// See also [SettingsProvider].
@ProviderFor(SettingsProvider)
final settingsProviderProvider =
    AutoDisposeNotifierProvider<SettingsProvider, SettingsState>.internal(
      SettingsProvider.new,
      name: r'settingsProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$settingsProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SettingsProvider = AutoDisposeNotifier<SettingsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
