import 'package:json_annotation/json_annotation.dart';

part 'app_config_service.g.dart';

@JsonSerializable()
class AppConfigService {
  final String appName;
  final String appVersion;
  final String apiBaseUrl;
  final bool isDebugMode;

  AppConfigService({
    required this.appName,
    required this.appVersion,
    required this.apiBaseUrl,
    required this.isDebugMode,
  });

  String get fullAppName => '$appName v$appVersion';
  
  String get appInfo => 'Приложение для бронирования номеров. Версия: $appVersion';

  void updateApiUrl(String newUrl) {
  }

  factory AppConfigService.fromJson(Map<String, dynamic> json) =>
      _$AppConfigServiceFromJson(json);
  Map<String, dynamic> toJson() => _$AppConfigServiceToJson(this);
}

class ThemeService {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
  }
}

class AppSettingsService {
  String _language = 'ru';
  bool _notificationsEnabled = true;
  bool _autoSaveEnabled = true;

  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get autoSaveEnabled => _autoSaveEnabled;

  void setLanguage(String language) {
    _language = language;
  }

  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
  }

  void setAutoSaveEnabled(bool enabled) {
    _autoSaveEnabled = enabled;
  }
}

