import 'package:equatable/equatable.dart';
import 'package:gestanea/core/database/models/mood_model.dart';

abstract class MoodState extends Equatable {
  const MoodState();
  @override
  List<Object?> get props => [];
}

class MoodInitial extends MoodState {}

class MoodLoaded extends MoodState {
  final List<MoodModel> moods;
  const MoodLoaded(this.moods);
  @override
  List<Object?> get props => [moods];
}

class MoodError extends MoodState {
  final String message;
  const MoodError(this.message);
  @override
  List<Object?> get props => [message];
}
