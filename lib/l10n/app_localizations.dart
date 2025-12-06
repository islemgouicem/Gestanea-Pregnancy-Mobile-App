import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Minimal localization scaffold to satisfy imports and provide basic lookup.
/// You can extend this to load strings from ARB/JSON later.
class AppLocalizations {
  final Locale locale;
  const AppLocalizations(this.locale);

  // Supported locales in the app
  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(Locale('en'));
  }

  // Basic fallback translation function
  String t(String key) => _localizedValues[key] ?? key;

  // Example values map; populate as needed
  static const Map<String, String> _localizedValues = {
    'app_title': 'Gestanéa',
  };

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // In a full implementation, load resources here.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
