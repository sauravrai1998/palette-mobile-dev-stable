import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_repos/common_intent_service.dart';
import 'package:palette/modules/admin_dashboard_module/screens/admin_dashboard_navbar.dart';
import 'package:palette/modules/advisor_dashboard_module/screens/advisor_dashboard_with_navbar.dart';
import 'package:palette/modules/auth_module/screens/login_screen.dart';
import 'package:palette/modules/chat_module/services/chat_pendo_repo.dart';
import 'package:palette/modules/chat_module/services/chat_repository.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/observer_dashboard_module/screens/observer_dashboard_navbar.dart';
import 'package:palette/modules/parent_dashboard_module/screens/parent_dashboard_with_navbar.dart';
import 'package:palette/modules/profile_module/models/user_models/abstract_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/admin_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/advisor_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/observer_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/parent_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/student_profile_user_model.dart';
import 'package:palette/modules/profile_module/services/profile_repository.dart';
import 'package:palette/modules/share_drawer_module/services/sharedrawer_navigation_repo.dart';
import 'package:palette/modules/todo_module/screens/student_dashboard_with_navbar.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:pendo_sdk/pendo_sdk.dart';
import 'package:shared_preference_app_group/shared_preference_app_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    checkAccessibility();
    fetchProfileUser();
    _fetchChatContactsForPendoRepo();
  }

  BaseProfileUserModel? _baseProfileUserModel;

  navigateNext() async {
    if (await isLoggedIn()) {
      BlocProvider.of<GetContactsBloc>(context).add(GetContactsEvent());
      PendoFlutterPlugin.track('Splash Screen - App Launch', {});
    } else {
      PendoFlutterPlugin.track('Pre-login | App Launch', {});
    }
    if (await isLoggedIn()) {
      print('Already logged in');
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString('role');
      print('splash Screen role : $role');
      if (role == "Student") {
        final student = _baseProfileUserModel as StudentProfileUserModel?;
        final instituteName = student?.educationList?.isNotEmpty ?? false
            ? student?.educationList?.first.instituteName ?? ''
            : '';
        final instituteLogo = student?.educationList?.isNotEmpty ?? false
            ? student?.educationList?.first.instituteLogo ?? ''
            : '';
        if (student != null) {
          prefs.setString(instituteNameKey, instituteName);
          prefs.setString(instituteLogoKey, instituteLogo);
          prefs.setString(sfidConstant, student.id);
          prefs.setString(profilePictureConstant, student.profilePicture ?? '');
        }
        final pendoMetaDataBloc = BlocProvider.of<PendoMetaDataBloc>(context);
        pendoMetaDataBloc.add(PendoMetaDataWithValuesEvent(
          visitorId: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
          accountId: student?.id ?? '',
          name: student?.name ?? '',
          instituteName: instituteName,
          instituteId: student?.educationList?.isNotEmpty ?? false
              ? student?.educationList?.first.instituteId ?? ''
              : '',
          instituteLogo: instituteLogo,
          role: 'Student',
        ));

        await Helper.setupPendoSDK();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StudentDashboardWithNavbar(student: student),
              settings: RouteSettings(
                name: 'DashboardNavBar',
              ),
            ),
            (Route<dynamic> route) => false);
      } else if (role == "Observer") {
        final observer = _baseProfileUserModel as ObserverProfileUserModel?;
        final instituteName = observer?.instituteList?.isNotEmpty ?? false
            ? observer?.instituteList?.first.instituteName ?? ''
            : '';
        final instituteLogo = observer?.instituteList?.isNotEmpty ?? false
            ? observer?.instituteList?.first.instituteLogo ?? ''
            : '';
        if (observer != null) {
          prefs.setString(sfidConstant, observer.id);
          prefs.setString(instituteNameKey, instituteName);
          prefs.setString(
              profilePictureConstant, observer.profilePicture ?? '');
          prefs.setString(instituteLogoKey, instituteLogo);
        }

        final pendoMetaDataBloc = BlocProvider.of<PendoMetaDataBloc>(context);
        pendoMetaDataBloc.add(PendoMetaDataWithValuesEvent(
          visitorId: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
          accountId: observer?.id ?? '',
          name: observer?.name ?? '',
          instituteName: instituteName,
          instituteId: observer?.instituteList?.isNotEmpty ?? false
              ? observer?.instituteList?.first.instituteId ?? ''
              : '',
          instituteLogo: instituteLogo,
          role: 'Observer',
        ));

        await Helper.setupPendoSDK();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ObserverDashboardWithNavbar(
                observer: observer,
              ),
              settings: RouteSettings(
                name: 'DashboardNavBar',
              ),
            ),
            (Route<dynamic> route) => false);
      } else if (role == "Advisor" || role?.toLowerCase() == "faculty/staff") {
        final advisor = _baseProfileUserModel as AdvisorProfileUserModel?;

        if (advisor != null) {
          prefs.setString(sfidConstant, advisor.id);
          prefs.setString(instituteNameKey, advisor.instituteName ?? '');
          prefs.setString(instituteLogoKey, advisor.instituteLogo ?? '');
          prefs.setString(profilePictureConstant, advisor.profilePicture ?? '');
        }

        final pendoMetaDataBloc = BlocProvider.of<PendoMetaDataBloc>(context);
        pendoMetaDataBloc.add(PendoMetaDataWithValuesEvent(
          visitorId: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
          accountId: advisor?.id ?? '',
          name: advisor?.name ?? '',
          instituteName: advisor?.instituteName ?? '',
          instituteId: advisor?.instituteId ?? '',
          instituteLogo: advisor?.instituteLogo ?? '',
          role: 'Advisor',
        ));

        await Helper.setupPendoSDK();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AdvisorDashboardWithNavbar(advisor: advisor),
              settings: RouteSettings(
                name: 'DashboardNavBar',
              ),
            ),
            (Route<dynamic> route) => false);
      } else if (role == "Admin") {
        final admin = _baseProfileUserModel as AdminProfileUserModel?;

        if (admin != null) {
          prefs.setString(sfidConstant, admin.id);
          prefs.setString(instituteNameKey, admin.instituteName ?? '');
          prefs.setString(instituteLogoKey, admin.instituteLogo ?? '');
          prefs.setString(profilePictureConstant, admin.profilePicture ?? '');
        }

        final pendoMetaDataBloc = BlocProvider.of<PendoMetaDataBloc>(context);
        pendoMetaDataBloc.add(PendoMetaDataWithValuesEvent(
          visitorId: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
          accountId: admin?.id ?? '',
          name: admin?.name ?? '',
          instituteName: admin?.instituteName ?? '',
          instituteId: admin?.instituteId ?? '',
          instituteLogo: admin?.instituteLogo ?? '',
          role: 'Admin',
        ));

        await Helper.setupPendoSDK();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => AdminDashboardWithNavbar(admin: admin),
              settings: RouteSettings(
                name: 'DashboardNavBar',
              ),
            ),
            (Route<dynamic> route) => false);
      } else {
        final parent = _baseProfileUserModel as ParentProfileUserModel?;

        if (parent != null) {
          prefs.setString(instituteNameKey, parent.instituteName ?? '');
          prefs.setString(instituteLogoKey, parent.instituteLogo ?? '');
          prefs.setString(sfidConstant, parent.id);
        }

        final pendoMetaDataBloc = BlocProvider.of<PendoMetaDataBloc>(context);
        pendoMetaDataBloc.add(PendoMetaDataWithValuesEvent(
          visitorId: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
          accountId: parent?.id ?? '',
          name: parent?.name ?? '',
          instituteName: parent?.instituteName ?? '',
          instituteId: parent?.instituteId ?? '',
          instituteLogo: parent?.instituteLogo ?? '',
          role: 'Parent',
        ));

        await Helper.setupPendoSDK();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ParentDashboardWithNavbar(parent: parent),
              settings: RouteSettings(
                name: 'DashboardNavBar',
              ),
            ),
            (Route<dynamic> route) => false);
      }

      /// Show screen if logged in
    } else {
      print('Not logged in');
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 650),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return LoginScreen();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return Align(
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
      );
      // Navigator.of(context).pushReplacement(
      //     CupertinoPageRoute(builder: (BuildContext context) => LoginScreen()));

      /// Show login page
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('token: $accessToken');
    if (accessToken != null && accessToken != '') {
      return true;
    } else {
      return false;
    }
  }

  void checkAccessibility() async {
    final prefs = await SharedPreferences.getInstance();
    final mediaQueryData = MediaQuery.of(context);

    if (mediaQueryData.accessibleNavigation) {
      prefs.setBool('screen_reader', true);
    } else {
      prefs.setBool('screen_reader', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: Container(
            child: Hero(
              tag: 'logo',
              child: SvgPicture.asset(
                'images/paletteimage.svg',
                height: devHeight * 0.3,
                width: devWidth * 0.3,
              ),
            ),
          ))),
    );
  }

  Future fetchProfileUser() async {
    try {
      _baseProfileUserModel = await ProfileRepository.instance.getProfileUser();
    } catch (e) {
      print(e.toString());
    }
    if (Platform.isAndroid) {
      BlocProvider.of<GetContactsBloc>(context).add(GetContactsEvent());
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        CommonIntentService().handleIntentService();
      });
      CommonIntentService.getInitialText().then((value) {
        if (value == null) {
          navigateNext();
        } else {
          CommonIntentService().showUi(context, value);
        }
      });
    } else if (Platform.isIOS) {
      SharedPreferenceAppGroup.setAppGroup(iOSAppGroupId);
      String sharedUrl = "";
      SharedPreferenceAppGroup.get(sharedURLString).then((value) async {
        sharedUrl = value;
        log("sharedUrl: $sharedUrl");
        if (sharedUrl == "" || value == null) {
          navigateNext();
        } else {
          SharedPreferenceAppGroup.get(shareDrawerNavigateKey)
              .then((value) async {
            if (value == null || value == "") {
              navigateNext();
            } else {
              final prefs = await SharedPreferences.getInstance();
              final accessToken = prefs.getString('accessToken');
              if (accessToken != null && accessToken != '') {
                BlocProvider.of<GetContactsBloc>(context)
                    .add(GetContactsEvent());
                final sharedrawerServices = ShareDrawerNavigationRepo.instance;
                sharedrawerServices
                    .navigateToShare(context: context)
                    .then((value) {
                  sharedrawerServices.clearUserDefaults();
                });
              } else {
                navigateNext();
                final sharedrawerServices = ShareDrawerNavigationRepo.instance;
                sharedrawerServices.clearUserDefaults();
              }
            }
          });
        }
      });
    } else {
      navigateNext();
    }
  }

  Future _fetchChatContactsForPendoRepo() async {
    final chatContactList = await ChatRepository.instance.getChatContactList();
    ChatPendoRepo.chatContacts = chatContactList;
  }
}
