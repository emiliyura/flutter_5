class SettingsLocalizations {
  final String language;

  SettingsLocalizations({required this.language});

  bool get isRussian => language == 'ru' || language == 'Русский';

  String get settingsTitle => isRussian ? 'Настройки' : 'Settings';
  
  String get notificationsSection => isRussian ? 'Уведомления' : 'Notifications';
  String get notificationsTitle => isRussian ? 'Уведомления' : 'Notifications';
  String get notificationsSubtitle => isRussian 
      ? 'Получать уведомления о бронированиях' 
      : 'Receive booking notifications';
  String notificationsEnabled(bool enabled) => isRussian
      ? (enabled ? 'Уведомления включены' : 'Уведомления выключены')
      : (enabled ? 'Notifications enabled' : 'Notifications disabled');

  String get appearanceSection => isRussian ? 'Внешний вид' : 'Appearance';
  String get darkThemeTitle => isRussian ? 'Темная тема' : 'Dark Theme';
  String get darkThemeSubtitle => isRussian
      ? 'Использовать темную тему приложения'
      : 'Use dark theme';
  String darkThemeEnabled(bool enabled) => isRussian
      ? (enabled ? 'Темная тема включена' : 'Темная тема выключена')
      : (enabled ? 'Dark theme enabled' : 'Dark theme disabled');

  String get languageSection => isRussian ? 'Язык' : 'Language';
  String get languageTitle => isRussian ? 'Язык приложения' : 'App Language';
  String get selectLanguage => isRussian ? 'Выберите язык' : 'Select Language';
  String get russian => 'Русский';
  String get english => 'English';
  String languageChanged(String lang) => isRussian
      ? 'Язык изменен на $lang'
      : 'Language changed to $lang';

  String get aboutSection => isRussian ? 'О приложении' : 'About';
  String get appVersionTitle => isRussian ? 'Версия приложения' : 'App Version';
  String get termsOfUse => isRussian ? 'Условия использования' : 'Terms of Use';
  String get termsOfUseContent => isRussian
      ? 'Здесь будут условия использования приложения.'
      : 'Terms of use will be here.';
  String get privacyPolicy => isRussian ? 'Политика конфиденциальности' : 'Privacy Policy';
  String get privacyPolicyContent => isRussian
      ? 'Здесь будет политика конфиденциальности.'
      : 'Privacy policy will be here.';

  String get logout => isRussian ? 'Выйти из аккаунта' : 'Logout';
  String get logoutTitle => isRussian ? 'Выход из аккаунта' : 'Logout';
  String get logoutMessage => isRussian
      ? 'Вы уверены, что хотите выйти из аккаунта?'
      : 'Are you sure you want to logout?';
  String get cancel => isRussian ? 'Отмена' : 'Cancel';
  String get confirm => isRussian ? 'Выйти' : 'Logout';
  String get loggedOut => isRussian ? 'Вы вышли из аккаунта' : 'You have logged out';
  String get close => isRussian ? 'Закрыть' : 'Close';
}

