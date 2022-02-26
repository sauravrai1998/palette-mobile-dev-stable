import 'package:palette/modules/profile_module/models/user_models/abstract_profile_user_model.dart';

abstract class ThirdPersonState {}

class InitialUserState extends ThirdPersonState {}

class ThirdPersonSuccessState extends ThirdPersonState {
  BaseProfileUserModel profileUser;

  ThirdPersonSuccessState({required this.profileUser});
}

class ThirdPersonFailedState extends ThirdPersonState {
  String error;

  ThirdPersonFailedState({required this.error});
}

class ThirdPersonLoadingState extends ThirdPersonState {}
