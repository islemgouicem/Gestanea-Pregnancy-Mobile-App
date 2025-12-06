import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final Color baseColor;
  final VoidCallback? onTap;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 25.0,
    this.padding = const EdgeInsets.all(16.0),
    this.baseColor = AppColors.background,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: (AppColors.shadow1 as List).map((dynamic s) {
            return BoxShadow(
              color: s.color,
              offset: s.offset,
              blurRadius: s.blurRadius,
              spreadRadius: s.spreadRadius,
            );
          }).toList(),
        ),
        child: child,
      ),
    );
  }
}

// --- Custom Neumorphic Text Field Widget ---
class NeumorphicTextField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;

  const NeumorphicTextField({
    super.key,
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          const BoxShadow(
            color: AppColors.white,
            offset: Offset(-2.5, -2.5),
            blurRadius: 5,
            spreadRadius: -5,
            inset: true,
          ),
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.25),
            offset: const Offset(2.5, 2.5),
            blurRadius: 5,
            inset: true,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.main400,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextField(
            maxLines: maxLines,
            style: TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.main400.withOpacity(0.5),
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none, // Removes the default underline
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Contact Us Screen Implementation ---
class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      appBar: AppBar(
        backgroundColor: AppColors.bg_1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.main500, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          t.contact_us,
          style: AppTextStyles.headline1.copyWith(
            color: AppColors.main500,
            fontSize: 32,
            fontFamily: 'Lato',
            letterSpacing: -0.40,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 1. "Get in Touch" Header Card
            NeumorphicContainer(
              borderRadius: 30.0,
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 30.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.getInTouch,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.contactFormDescription,
                    style: TextStyle(
                      color: AppColors.main700.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Contact details
                  _buildContactDetail(Icons.email_outlined, t.supportEmail),
                  _buildContactDetail(Icons.phone_outlined, t.supportPhone),
                  _buildContactDetail(Icons.schedule, t.supportHours),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Contact Form Fields
            NeumorphicTextField(label: t.yourNameLabel, hint: t.enterYourName),
            const SizedBox(height: 15),
            NeumorphicTextField(
              label: t.emailAddressLabel,
              hint: t.emailPlaceholder,
            ),
            const SizedBox(height: 15),
            NeumorphicTextField(label: t.subjectLabel, hint: t.whatIsThisAbout),
            const SizedBox(height: 15),
            NeumorphicTextField(
              label: t.messageLabel,
              hint: t.tellUsHowWeCanHelp,
              maxLines: 6,
            ),
            const SizedBox(height: 30),

            // 3. Submit Button
            NeumorphicButton(
              text: t.sendMessage,
              onPressed: () {},
              prefixIcon: Icons.send,
              color: AppColors.main500,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper method for the contact details in the header card
  Widget _buildContactDetail(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.main400, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
