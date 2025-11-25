import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/widgets/header.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../widgets/week_calendar.dart';
import '../widgets/plan_toggle.dart';
import '../widgets/medicine_progress_card.dart';
import '../widgets/add_button.dart';
import '../widgets/upcoming_appointments_card.dart';

class PlanMainPage extends StatefulWidget {
  const PlanMainPage({super.key});

  @override
  State<PlanMainPage> createState() => _PlanMainPageState();
}

class _PlanMainPageState extends State<PlanMainPage> {
  bool showMedicine = true; // true = Medicine, false = Appointments
  DateTime selectedDate = DateTime.now();

  // Get days for the week
  List<DateTime> getWeekDays() {
    final today = DateTime.now();
    final weekDay = today.weekday;
    final startOfWeek = today.subtract(Duration(days: weekDay % 7));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  String _formattedDate(DateTime date) {
    final localizations = AppLocalizations.of(context)!;
    final weekdays = [
      localizations.sunday,
      localizations.monday,
      localizations.tuesday,
      localizations.wednesday,
      localizations.thursday,
      localizations.friday,
      localizations.saturday,
    ];
    final months = [
      localizations.jan,
      localizations.feb,
      localizations.mar,
      localizations.apr,
      localizations.may,
      localizations.jun,
      localizations.jul,
      localizations.aug,
      localizations.sep,
      localizations.oct,
      localizations.nov,
      localizations.dec,
    ];
    String weekday = weekdays[date.weekday % 7];
    String month = months[date.month - 1];
    return '$weekday, $month ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final weekDays = getWeekDays();

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(title: localization.plan, showBackButton: false),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Display
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Text(
                        _formattedDate(selectedDate),
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Week Calendar
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: WeekCalendar(
                        weekDays: weekDays,
                        selectedDate: selectedDate,
                        onDateSelected: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Medicine / Appointments Toggle
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: PlanToggle(
                        showMedicine: showMedicine,
                        onToggle: (value) {
                          setState(() {
                            showMedicine = value;
                          });
                        },
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Today's Medicine Progress Card
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: MedicineProgressCard(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        progress: 0.25,
                        takenText: '1 of 4 taken',
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Add New Medicine Button
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: AddButton(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        text: localization.addNewMedicine,
                        onTap: () {
                          // Add medicine action
                        },
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Upcoming Appointments Card
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: UpcomingAppointmentsCard(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        scheduledCount: 3,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Add New Appointment Button
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: AddButton(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        text: localization.addNewAppointment,
                        onTap: () {
                          // Add appointment action
                        },
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
