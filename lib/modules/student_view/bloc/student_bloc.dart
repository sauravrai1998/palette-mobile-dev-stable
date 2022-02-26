import 'dart:async';

import 'package:palette/modules/student_dashboard_module/models/college_application_list_model.dart';
import 'package:palette/modules/student_dashboard_module/models/event_list_model.dart';
import 'package:palette/modules/student_dashboard_module/models/job_application_list_model.dart';

import 'package:palette/modules/student_view/services/student_repository.dart';

class StudentBloc {
  final StudentRepository studentRepo;
  StudentBloc({required this.studentRepo});
  StreamController<CollegeApplicationList> collegeObserver =
      StreamController<CollegeApplicationList>();
  StreamController<JobApplicationListModel> jobObserver =
      StreamController<JobApplicationListModel>();
  StreamController<EventList> eventObserver = StreamController<EventList>();

  Future<CollegeApplicationList> getCollegeInfo(String id) async {
    final list = await studentRepo.getCollegeApplicationList(id);

    return Future.value(list);
  }

  Future<JobApplicationListModel> getJobInfo(String id) async {
    final list = await studentRepo.getJobApplicationList(id);
    return Future.value(list);
  }

  Future<EventList> getEventInfo(String id) async {
    final list = await studentRepo.getEventListApplicationList(id);

    return Future.value(list);
  }
}
