import 'package:equatable/equatable.dart';
import 'package:gestanea/core/database/models/mood_model.dart';

abstract class MoodEvent extends Equatable {
  const MoodEvent();
  @override
  List<Object?> get props => [];
}

class AddMood extends MoodEvent {
  final MoodModel mood;
  const AddMood(this.mood);
  @override
  List<Object?> get props => [mood];
}

class LoadMoods extends MoodEvent {}
