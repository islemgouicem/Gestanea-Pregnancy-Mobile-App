import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/database/models/mood_model.dart';
import 'mood_event.dart';
import 'mood_state.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  final List<MoodModel> _moods = [];

  MoodBloc() : super(MoodInitial()) {
    on<AddMood>((event, emit) {
      _moods.add(event.mood);
      emit(MoodLoaded(List.from(_moods)));
    });
    on<LoadMoods>((event, emit) {
      emit(MoodLoaded(List.from(_moods)));
    });
  }
}
