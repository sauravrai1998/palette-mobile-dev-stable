import 'package:palette/modules/profile_module/models/user_models/abstract_profile_user_model.dart';

abstract class RefreshProfileState {}

class RefreshProfileScreenInitialState extends RefreshProfileState {}

class RefreshProfileScreenLoadingState extends RefreshProfileState {}

class RefreshProfileScreenSuccessState extends RefreshProfileState {
  BaseProfileUserModel profileUser;

  RefreshProfileScreenSuccessState({required this.profileUser});
}

class RefreshProfileScreenFailedState extends RefreshProfileState {
  String error;

  RefreshProfileScreenFailedState({required this.error});
}

class SkillsInterestActivitiesSuccessState extends RefreshProfileState {}

class SkillsInterestActivitiesLoadingState extends RefreshProfileState {}

class SkillsInterestActivitiesFailedState extends RefreshProfileState {
  String err;

  SkillsInterestActivitiesFailedState({required this.err});
}
