import 'dart:async';
import 'package:palette/modules/explore_module/models/submit_response.dart';

import 'package:palette/modules/explore_module/models/student_list_response.dart';
import 'package:palette/modules/student_recommendation_module/models/user_models/user_share_list_response.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_repository.dart';

class ConsiderationDetailBloc {
  final RecommendRepository recommendRepo;

  ConsiderationDetailBloc({required this.recommendRepo});

  StreamController<List<ShareUserByInstitute>> userListObserver =
  StreamController<List<ShareUserByInstitute>>.broadcast();
  StreamController<SubmitResponse> submitResponse =
  StreamController<SubmitResponse>.broadcast();


  List<ShareUserByInstitute> studentList = [];

  Future<List<ShareUserByInstitute>> getUserList(
      {required String eventId}) async {
    try {
      final response =
    await recommendRepo.getUserListToShare(eventId: eventId);
    studentList = response.modelList!;
    userListObserver.sink.add(response.modelList!);
    return Future.value(response.modelList);
    }
    catch(error){
      userListObserver.sink.addError(error);
      print(error);
      return Future.error(error);
    }
  }

  Future<SubmitResponse> recommendConsiderationToUsers(
      Map<String, dynamic> map) async {
    final response = await recommendRepo.recommendedEventsToUsers(map);
    submitResponse.sink.add(response);
    return Future.value(response);
  }

  void dispose() {

    userListObserver.close();
    submitResponse.close();
  }
}
