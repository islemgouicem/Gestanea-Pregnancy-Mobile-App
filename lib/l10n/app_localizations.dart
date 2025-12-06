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

  // Convenience getters used across the app (auth/login)
  String get auth => t('auth');
  String get auth2 => t('auth2');
  String get or => t('or');
  String get register => t('register');
  String get welcome_back => t('welcome_back');
  String get login => t('login');
  String get email => t('email');
  String get enter_email => t('enter_email');
  String get password => t('password');
  String get rememberMe => t('rememberMe');
  String get forgot => t('forgot');
  String get notRegistered => t('notRegistered');
  String get createAccount => t('createAccount');

  // Example values map; populate as needed
  static const Map<String, String> _localizedValues = {
    'app_title': 'Gestanéa',
    'auth': 'Welcome to Gestanéa',
    'auth2': 'Join us to track pregnancy and baby care',
    'or': 'OR',
    'register': 'Create Account',
    'welcome_back': 'Welcome Back',
    'login': 'LOG IN',
    'email': 'Email Address',
    'enter_email': 'Enter your email',
    'password': 'Password',
    'rememberMe': 'Remember me',
    'forgot': 'Forgot Password?',
    'notRegistered': "Don't have an account?",
    'createAccount': 'Create an Account',
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
