import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPage();
}

class _AppointmentsPage extends State<AppointmentsPage> {
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
              // "1 day" badge
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.05),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.main600,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          '1 day',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Appointment Cards
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: [
                    _buildAppointmentCard(
                      'Follow-up Visit',
                      'Dr. Sarah Johnson',
                      'Tomorrow',
                      '10:00 AM',
                      Icons.favorite_border,
                      screenWidth,
                      screenHeight,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    _buildAppointmentCard(
                      'Radiology Appointment',
                      'Radiology Dept',
                      'Feb 5, 2025',
                      '2:30 PM',
                      Icons.access_time,
                      screenWidth,
                      screenHeight,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    _buildAppointmentCard(
                      'Blood Test',
                      'Lab Services',
                      'Feb 10, 2025',
                      '9:00 AM',
                      Icons.science_outlined,
                      screenWidth,
                      screenHeight,
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

  Widget _buildAppointmentCard(
    String title,
    String subtitle,
    String date,
    String time,
    IconData icon,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Circle
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.main500, AppColors.main600],
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(width: screenWidth * 0.04),
          // Appointment Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.042,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    SizedBox(width: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: screenWidth * 0.032,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: screenWidth * 0.032,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
