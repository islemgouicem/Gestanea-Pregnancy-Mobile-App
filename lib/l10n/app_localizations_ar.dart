// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'رعاية الحمل والطفل';

  @override
  String get welcome => 'أهلا وسهلا';

  @override
  String get login => 'دخول';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get help => 'المساعدة';

  @override
  String get about => 'حول';

  @override
  String get version => 'الإصدار';

  @override
  String get pregnant => 'حامل';

  @override
  String get postpartum => 'ما بعد الولادة';

  @override
  String week(int week) {
    return 'الأسبوع $week';
  }

  @override
  String daysLeft(int days) {
    return '$days أيام متبقية';
  }
}
