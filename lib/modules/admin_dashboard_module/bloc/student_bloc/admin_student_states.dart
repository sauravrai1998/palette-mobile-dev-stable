import 'package:palette/modules/admin_dashboard_module/models/user_models/admin_student_mentors_model.dart';

abstract class AdminStudentState {}

class AdminInitialUserState extends AdminStudentState {}

///
class GetStudentInitialStage extends AdminStudentState {}

/// User Profile Fetching
class StudentUserSuccessState extends AdminStudentState {
  AdminStudent adminStudentsMentorsList;
  StudentUserSuccessState({required this.adminStudentsMentorsList});
}

class StudentUserFailedState extends AdminStudentState {
  String error;

  StudentUserFailedState({required this.error});
}

class StudentUserLoadingState extends AdminStudentState {}
