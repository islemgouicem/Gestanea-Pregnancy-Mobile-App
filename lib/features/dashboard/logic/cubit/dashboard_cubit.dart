import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';
import '../../domain/usecases/get_pregnancy_dashboard_usecase.dart';
import '../../domain/usecases/get_postpartum_dashboard_usecase.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetPregnancyDashboardUseCase _getPregnancyDashboardUseCase;
  final GetPostpartumDashboardUseCase _getPostpartumDashboardUseCase;

  DashboardCubit({
    GetPregnancyDashboardUseCase? getPregnancyDashboardUseCase,
    GetPostpartumDashboardUseCase? getPostpartumDashboardUseCase,
  })  : _getPregnancyDashboardUseCase =
            getPregnancyDashboardUseCase ?? GetPregnancyDashboardUseCase(),
        _getPostpartumDashboardUseCase =
            getPostpartumDashboardUseCase ?? GetPostpartumDashboardUseCase(),
        super(DashboardInitial());

  Future<void> loadPregnancyDashboard() async {
    emit(DashboardLoading());
    try {
      final dashboard = await _getPregnancyDashboardUseCase.call();
      emit(PregnancyDashboardLoaded(dashboard));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> loadPostpartumDashboard() async {
    emit(DashboardLoading());
    try {
      final dashboard = await _getPostpartumDashboardUseCase.call();
      emit(PostpartumDashboardLoaded(dashboard));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> refreshDashboard({required bool isPregnant}) async {
    if (isPregnant) {
      await loadPregnancyDashboard();
    } else {
      await loadPostpartumDashboard();
    }
  }

  void reset() {
    emit(DashboardInitial());
  }
}
