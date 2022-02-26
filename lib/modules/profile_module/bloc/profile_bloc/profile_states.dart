import 'package:palette/modules/student_dashboard_module/models/education_data_model.dart';
import 'package:palette/modules/profile_module/models/user_models/abstract_profile_user_model.dart';

abstract class ProfileState {}

class InitialUserState extends ProfileState {}

///
class LinkDataSuccessState extends ProfileState {
  LinkDataSuccessState();
}

class LinkDataFailedState extends ProfileState {}

class LinkDataLoadingState extends ProfileState {}

class GetStudentInitialStage extends ProfileState {}

///
class EducationDataSuccessState extends ProfileState {
  List<EducationData> educationData;

  EducationDataSuccessState({required this.educationData});
}

class EducationDataLoadingState extends ProfileState {}

class EducationDataFailedState extends ProfileState {
  String err;

  EducationDataFailedState({required this.err});
}

/// User Profile Fetching
class ProfileUserSuccessState extends ProfileState {
  BaseProfileUserModel profileUser;

  ProfileUserSuccessState({required this.profileUser});
}

class ProfileUserFailedState extends ProfileState {
  String error;

  ProfileUserFailedState({required this.error});
}

class ProfileUserLoadingState extends ProfileState {}
