import 'package:palette/modules/auth_module/models/login_model.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  LoginModel loginData;

  LoginEvent({required this.loginData});
}

class PreRegisterEvent extends AuthEvent {
  LoginModel registerData;

  PreRegisterEvent({required this.registerData});
}

class ForgotPasswordEvent extends AuthEvent {
  String email;

  ForgotPasswordEvent({required this.email});
}

class CheckUserExistsEvent extends AuthEvent {
  String email;

  CheckUserExistsEvent({required this.email});
}
