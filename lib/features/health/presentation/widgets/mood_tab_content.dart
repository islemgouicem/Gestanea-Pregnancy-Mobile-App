import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'dialogs/add_mood_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import removed: '/../../../core/database/models/mood_model.dart';
import '../../logic/bloc/mood_bloc.dart';
import '../../logic/bloc/mood_state.dart';

class MoodTabContent extends StatefulWidget {
  const MoodTabContent({super.key});

  @override
  State<MoodTabContent> createState() => _MoodTabContentState();
}

class _MoodTabContentState extends State<MoodTabContent> {

  // Only keep one build method, remove duplicate and ensure correct widget tree

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAF0FF),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Mood
                Text(
                  l10n. howAreYouFeelingToday,
                  style: AppTextStyles.headline2.copyWith(
                    fontSize: 18,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),

                // Mood Selector
                _buildMoodSelector(context),
                const SizedBox(height: 20),

                Text(
                  l10n.recentEntries,
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<MoodBloc, MoodState>(
                  builder: (context, state) {
                    if (state is MoodLoaded && state.moods.isNotEmpty) {
                      return Column(
                        children: state.moods.map((mood) {
                          return Column(
                            children: [
                              _buildMoodEntryCard(
                                context,
                                emoji: _emojiForMood(mood.mood),
                                mood: mood.mood,
                                note: mood.notes ?? '',
                                time: _formatMoodDate(mood.recordedAt),
                                color: const Color(0xFFE1F5FE),
                                intensity: mood.intensity,
                              ),
                              const SizedBox(height: 12),
                            ],
                          );
                        }).toList(),
                      );
                    } else if (state is MoodLoaded) {
                      return Text('No mood entries yet');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                const SizedBox(height: 20),
                // Mood Trends (only if there are entries)
                BlocBuilder<MoodBloc, MoodState>(
                  builder: (context, state) {
                    if (state is MoodLoaded && state.moods.isNotEmpty) {
                      return Column(
                        children: [
                          _buildMoodTrendsCard(context),
                          const SizedBox(height: 20),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                // Self-Care Suggestions
                _buildSelfCareCard(context),
                const SizedBox(height: 16),
                // Tip Card
                _buildTipCard(l10n.trackingMoodHelps),
              ],
            ),
          ),
        ),
        // Additional UI elements...
      ],
    );
  }

  String _emojiForMood(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy': return '😊';
      case 'calm': return '😌';
      case 'tired': return '😴';
      case 'sad': return '😢';
      case 'neutral': return '😐';
      default: return '🙂';
    }
  }

  String _formatMoodDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) {
      return '${diff.inDays} days ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hours ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildMoodEntryCard(
    BuildContext context, {
    required String emoji,
    required String mood,
    required String note,
    required String time,
    required Color color,
    int? intensity,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
          BoxShadow(
            color: AppColors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mood, style: AppTextStyles.subtitle1.copyWith(fontSize: 16, color: AppColors.textDark)),
                if (intensity != null)
                  Text('Intensity: $intensity', style: AppTextStyles.body1.copyWith(fontSize: 13, color: AppColors.main500)),
                if (note.isNotEmpty)
                  Text(note, style: AppTextStyles.body1.copyWith(fontSize: 14, color: Colors.grey.shade700)),
                Text(time, style: AppTextStyles.body1.copyWith(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodTrendsCard(BuildContext context) {
    // TODO: Implement real trends UI
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Text('Mood trends will appear here', style: AppTextStyles.body1),
    );
  }

  Widget _buildMoodSelector(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final moods = [
      {'emoji': '😄', 'label': l10n.great},
      {'emoji': '😊', 'label': l10n.good},
      {'emoji': '😐', 'label': l10n.okay},
      {'emoji': '😔', 'label': l10n.sad},
      {'emoji': '😢', 'label': l10n.verySad},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: moods.map((mood) {
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => AddMoodDialog(initialMood: mood['label']),
            );
          },
          child: Column(
            children: [
              Text(
                mood['emoji']!,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 4),
              Text(
                mood['label']!,
                style: AppTextStyles.smallLabel.copyWith(
                  fontSize: 11,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }


  Widget _buildMoodTrendItem(String emoji, String count) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(count, style: AppTextStyles.body1.copyWith(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildSelfCareCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selfCareSuggestions,
          style: AppTextStyles.subtitle1.copyWith(
            fontSize: 14,
            color: const Color(0xFF2E7D32),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildSelfCareItem(l10n.takeShortWalk),
        _buildSelfCareItem(l10n.practiceDeepBreathing),
        _buildSelfCareItem(l10n.listenToCalmingMusic),
        _buildSelfCareItem(l10n.connectWithLovedOnes),
      ],
    );
  }


  Widget _buildSelfCareItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Color(0xFF2E7D32)),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.body1.copyWith(
              fontSize: 12,
              color: const Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
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
        style: AppTextStyles.body1. copyWith(
          color: const Color(0xFF7B4BA6),
          fontSize: 12,
        ),
      ),
    );
  }
}