import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static const String _themeKey = 'app_dark_mode';
  
  SharedPreferences? _prefs;
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  /// Инициализация сервиса с загрузкой сохранённой темы
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs?.getBool(_themeKey) ?? false;
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveTheme();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    _saveTheme();
  }

  Future<void> _saveTheme() async {
    await _prefs?.setBool(_themeKey, _isDarkMode);
  }
}

class AppSettingsService {
  static const String _languageKey = 'app_language';
  static const String _notificationsKey = 'app_notifications';
  static const String _autoSaveKey = 'app_auto_save';

  SharedPreferences? _prefs;
  String _language = 'ru';
  bool _notificationsEnabled = true;
  bool _autoSaveEnabled = true;

  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get autoSaveEnabled => _autoSaveEnabled;

  /// Инициализация сервиса с загрузкой сохранённых настроек
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _language = _prefs?.getString(_languageKey) ?? 'ru';
    _notificationsEnabled = _prefs?.getBool(_notificationsKey) ?? true;
    _autoSaveEnabled = _prefs?.getBool(_autoSaveKey) ?? true;
  }

  void setLanguage(String language) {
    _language = language;
    _prefs?.setString(_languageKey, language);
  }

  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
    _prefs?.setBool(_notificationsKey, enabled);
  }

  void setAutoSaveEnabled(bool enabled) {
    _autoSaveEnabled = enabled;
    _prefs?.setBool(_autoSaveKey, enabled);
  }
}
