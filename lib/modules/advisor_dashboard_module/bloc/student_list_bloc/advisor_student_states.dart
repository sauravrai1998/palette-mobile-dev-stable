import 'package:palette/modules/advisor_dashboard_module/models/advisor_student_model.dart';

abstract class AdvisorStudentState {}

class AdvisorUserState extends AdvisorStudentState {}

class AdvisorGetStudentInitialStage extends AdvisorStudentState {}

/// User Profile Fetching
class AdvisorStudentUserSuccessState extends AdvisorStudentState {
  AdvisorStudentList advisorStudentsMentorsList;

  AdvisorStudentUserSuccessState({required this.advisorStudentsMentorsList});
}

class AdvisorStudentUserFailedState extends AdvisorStudentState {
  String error;

  AdvisorStudentUserFailedState({required this.error});
}

class AdvisorStudentUserLoadingState extends AdvisorStudentState {}
