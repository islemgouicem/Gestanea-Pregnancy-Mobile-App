// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Soins de la Grossesse et du Bébé';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get login => 'Connexion';

  @override
  String get signup => 'S\'inscrire';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get logout => 'Déconnexion';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get darkMode => 'Mode Sombre';

  @override
  String get notifications => 'Notifications';

  @override
  String get help => 'Aide';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get pregnant => 'Enceinte';

  @override
  String get postpartum => 'Après l\'accouchement';

  @override
  String week(int week) {
    return 'Semaine $week';
  }

  @override
  String daysLeft(int days) {
    return '$days jours restants';
  }
}
