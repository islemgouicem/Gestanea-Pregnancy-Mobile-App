import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/baby/data/datasources/baby_local_data_source.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_state.dart';
import 'package:gestanea/features/baby/logic/repositories/baby_repository.dart';
import 'package:gestanea/features/doctors/presentation/pages/doctors_page.dart' show DoctorsScreen;
import 'package:gestanea/features/dashboard/presentation/pages/tips_page.dart' as tips;
import 'package:gestanea/features/dashboard/presentation/pages/notificationsPage.dart';
import 'package:gestanea/features/dashboard/presentation/pages/baby_settings_page.dart';
import 'package:intl/intl.dart';
import 'postpartum_track_page.dart';

class PostpartumDashboardPage extends StatefulWidget {
  final String babyGender;

  const PostpartumDashboardPage({
    super.key,
    required this.babyGender,
  });

  @override
  State<PostpartumDashboardPage> createState() =>
      _PostpartumDashboardPageState();
}

class _PostpartumDashboardPageState extends State<PostpartumDashboardPage> {
  int _selectedNavIndex = 0;
  String? _cachedBabyId;

  Color get primaryColor =>
      widget.babyGender == 'girl' ? const Color(0xFFFF9EC9) : const Color(0xFF87CEEB);

  Color get lightColor =>
      widget.babyGender == 'girl' ? const Color(0xFFFFC6E0) : const Color(0xFFB0E0E6);

