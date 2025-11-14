import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/settings_provider.dart';
import '../localization/settings_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProviderProvider);
    final notificationsEnabled = settingsState.notificationsEnabled;
    final darkModeEnabled = settingsState.darkModeEnabled;
    final language = settingsState.language;
    final localizations = SettingsLocalizations(language: language);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settingsTitle),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, localizations.notificationsSection),
          SwitchListTile(
            title: Text(localizations.notificationsTitle),
            subtitle: Text(localizations.notificationsSubtitle),
            value: notificationsEnabled,
            onChanged: (value) {
              ref.read(settingsProviderProvider.notifier).setNotificationsEnabled(value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.notificationsEnabled(value)),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            secondary: const Icon(Icons.notifications),
          ),
          _buildSectionHeader(context, localizations.appearanceSection),
          SwitchListTile(
            title: Text(localizations.darkThemeTitle),
            subtitle: Text(localizations.darkThemeSubtitle),
            value: darkModeEnabled,
            onChanged: (value) {
              ref.read(settingsProviderProvider.notifier).setDarkModeEnabled(value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.darkThemeEnabled(value)),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          _buildSectionHeader(context, localizations.languageSection),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(localizations.languageTitle),
            subtitle: Text(language),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showLanguageDialog(context, ref, language, localizations);
            },
          ),
          _buildSectionHeader(context, localizations.aboutSection),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(localizations.appVersionTitle),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(localizations.termsOfUse),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showInfoDialog(context, localizations.termsOfUse, localizations.termsOfUseContent, localizations);
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text(localizations.privacyPolicy),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showInfoDialog(context, localizations.privacyPolicy, localizations.privacyPolicyContent, localizations);
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: OutlinedButton.icon(
              onPressed: () {
                _showLogoutDialog(context, localizations);
              },
              icon: const Icon(Icons.logout),
              label: Text(localizations.logout),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, String currentLanguage, SettingsLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(localizations.russian),
              value: 'Русский',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProviderProvider.notifier).setLanguage(value);
                }
                Navigator.pop(context);
                final newLocalizations = SettingsLocalizations(language: value!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(newLocalizations.languageChanged(newLocalizations.russian)),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
            RadioListTile<String>(
              title: Text(localizations.english),
              value: 'English',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProviderProvider.notifier).setLanguage(value);
                }
                Navigator.pop(context);
                final newLocalizations = SettingsLocalizations(language: value!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(newLocalizations.languageChanged(newLocalizations.english)),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content, SettingsLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.close),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, SettingsLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.logoutTitle),
        content: Text(localizations.logoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localizations.loggedOut)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(localizations.confirm),
          ),
        ],
      ),
    );
  }
}