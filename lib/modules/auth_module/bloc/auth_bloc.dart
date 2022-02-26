import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/auth_module/bloc/auth_events.dart';
import 'package:palette/modules/auth_module/bloc/auth_states.dart';
import 'package:palette/modules/auth_module/models/uid_sfid_mapping_request.dart';
import 'package:palette/modules/auth_module/services/auth_repository.dart';
import 'package:palette/modules/auth_module/services/firebase_auth_repo.dart';
import 'package:palette/modules/auth_module/services/notification_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepo;
  final FirebaseAuthRepo firebaseAuthRepo;
  final NotificationRepo notificationRepo;

  AuthBloc({
    required this.authRepo,
    required this.firebaseAuthRepo,
    required this.notificationRepo,
  }) : super((InitialState()));

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    yield InitialState();
    if (event is LoginEvent) {
      yield LoginLoadingState();
      try {
        await authRepo.loginUser(event.loginData);
        await firebaseAuthRepo.loginFirebase(
          event.loginData.email,
          event.loginData.password,
        );
        await notificationRepo.addFcmToFirestore();
        yield LoginSuccessState();
      } catch (e) {
        yield LoginFailedState(error: e.toString());
      }
    } else if (event is PreRegisterEvent) {
      yield PreRegisterLoadingState();
      try {
        final preRegisterResponse =
            await authRepo.preRegister(event.registerData);

        final uid = await firebaseAuthRepo.createAccountFirebase(
          event.registerData.email,
          event.registerData.password,
          preRegisterResponse.data.firstName,
          preRegisterResponse.data.lastName,
        );

        await authRepo.postFirebaseUidMapping(
          UidSFidMappingRequest(
            sfId: preRegisterResponse.data.sfId,
            uuid: uid,
            email: event.registerData.email,
          ),
        );
        yield PreRegisterSuccessState();
      } catch (e) {
        yield PreRegisterFailedState(error: e.toString());
      }
    } else if (event is ForgotPasswordEvent) {
      yield ForgotPasswordLoadingState();
      try {
        await authRepo.forgotPassword(event.email);
        yield ForgotPasswordSuccessState();
      } catch (e) {
        print(e.toString());
        yield ForgotPasswordFailedState(error: e.toString());
      }
    } else if (event is CheckUserExistsEvent) {
      yield CheckUserExistLoadingState();
      try {
        await authRepo.checkUserExist(event.email);
        yield CheckUserExistSuccessState();
      } catch (e) {
        yield CheckUserExistFailedState(err: e.toString());
      }
    }
  }
}
