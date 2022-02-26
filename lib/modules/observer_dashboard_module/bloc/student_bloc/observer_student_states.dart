import 'package:palette/modules/observer_dashboard_module/models/user_models/observer_student_mentors_model.dart';

abstract class ObserverStudentState {}

class InitialUserState extends ObserverStudentState {}

///
class GetStudentInitialStage extends ObserverStudentState {}

///

/// User Profile Fetching
class StudentUserSuccessState extends ObserverStudentState {
  ObserverStudent observerStudentsMentorsList;
  StudentUserSuccessState({required this.observerStudentsMentorsList});
}

class StudentUserFailedState extends ObserverStudentState {
  String error;

  StudentUserFailedState({required this.error});
}

class StudentUserLoadingState extends ObserverStudentState {}
