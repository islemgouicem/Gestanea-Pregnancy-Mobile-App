import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class MedicinesPage extends StatefulWidget {
  const MedicinesPage({super.key});

  @override
  State<MedicinesPage> createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  DateTime selectedDate = DateTime.now();
  String selectedFilter = 'All'; // All, Taken, Missed

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Pills (All, Taken, Missed)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  children: [
                    _buildFilterPill('All', 4),
                    SizedBox(width: 12),
                    _buildFilterPill('Taken', 1),
                    SizedBox(width: 12),
                    _buildFilterPill('Missed', 2),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // Medicine List
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: [
                    _buildMedicineCard(
                      'Captopril',
                      '2 Capsules',
                      '20:00',
                      'Daily',
                      'assets/images/captopril.png', // placeholder
                      'Take',
                      AppColors.main500,
                      false,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    _buildMedicineCard(
                      'B 12',
                      '1 Injection',
                      '22:00',
                      'Daily',
                      'assets/images/b12.png', // placeholder
                      'Taken',
                      Colors.green,
                      true,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    _buildMedicineCard(
                      'I-DROP MGD',
                      '2 Drops',
                      '22:00',
                      'Daily',
                      'assets/images/idrop.png', // placeholder
                      'Take',
                      AppColors.main500,
                      false,
                      showMissedBadge: true,
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPill(String label, int count) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.main300 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.main500 : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.main600 : Colors.black87,
              ),
            ),
            SizedBox(width: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.main600 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineCard(
    String name,
    String dosage,
    String time,
    String frequency,
    String imagePath,
    String buttonText,
    Color buttonColor,
    bool isTaken, {
    bool showMissedBadge = false,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.bg_1,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
          BoxShadow(
            color: const Color(0xFFFFFFFF),
            blurRadius: 10,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // Medicine Image
              Container(
                width: screenWidth * 0.2,
                height: screenWidth * 0.2,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.medication, size: 40, color: Colors.grey);
                  },
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              // Medicine Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      dosage,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          ' | ',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          frequency,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.012),
                    // Take/Taken Button
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        buttonText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Missed Badge
          if (showMissedBadge)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.error1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Missed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