  String _getUserId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return '';
  }

  String _formatAgeText(DateTime dateOfBirth) {
    final now = DateTime.now();
    final age = now.year * 12 + now.month - (dateOfBirth.year * 12 + dateOfBirth.month);
    
    if (age == 0) {
      return 'Newborn';
    } else if (age == 1) {
      return '1 month old';
    } else if (age < 12) {
      return '$age months old';
    } else if (age == 12) {
      return '1 year old';
    } else {
      final years = age ~/ 12;
      final remainingMonths = age % 12;
      if (remainingMonths == 0) {
        return '$years ${years == 1 ? 'year' : 'years'} old';
      }
      return '$years ${years == 1 ? 'year' : 'years'} and $remainingMonths ${remainingMonths == 1 ? 'month' : 'months'} old';
    }
  }

  void _navigateToTrackPage(String babyId) {
    final userId = _getUserId();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => BabyCubit(
            repository: BabyRepository(
              BabyLocalDataSource(DatabaseHelper.instance),
            ),
            userId: userId,
          )..loadBabyProfile(),
          child: PostpartumTrackPage(babyGender: widget.babyGender),
        ),
      ),
    );
  }

  void _navigateToBabySettings(String babyId) {
    final userId = _getUserId();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => BabyCubit(
            repository: BabyRepository(
              BabyLocalDataSource(DatabaseHelper.instance),
            ),
            userId: userId,
          )..loadBabyProfile(),
          child: BabySettingsPage(
            babyGender: widget.babyGender,
            babyId: babyId,
          ),
        ),
      ),
    );
  }

  void _handleNavigation(int index, String babyId) {
    switch (index) {
      case 0:
        // Stay on home
        setState(() => _selectedNavIndex = 0);
        break;
      case 1:
        // Track tab
        _navigateToTrackPage(babyId);
        break;
      case 2:
        // Health tab
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DoctorsScreen()),
        );
        break;
      case 3:
        // Plan tab
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Plan tab coming soon'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 4:
        // Market tab
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Marketplace coming soon'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8FF),
      body: BlocBuilder<BabyCubit, BabyState>(
        builder: (context, state) {
          // Cache baby ID for navigation
          if (state is BabyLoaded) {
            _cachedBabyId = state.baby.id;
          }

          // Extract data from state
          String babyName = 'Baby';
          DateTime babyDateOfBirth = DateTime.now();
          double babyWeight = 0.0;
          double babyHeight = 0.0;
          List milestones = [];

          if (state is BabyLoaded) {
            babyName = state.baby.name;
            babyDateOfBirth = state.baby.dateOfBirth;
            milestones = state.milestones;
            
            // Get latest growth record if available
            if (state.latestGrowth != null) {
              babyWeight = state.latestGrowth!.weight ?? 0.0;
              babyHeight = state.latestGrowth!.height ?? 0.0;
            }
          }

          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================== GREETING HEADER ====================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => _navigateToBabySettings(
                          _cachedBabyId ?? '',
                        ),
                        child: Text(
                          'Hello Mama !',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      // Notification Bell
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationsPage(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.03,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          child: Icon(
                            Icons.notifications_none,
                            color: primaryColor,
                            size: screenWidth * 0.06,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.025),

                  // ==================== BABY INFO CARD ====================
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, lightColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Baby name and age
                        Row(
                          children: [
                            CircleAvatar(
                              radius: screenWidth * 0.07,
                              backgroundColor: Colors.white.withValues(alpha: 0.3),
                              child: Icon(
                                Icons.child_care,
                                size: screenWidth * 0.08,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    babyName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.05,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  Text(
                                    _formatAgeText(babyDateOfBirth),
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Stats grid (Weight, Height, Growth)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem(
                                label: 'Weight',
                                value: babyWeight > 0
                                    ? '${babyWeight.toStringAsFixed(1)} kg'
                                    : '--',
                                screenWidth: screenWidth,
                              ),
                              VerticalDivider(
                                color: Colors.white.withValues(alpha: 0.3),
                                thickness: 1,
                              ),
                              _buildStatItem(
                                label: 'Height',
                                value: babyHeight > 0
                                    ? '${babyHeight.toStringAsFixed(0)} cm'
                                    : '--',
                                screenWidth: screenWidth,
                              ),
                              VerticalDivider(
                                color: Colors.white.withValues(alpha: 0.3),
                                thickness: 1,
                              ),
                              _buildStatItem(
                                label: 'Growth',
                                value: 'On Track',
                                screenWidth: screenWidth,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),

                        // View More button
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                                vertical: screenHeight * 0.008,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  screenWidth * 0.05,
                                ),
                              ),
                            ),
                            onPressed: () => _navigateToTrackPage(
                              _cachedBabyId ?? '',
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'More Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Icon(
                                  Icons.arrow_forward,
                                  size: screenWidth * 0.035,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),

                  // ==================== QUICK ACTIONS ====================
                  Row(
                    children: [
                      // Our Tips Card
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const tips.Tips(),
                              ),
                            );
                          },
                          child: _buildActionCard(
                            icon: Icons.lightbulb_outline,
                            title: 'Our Tips',
                            subtitle: 'follow best practices',
                            color: primaryColor,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      // Our Doctors Card
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DoctorsScreen(),
                              ),
                            );
                          },
                          child: _buildActionCard(
                            icon: Icons.medical_services_outlined,
                            title: 'Our Doctors',
                            subtitle: 'find the best doctor',
                            color: lightColor,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // ==================== UPCOMING SECTION ====================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Events',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _handleNavigation(3, _cachedBabyId ?? '');
                        },
                        child: Text(
                          'see all',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.015),

                  // Upcoming events list
                  if (milestones.isNotEmpty)
                    ...milestones.take(3).map((milestone) => Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                          child: _buildEventCard(
                            title: milestone.milestoneName,
                            date: milestone.achievedDate != null
                                ? DateFormat('MMM d, yyyy').format(milestone.achievedDate!)
                                : 'TBD',
                            icon: Icons.celebration,
                            color: primaryColor,
                            screenWidth: screenWidth,
                          ),
                        ))
                  else
                    _buildEventCard(
                      title: 'No upcoming events',
                      date: 'Check back later!',
                      icon: Icons.event_busy,
                      color: lightColor,
                      screenWidth: screenWidth,
                    ),

                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          );
        },
      ),

      // ==================== BOTTOM NAVIGATION ====================
      bottomNavigationBar: BlocBuilder<BabyCubit, BabyState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: _selectedNavIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey.shade400,
            elevation: 8,
            onTap: (index) {
              setState(() {
                _selectedNavIndex = index;
              });
              _handleNavigation(index, _cachedBabyId ?? '');
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up),
                label: 'Track',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Health',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Plan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Market',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required double screenWidth,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: screenWidth * 0.03,
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.035,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: screenWidth * 0.06,
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.04,
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white70,
              fontSize: screenWidth * 0.03,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required String title,
    required String date,
    required IconData icon,
    required Color color,
    required double screenWidth,
  }) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.5),
            radius: screenWidth * 0.05,
            child: Icon(
              icon,
              color: Colors.white,
              size: screenWidth * 0.04,
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.037,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenWidth * 0.005),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: screenWidth * 0.032,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: color,
            size: screenWidth * 0.05,
          ),
        ],
      ),
    );
  }
}
