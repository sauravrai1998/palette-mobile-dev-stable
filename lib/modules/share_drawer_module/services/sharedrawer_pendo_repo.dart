import 'package:palette/utils/konstants.dart';
import 'package:pendo_sdk/pendo_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareDrawerPendoRepo {
  static Future<UserInfoModelForPendo> fetchUserInfo() async {
   final prefs = await SharedPreferences.getInstance();
   return UserInfoModelForPendo(
     instituteId: prefs.getString(instituteIdKey) ?? '',
     instituteName: prefs.getString(instituteNameKey) ?? '',
     role: prefs.getString('role') ?? '',
     visitorId:  prefs.getString(sfidConstant) ?? '',
   );
  }

  static trackCreateDiscreteOpp({required UserInfoModelForPendo pendoState}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'Share Drawer | Create Discrete Opportunity',
      arg,
    );
  }

  static trackCreateGlobalOpp({required UserInfoModelForPendo pendoState}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'Share Drawer | Create Global Opportunity',
      arg,
    );
  }

   static trackSaveDiscreteOpp({required UserInfoModelForPendo pendoState}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'Share Drawer | Save Discrete Opportunity',
      arg,
    );
  }

  static trackSaveGlobalOpp({required UserInfoModelForPendo pendoState}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'Share Drawer | Save Global Opportunity',
      arg,
    );
  }

  static trackCreateTodo({required UserInfoModelForPendo pendoState}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'Share Drawer | Create Todo',
      arg,
    );
  }

  static trackCreateGlobalTodo({required UserInfoModelForPendo pendoState}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'Share Drawer | Create Global Todo',
      arg,
    );
  }

  static trackSendMessage({required UserInfoModelForPendo pendoState}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'Share Drawer | Send Message',
      arg,
    );
  }
}

class UserInfoModelForPendo {
  final String visitorId;
  final String role;
  final String instituteName;
  final String instituteId;

  UserInfoModelForPendo({
    required this.visitorId,
    required this.role,
    required this.instituteName,
    required this.instituteId,
  });
}
