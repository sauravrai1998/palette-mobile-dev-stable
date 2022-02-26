import 'dart:developer';
import 'dart:io';

import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_repos/navigator_service.dart';
import 'package:palette/modules/auth_module/screens/splash_screen.dart';
import 'package:palette/modules/share_drawer_module/screens/share_create_opportunity_screens/share_create_opportunity_form.dart';
import 'package:palette/modules/share_drawer_module/screens/share_create_todo/share_create_todo.dart';
import 'package:palette/modules/share_drawer_module/screens/share_send_chat/share_send_chat.dart';
import 'package:shared_preference_app_group/shared_preference_app_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareDrawerNavigationRepo {
  static ShareDrawerNavigationRepo instance = ShareDrawerNavigationRepo();

  Future<void> clearUserDefaults() async {
    await SharedPreferenceAppGroup.setAppGroup(iOSAppGroupId);
    SharedPreferenceAppGroup.setString(sharedURLString, '');
    SharedPreferenceAppGroup.setString(shareDrawerNavigateKey, '');
  }

  Future<void> navigateToShare({required BuildContext context}) async {
    await SharedPreferenceAppGroup.setAppGroup(iOSAppGroupId);
    String sharedUrl = "";
    SharedPreferenceAppGroup.get(sharedURLString).then((value) {
      sharedUrl = value;
    });
    SharedPreferenceAppGroup.get(shareDrawerNavigateKey).then((value) {
      if (value == 'opportunity') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ShareCreateOpportunityForm(urlLink: sharedUrl)));
      } else if (value == 'todo') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ShareCreateTodoForm(urlLink: sharedUrl)));
      } else if (value == 'chat') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ShareSendChatPage(urlLink: sharedUrl)));
      } else {
        return;
      }
    });
  }
   Future<void> shareDrawerNavigationForiOS({required BuildContext context}) async {
    if (Platform.isIOS) {
      await SharedPreferenceAppGroup.setAppGroup(iOSAppGroupId);
      String sharedUrl = "";
      SharedPreferenceAppGroup.get(sharedURLString).then((value) async {
        sharedUrl = value;
        log("sharedUrl: $sharedUrl");
        if (sharedUrl == "") {
          return;
        } else {
          final prefs = await SharedPreferences.getInstance();
          final accessToken = prefs.getString('accessToken');
          if (accessToken != null && accessToken != '') {
            final sharedrawerServices = ShareDrawerNavigationRepo.instance;
            sharedrawerServices
                .navigateToShare(
                    context: context)
                .then((value) {
              sharedrawerServices.clearUserDefaults();
            });
          } else {
            final sharedrawerServices = ShareDrawerNavigationRepo.instance;
            sharedrawerServices.clearUserDefaults();
          }
        }
      });
    }
  }
  void shareDrawerNavigationAfterSuccess({required BuildContext context}) {
    // if (Navigator.canPop(context)) {
    //   Navigator.pop(context);
    // } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SplashScreen()));
    //}
  }
}
