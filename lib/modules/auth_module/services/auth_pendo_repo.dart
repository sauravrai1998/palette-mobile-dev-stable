import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:pendo_sdk/pendo_sdk.dart';

class AuthPendoRepo {
  static trackForgotPasswordEvent(
      {required BuildContext context, required String userEmail}) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId != '' ? pendoState.visitorId : 'NA',
      personaTypeKey: pendoState.role != '' ? pendoState.role : 'NA',
      accountIdKey: pendoState.accountId != '' ? pendoState.accountId : 'NA',
      instituteIdKey:
          pendoState.instituteId != '' ? pendoState.instituteId : 'NA',
      instituteNameKey:
          pendoState.instituteName != '' ? pendoState.instituteName : 'NA',
      'email': userEmail
    };
    print(arg);
    PendoFlutterPlugin.track(
      'Auth | ForgotPasswordScreen - Tap on Reset Password - Email Sent For Resetting Password',
      arg,
    );
  }

  static trackUserExistEvent(
      {required BuildContext context,
      required String userEmail,
      required String role}) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId != '' ? pendoState.visitorId : 'NA',
      personaTypeKey: pendoState.role != '' ? pendoState.role : 'NA',
      accountIdKey: pendoState.accountId != '' ? pendoState.accountId : 'NA',
      instituteIdKey:
          pendoState.instituteId != '' ? pendoState.instituteId : 'NA',
      instituteNameKey:
          pendoState.instituteName != '' ? pendoState.instituteName : 'NA',
      'email': userEmail
    };

    PendoFlutterPlugin.track(
      'Auth | CheckUserExistingScreen - Tap on Continue - Check If User Already Exist',
      arg,
    );
  }

  static trackNewUserRegisterEvent(
      {required BuildContext context,
      required String userEmail,
      required String role}) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'email': userEmail,
    };

    PendoFlutterPlugin.track(
      'Auth | NewUserRegisterScreen - Tap on Register - New User Registeration',
      arg,
    );
  }
}
