import 'dart:async';

import 'package:palette/modules/explore_module/models/explore_list_model.dart';
import 'package:palette/modules/explore_module/models/institute_list.dart';
import 'package:palette/modules/explore_module/services/explore_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExploreListBloc {
  final ExploreRepository exploreRepo;
  ExploreListBloc({required this.exploreRepo});
  StreamController<List<ExploreModel>> exploreListObserver =
      StreamController<List<ExploreModel>>.broadcast();
  List<ExploreModel>? mainActivityList = [];

  Future<ExploreListModel> getExploreList() async {
    try {
      final list = await exploreRepo.getExploreData();
      mainActivityList = list.exploreList;
      exploreListObserver.sink.add(mainActivityList ?? []);
      print(list);
      return Future.value(list);
    } catch (e) {
      exploreListObserver.sink.add([]);
      return Future.value(null);
    }
  }

  StreamController<List<Institute>> instituteListObserver =
      StreamController<List<Institute>>.broadcast();

  Future<List<Institute>> getInstituteListByParents() async {
    final list = await exploreRepo.getInstituteListByParents();
    list.modelList!.insert(0, Institute.fromJson({"Name": "All", "Id": null}));
    instituteListObserver.sink.add(list.modelList ?? []);
    return Future.value(list.modelList);
  }

  Future<List<ExploreModel>> getActivityListByParents(String id) async {
    final list = await exploreRepo.getActivityListByParents(id);
    mainActivityList = list.exploreList;
    exploreListObserver.sink.add(list.exploreList!);
    return Future.value(list.exploreList);
  }

  Future<List<ExploreModel>> getAllActivitiesList() async {
    final list = await exploreRepo.getAllActivitiesData();
    mainActivityList = list.exploreList;
    exploreListObserver.sink.add(list.exploreList!);
    return Future.value(list.exploreList);
  }

  Future<String> getPathForRegister() async {
    final prefs = await SharedPreferences.getInstance();
    final String role = prefs.getString('role').toString();
    if (role == "Student") {
      return 'Student';
    } else if (role == "Observer") {
      return 'Observer';
    } else if (role == "Advisor" || role.toLowerCase() == "faculty/staff") {
      return 'Advisor';
    } else if (role == "Admin" || role.toLowerCase() == "admin") {
      return 'Admin';
    } else {
      return 'Parent';
    }
  }

  void dispose() {
    exploreListObserver.close();
    instituteListObserver.close();
  }
}
