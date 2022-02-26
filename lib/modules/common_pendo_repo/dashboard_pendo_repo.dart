import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/utils/konstants.dart';
import 'package:pendo_sdk/pendo_sdk.dart';

class DashboardPendoRepo {
  static trackOnTapStudentEvent({
    required String student,
    required PendoMetaDataState pendoState,
  }) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'studentId': student,
    };

    PendoFlutterPlugin.track(
        'Dashboard | DashboardScreen - Tap on Student - Opens Third Person POV For That Student',
        arg);
  }

  static trackTapOnProfilePictureEvent({required BuildContext buildContext}) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(buildContext).state;

    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
        'Dashboard | DashboardScreen - Tap on Profile Image - Navigate To Profile Screen',
        arg);
  }

  static trackTapOnChatEvent({required BuildContext buildContext}) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(buildContext).state;

    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
        'Chat | ChatSection - NavigateToChatSection',
        arg);
  }

  static trackTapOnStudentTabEvent({required BuildContext context}) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;

    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
        'Dashboard | DashboardScreen - Tap on Students Tab - Display List Of Students',
        arg);
  }

  static trackTapOnMentorsTabEvent({required BuildContext context}) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;

    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'Dashboard | DashboardScreen - Tap on Mentors Tab - Display List Of Mentors',
      arg,
    );
  }
}
