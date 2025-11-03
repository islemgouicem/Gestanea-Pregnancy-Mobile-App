import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'vitals_card.dart';
import 'bmi_card.dart';
import 'weight_progress_chart.dart';
import 'add_measurement_card.dart';
import 'health_tip_card.dart';

class VitalsTabContent extends StatelessWidget {
  const VitalsTabContent({super.key});

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top Row: Weight & Heart Rate
            Row(
              children: [
                Expanded(
                  child: VitalsCard(
                    icon: Icons.monitor_weight_outlined,
                    title: localizations.weight,
                    value: '69 Kg',
                    status: localizations.normal,
                    statusColor: const Color(0xFFB8E6B8),
                    textColor: const Color(0xFF2D5F2D),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: VitalsCard(
                    icon: Icons.favorite,
                    title: localizations.heartRate,
                    value: '72 bpm',
                    status: localizations.normal,
                    statusColor: const Color(0xFFB8E6B8),
                    textColor: const Color(0xFF2D5F2D),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Second Row: Blood Pressure & Add Measurement
            Row(
              children: [
                Expanded(
                  child: VitalsCard(
                    icon: Icons.favorite,
                    title: localizations.bloodPressure,
                    value: '120/80',
                    status: localizations.normal,
                    statusColor: const Color(0xFFB8E6B8),
                    textColor: const Color(0xFF2D5F2D),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AddMeasurementCard(
                    onTap: () {
                      // Handle add measurement
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // BMI Card
            const BMICard(),

            const SizedBox(height: 16),

            // Weight Progress Chart
            const WeightProgressChart(),

            const SizedBox(height: 16),

            // Health Tip
            HealthTipCard(
              message: localizations.healthTipMessage,
            ),
          ],
        ),
      ),
    );
  }
}