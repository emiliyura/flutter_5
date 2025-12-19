import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/service_locator.dart';
import '../../../shared/services/app_config_service.dart';

part 'settings_provider.g.dart';

@JsonSerializable()
class AppSettingsModel {
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String language;
  final bool autoSaveEnabled;

  AppSettingsModel({
    required this.notificationsEnabled,
    required this.darkModeEnabled,
    required this.language,
    required this.autoSaveEnabled,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);
  Map<String, dynamic> toJson() => _$AppSettingsModelToJson(this);
}

class SettingsState {
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String language;

  SettingsState({
    required this.notificationsEnabled,
    required this.darkModeEnabled,
    required this.language,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? language,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      language: language ?? this.language,
    );
  }
}

@riverpod
class SettingsProvider extends _$SettingsProvider {
  @override
  SettingsState build() {
    final settingsService = getIt<AppSettingsService>();
    final themeService = getIt<ThemeService>();
    return SettingsState(
      notificationsEnabled: settingsService.notificationsEnabled,
      darkModeEnabled: themeService.isDarkMode,
      language: settingsService.language == 'ru' ? 'Русский' : 'English',
    );
  }

  bool getNotificationsEnabled() => state.notificationsEnabled;

  void setNotificationsEnabled(bool value) {
    final settingsService = getIt<AppSettingsService>();
    settingsService.setNotificationsEnabled(value);
    state = state.copyWith(notificationsEnabled: value);
  }

  bool getDarkModeEnabled() => state.darkModeEnabled;

  void setDarkModeEnabled(bool value, {WidgetRef? ref}) {
    // Сохраняем в ThemeService
    final themeService = getIt<ThemeService>();
    themeService.setDarkMode(value);
    state = state.copyWith(darkModeEnabled: value);
  }

  String getLanguage() => state.language;

  void setLanguage(String value) {
    final settingsService = getIt<AppSettingsService>();
    final langCode = value == 'Русский' ? 'ru' : 'en';
    settingsService.setLanguage(langCode);
    state = state.copyWith(language: value);
  }
}
