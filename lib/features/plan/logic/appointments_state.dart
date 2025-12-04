import 'package:equatable/equatable.dart';
import 'package:gestanea/core/models/appointment.dart';

abstract class AppointmentsState extends Equatable {
  const AppointmentsState();
  
  @override
  List<Object?> get props => [];
}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final List<Appointment> appointments;

  const AppointmentsLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

class AppointmentsError extends AppointmentsState {
  final String message;

  const AppointmentsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AppointmentsOperationSuccess extends AppointmentsState {
  final String message;

  const AppointmentsOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
