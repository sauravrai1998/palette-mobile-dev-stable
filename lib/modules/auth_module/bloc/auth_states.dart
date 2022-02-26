abstract class AuthState {}

class InitialState extends AuthState {}

class LoginSuccessState extends AuthState {
  // TokensModel tokens;
  //
  // LoginSuccessState({required this.tokens});
}

class LoginLoadingState extends AuthState {}

class LoginFailedState extends AuthState {
  String error;

  LoginFailedState({required this.error});
}

class PreRegisterSuccessState extends AuthState {}

class PreRegisterLoadingState extends AuthState {}

class PreRegisterFailedState extends AuthState {
  String error;

  PreRegisterFailedState({required this.error});
}

class ForgotPasswordSuccessState extends AuthState {}

class ForgotPasswordLoadingState extends AuthState {}

class ForgotPasswordFailedState extends AuthState {
  String error;

  ForgotPasswordFailedState({required this.error});
}

class CheckUserExistSuccessState extends AuthState {}

class CheckUserExistLoadingState extends AuthState {}

class CheckUserExistFailedState extends AuthState {
  String err;

  CheckUserExistFailedState({required this.err});
}
