import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/custom_button.dart';
import 'package:gestanea/core/database/models/mood_model.dart';
import '../../logic/bloc/mood_bloc.dart';
import '../../logic/bloc/mood_event.dart';

class ManualMoodEntryPage extends StatefulWidget {
  const ManualMoodEntryPage({super.key});

  @override
  State<ManualMoodEntryPage> createState() => _ManualMoodEntryPageState();
}

class _ManualMoodEntryPageState extends State<ManualMoodEntryPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedMood;
  int? _intensity;
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _saveMood() {
    if (_formKey.currentState!.validate() && _selectedMood != null) {
      final moodEntry = MoodModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user',
        mood: _selectedMood!,
        intensity: _intensity,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        recordedAt: _selectedDate,
        createdAt: DateTime.now(),
      );
      context.read<MoodBloc>().add(AddMood(moodEntry));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mood entry added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Mood Entry'),
        backgroundColor: AppColors.main500,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Mood Details',
                style: AppTextStyles.headline2.copyWith(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedMood,
                decoration: InputDecoration(
                  labelText: 'Mood *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: ['Happy', 'Sad', 'Angry', 'Calm', 'Stressed', 'Excited', 'Tired']
                    .map((mood) => DropdownMenuItem(value: mood, child: Text(mood)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedMood = value),
                validator: (value) => value == null ? 'Please select a mood' : null,
              ),
              const SizedBox(height: 16),
              Text('Intensity', style: AppTextStyles.subtitle1.copyWith(fontSize: 14, color: Colors.black87)),
              Slider(
                value: (_intensity ?? 5).toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: (_intensity ?? 5).toString(),
                onChanged: (value) => setState(() => _intensity = value.toInt()),
              ),
              const SizedBox(height: 16),
              Text('Date', style: AppTextStyles.subtitle1.copyWith(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.main300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.main500, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: AppTextStyles.body1,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Any additional notes... ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: _saveMood,
                  text: 'Save Mood',
                  filled: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
