// import 'dart:async';
// import 'package:palette/modules/explore_module/models/submit_response.dart';

// import 'package:palette/modules/explore_module/models/student_list_response.dart';
// import 'package:palette/modules/student_recommendation_module/models/user_models/user_share_list_response.dart';
// import 'package:palette/modules/student_recommendation_module/services/recommendation_repository.dart';

// class ConsiderationBulkShareBloc {
//   final RecommendRepository recommendRepo;

//   ConsiderationBulkShareBloc({required this.recommendRepo});

//   StreamController<List<ShareUserByInstitute>> userListObserver =
//   StreamController<List<ShareUserByInstitute>>.broadcast();

//   StreamController<SubmitResponse> submitResponse =
//   StreamController<SubmitResponse>.broadcast();


//   List<ShareUserByInstitute> studentList = [];

//   Future<List<ShareUserByInstitute>> getUserList(
//       ) async {
//     final response =
//     await recommendRepo.getUserListToShareBulkConsideration();
//     studentList = response.modelList!;
//     userListObserver.sink.add(response.modelList!);
//     return Future.value(response.modelList);
//   }

  

//   void dispose() {

//     userListObserver.close();
//     submitResponse.close();
//   }
// }
