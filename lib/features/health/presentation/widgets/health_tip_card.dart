import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class HealthTipCard extends StatelessWidget {
  final String message;

  const HealthTipCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8D5F2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(2, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Color(0xFF7B4BA6),
          fontSize: 13,
          fontFamily: 'Lato',
        ),
      ),
    );
  }
}