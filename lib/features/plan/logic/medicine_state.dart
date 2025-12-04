import 'package:equatable/equatable.dart';
import 'package:gestanea/core/models/medicine.dart';
import 'package:gestanea/core/models/medicine_log.dart';

abstract class MedicineState extends Equatable {
  const MedicineState();
  
  @override
  List<Object?> get props => [];
}

class MedicineInitial extends MedicineState {}

class MedicineLoading extends MedicineState {}

class MedicineLoaded extends MedicineState {
  final List<Medicine> medicines;
  final List<MedicineLog> medicineLogs;

  const MedicineLoaded({
    this.medicines = const [],
    this.medicineLogs = const [],
  });

  @override
  List<Object?> get props => [medicines, medicineLogs];
}

class MedicineError extends MedicineState {
  final String message;

  const MedicineError(this.message);

  @override
  List<Object?> get props => [message];
}

class MedicineOperationSuccess extends MedicineState {
  final String message;

  const MedicineOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
