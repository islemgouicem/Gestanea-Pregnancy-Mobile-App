import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class MoodTabContent extends StatelessWidget {
  const MoodTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      decoration: const ShapeDecoration(
        color: AppColors.main300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
        ),
        shadows: [
          BoxShadow(
            color: AppColors.white,
            blurRadius: 6,
            offset: Offset(-4, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${localizations.mood} - Coming Soon',
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.main500,
          ),
        ),
      ),
    );
  }
}