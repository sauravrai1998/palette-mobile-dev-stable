import 'package:palette/modules/student_dashboard_module/models/college_application_list_model.dart';
import 'package:palette/modules/student_dashboard_module/models/event_list_model.dart';
import 'package:palette/modules/student_dashboard_module/models/job_application_list_model.dart';

abstract class StudentState {}

class GetStudentInitialStage extends StudentState {}

class CollegeApplicationListSuccessState extends StudentState {
  CollegeApplicationList list;
  CollegeApplicationListSuccessState({required this.list});
}

class CollegeApplicationListLoadingState extends StudentState {}

class CollegeApplicationListFailedState extends StudentState {
  String error;

  CollegeApplicationListFailedState({required this.error});
}

class JobApplicationListSuccessState extends StudentState {
  JobApplicationListModel listModel;
  JobApplicationListSuccessState({required this.listModel});
}

class JobApplicationListLoadingState extends StudentState {}

class JobApplicationListFailedState extends StudentState {
  String error;

  JobApplicationListFailedState({required this.error});
}

class EventListSuccessState extends StudentState {
  EventList list;
  EventListSuccessState({required this.list});
}

class EventListLoadingState extends StudentState {}

class EventListFailedState extends StudentState {
  String error;

  EventListFailedState({required this.error});
}
