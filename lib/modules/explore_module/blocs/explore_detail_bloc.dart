import 'dart:async';
import 'package:palette/modules/explore_module/models/submit_response.dart';
import 'package:palette/modules/explore_module/models/student_list_response.dart';
import 'package:palette/modules/explore_module/services/explore_repository.dart';

class ExploreDetailBloc {
  final ExploreRepository exploreRepo;

  ExploreDetailBloc({required this.exploreRepo});
  StreamController<dynamic> createTodoObserver =
      StreamController<dynamic>.broadcast();
  StreamController<List<StudentByInstitute>> studentListObserver =
      StreamController<List<StudentByInstitute>>.broadcast();
  StreamController<SubmitResponse> submitResponse =
      StreamController<SubmitResponse>.broadcast();

  List<StudentByInstitute> studentList = [];
  Future<SubmitResponse> createStudentEvent(
      String eventId, String listedBy) async {
    final response = await exploreRepo.saveTodo(eventId, listedBy);

    if (response is SubmitResponse) {
      createTodoObserver.sink.add(response);
    } else {
      createTodoObserver.sink.add(null);
    }
    return Future.value(response);
  }

  Future<List<StudentByInstitute>> getUsersListShareOpp(
      {required String eventId}) async {
    try {
      final response =
        await exploreRepo.getUsersToShareOpportunity(eventId: eventId);
    studentList = response.modelList!;
    studentListObserver.sink.add(response.modelList!);
    return Future.value(response.modelList);
    } catch (e) {
      studentListObserver.sink.addError(e);
      return Future.error(e);
    }
  }

  Future<SubmitResponse> recommendActivitiesToStudents(
      Map<String, dynamic> map) async {
    // final response = await exploreRepo.recommendedEventsByParent(map);
    final response = await exploreRepo.shareOpportunity(map);
    submitResponse.sink.add(response);
    return Future.value(response);
  }

  void dispose() {
    createTodoObserver.close();
    studentListObserver.close();
    submitResponse.close();
  }
}
