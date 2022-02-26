import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_version/new_version.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/accept_reject_dialog.dart';
import 'package:palette/common_components/generic_dialog.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/admin_dashboard_module/bloc/student_bloc/admin_student_bloc.dart';
import 'package:palette/modules/admin_dashboard_module/bloc/student_bloc/admin_student_events.dart';
import 'package:palette/modules/auth_module/screens/login_screen.dart';
import 'package:palette/modules/auth_module/services/notification_repository.dart';
import 'package:palette/modules/bottom_navbar/bloc/bottom_navbar_bloc.dart';
import 'package:palette/modules/bottom_navbar/bloc/bottom_navbar_events.dart';
import 'package:palette/modules/bottom_navbar/change_index_bloc/navbar_change_index_bloc.dart';
import 'package:palette/modules/chat_module/screens/chat_history_screen.dart';
import 'package:palette/modules/explore_module/models/explore_list_model.dart';
import 'package:palette/modules/explore_module/models/opportunity_filter_model.dart';
import 'package:palette/modules/explore_module/services/explore_pendo_repo.dart';
import 'package:palette/modules/profile_module/bloc/profile_image_bloc/profile_image_bloc.dart';
import 'package:palette/modules/todo_module/bloc/create_todo_local_save_bloc/create_todo_local_save_bloc.dart';
import 'package:palette/modules/todo_module/bloc/hide_bottom_navbar_bloc/hide_bottom_navbar_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_filter_bloc/todo_filter_bloc.dart';
import 'package:palette/modules/todo_module/models/filter_models.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/screens/todo_details_screen.dart';
import 'package:palette/utils/konstants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pendo_sdk/pendo_sdk.dart';
import 'package:shared_preference_app_group/shared_preference_app_group.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../modules/chat_module/screens/chat_message_screen.dart';
import 'enums.dart';

class Helper {
  static UserType? userType;

  static Size textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  static String getAge({
    required DateTime birthDate,
    required DateTime todaysDate,
  }) {
    Duration dur = DateTime.now().difference(birthDate);
    return (dur.inDays / 365).floor().toString();
  }

  static List<ExploreModel> filterOpportunityListBasedOnEventType(
      {required List<ExploreModel> exploreList,
      required BuildContext context}) {
    List<ExploreModel> filterList = [];
    eventTypeFilterModelList.forEach((filterOption) {
      if (filterOption.isSelected) {
        final filterListBasedOnCurrentFilter = exploreList.where((element) {
          return filterOption.category
              .contains(element.activity?.category ?? '');
        });

        /// Pendo log
        ///
        final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
        ExplorePendoRepo.trackOpportunityListFilter(
          eventType: filterOption.category,
          pendoState: pendoState,
        );
        filterList.addAll(filterListBasedOnCurrentFilter);
      }
    });

    return filterList;
  }

  static List<Todo>? getFilteredTodos({
    required List<FilterCheckboxHeadingModel> filterCheckboxHeadingList,
    required List<Todo> stateTodoList,
    bool byme = false,
    String? currentUserSfid,
  }) {
    List<Todo> localFilterList = [];
    List<Todo> localListedByFilterList = [];
    var triedToFilterButNoRecordsFoundForListedBy = false;
    if (filterCheckboxHeadingList.isNotEmpty) {
      var anyOptionChecked = false;

      filterCheckboxHeadingList.forEach((filterCheckboxOption) {
        switch (filterCheckboxOption.title) {
          case FilterCheckboxOption.Education:
            if (filterCheckboxOption.isCheck) {
              localFilterList.addAll(stateTodoList.where((stateTodo) =>
                  stateTodo.task.type?.toLowerCase().contains('education') ??
                  false));
              anyOptionChecked = true;
            }
            break;
          case FilterCheckboxOption.Employment:
            if (filterCheckboxOption.isCheck) {
              localFilterList.addAll(stateTodoList.where((stateTodo) =>
                  stateTodo.task.type?.toLowerCase().contains('employment') ??
                  false));
              anyOptionChecked = true;
            }
            break;
          case FilterCheckboxOption.Applications:
            if (filterCheckboxOption.isCheck) {
              localFilterList.addAll(stateTodoList.where((stateTodo) =>
                  stateTodo.task.type?.toLowerCase().contains('application') ??
                  false));
              anyOptionChecked = true;
            } else {
              if (filterCheckboxOption.subCategories != null) {
                filterCheckboxOption.subCategories!
                    .forEach((subCategoryOption) {
                  if (subCategoryOption.isCheck &&
                      subCategoryOption.title.toLowerCase().contains('job')) {
                    localFilterList.addAll(stateTodoList.where((stateTodo) =>
                        stateTodo.task.type?.toLowerCase().contains('job') ??
                        false));
                    anyOptionChecked = true;
                  } else if (subCategoryOption.isCheck &&
                      subCategoryOption.title
                          .toLowerCase()
                          .contains('college')) {
                    localFilterList.addAll(stateTodoList.where((stateTodo) =>
                        stateTodo.task.type
                            ?.toLowerCase()
                            .contains('college') ??
                        false));
                    anyOptionChecked = true;
                  }
                });
              }
            }
            break;
          case FilterCheckboxOption.Events:
            if (filterCheckboxOption.isCheck) {
              localFilterList.addAll(stateTodoList.where((stateTodo) =>
                  stateTodo.task.type?.toLowerCase().contains('event') ??
                  false));
              anyOptionChecked = true;
            } else {
              if (filterCheckboxOption.subCategories != null) {
                filterCheckboxOption.subCategories!
                    .forEach((subCategoryOption) {
                  if (subCategoryOption.isCheck &&
                      subCategoryOption.title.toLowerCase().contains('sport')) {
                    localFilterList.addAll(stateTodoList.where((stateTodo) =>
                        stateTodo.task.type?.toLowerCase().contains('sport') ??
                        false));
                    anyOptionChecked = true;
                  } else if (subCategoryOption.isCheck &&
                      subCategoryOption.title
                          .toLowerCase()
                          .contains('social')) {
                    localFilterList.addAll(stateTodoList.where((stateTodo) =>
                        stateTodo.task.type?.toLowerCase().contains('social') ??
                        false));
                    anyOptionChecked = true;
                  } else if (subCategoryOption.isCheck &&
                      subCategoryOption.title
                          .toLowerCase()
                          .contains('volunteer')) {
                    localFilterList.addAll(stateTodoList.where((stateTodo) =>
                        stateTodo.task.type
                            ?.toLowerCase()
                            .contains('volunteer') ??
                        false));
                    anyOptionChecked = true;
                  } else if (subCategoryOption.isCheck &&
                      subCategoryOption.title.toLowerCase().contains('art')) {
                    localFilterList.addAll(stateTodoList.where((stateTodo) =>
                        stateTodo.task.type?.toLowerCase().contains('art') ??
                        false));
                    anyOptionChecked = true;
                  }
                });
              }
            }
            break;

          case FilterCheckboxOption.Other:
            if (filterCheckboxOption.isCheck) {
              localFilterList.addAll(stateTodoList.where((stateTodo) =>
                  stateTodo.task.type?.toLowerCase().contains('other') ??
                  false));
              anyOptionChecked = true;
            }
            break;

          case FilterCheckboxOption.ListedBy:
            if (filterCheckboxOption.isCheck) {
              // localFilterList = stateTodoList;
              filterCheckboxOption.subCategories!.forEach((subCategory) {
                if (subCategory.isCheck) {
                  if (localFilterList.isEmpty) {
                    /// Only listed by option is selected
                    localListedByFilterList.addAll(stateTodoList
                        .where((stateTodo) => stateTodo.task.listedBy.name
                            .contains(subCategory.title))
                        .toList());
                  } else {
                    /// Other options are also selected apart from listed by
                    localListedByFilterList.addAll(localFilterList
                        .where((stateTodo) => stateTodo.task.listedBy.name
                            .contains(subCategory.title))
                        .toList());
                  }
                }
              });
              anyOptionChecked = true;
            } else {
              if (filterCheckboxOption.subCategories != null) {
                filterCheckboxOption.subCategories!.forEach((subCategory) {
                  if (subCategory.isCheck) {
                    print('subcategoryName: ${subCategory.title}');
                    if (localFilterList.isEmpty) {
                      /// Only listed by option is selected
                      localListedByFilterList.addAll(stateTodoList
                          .where((stateTodo) =>
                              stateTodo.task.listedBy.name == subCategory.title)
                          .toList());
                    } else {
                      /// Other options are also selected apart from listed by
                      print(
                        'Other options are also selected apart from listed by',
                      );
                      localListedByFilterList.addAll(localFilterList
                          .where((stateTodo) =>
                              stateTodo.task.listedBy.name == subCategory.title)
                          .toList());
                      if (localListedByFilterList.isEmpty) {
                        triedToFilterButNoRecordsFoundForListedBy = true;
                      }
                    }

                    anyOptionChecked = true;
                  }
                });
              }
            }
            break;
        }
      });

      if (byme) {
        /// By me option selected
        if (localFilterList.isEmpty) {
          /// No filters applied alongside by me
          localListedByFilterList.addAll(stateTodoList
              .where(
                  (stateTodo) => stateTodo.task.listedBy.id == currentUserSfid)
              .toList());
        } else {
          /// Filters applied alongside by me
          localListedByFilterList.addAll(localFilterList
              .where(
                  (stateTodo) => stateTodo.task.listedBy.id == currentUserSfid)
              .toList());
        }
      }

      /// listed by filters applied (works in sync with other filters)
      if (localListedByFilterList.isNotEmpty) return localListedByFilterList;
      if (triedToFilterButNoRecordsFoundForListedBy &&
          localListedByFilterList.isEmpty) return [];

      if (anyOptionChecked) return localFilterList;
    }
  }

  static GenderType getGenderType(int index) {
    switch (index) {
      case 0:
        return GenderType.MALE;
      case 1:
        return GenderType.FEMALE;
      case 2:
        return GenderType.TRANSGENDER;
      case 3:
        return GenderType.OTHERS;
      case 4:
        return GenderType.RATHERNOTSAY;
      default:
        return GenderType.MALE;
    }
  }

  static UserType getUserType(int index) {
    switch (index) {
      case 0:
        return UserType.STUDENT;
      case 1:
        return UserType.PARENT;
      case 2:
        return UserType.ADMINISTRATOR;
      case 3:
        return UserType.OBSERVER;
      case 4:
        return UserType.MENTOR;
      default:
        return UserType.STUDENT;
    }
  }

  static String? getGenderString(GenderType? genderType) {
    if (genderType == null) return null;
    switch (genderType) {
      case GenderType.MALE:
        return 'Male';
      case GenderType.FEMALE:
        return 'Female';
      case GenderType.TRANSGENDER:
        return 'Transgender';
      case GenderType.OTHERS:
        return 'Others';
      case GenderType.RATHERNOTSAY:
        return null;
    }
  }

  static showCustomSnackBar(String message, BuildContext context) {
    showTopSnackBar(
      context,
      TextScaleFactorClamper(
        child: CustomSnackBar.error(
          message: message,
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }

  static showSuccessSnackBar(String message, BuildContext context) {
    showTopSnackBar(
      context,
      TextScaleFactorClamper(
        child: CustomSnackBar.success(
          message: message,
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }

  static showBottomSnackBar(String message, BuildContext context) {
    final snackbar = SnackBar(
      content: Text(message),
      elevation: 2,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.8),
        textColor: Colors.white,
        timeInSecForIosWeb: 1);
  }

  static showGenericDialog({
    String? title,
    required String body,
    required BuildContext context,
    required Function() okAction,
    barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return GenericDialog(
          title: title,
          body: body,
          okAction: okAction,
        );
      },
    );
  }

  static showAcceptRejectDialog({
    String? title,
    required String body,
    required BuildContext context,
    required Function() okAction,
    required Function() cancel,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RejectAcceptDialog(
          title: title,
          body: body,
          okAction: okAction,
          cancel: cancel,
        );
      },
    );
  }

  static Future<bool> isConnectedToInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return true;
    } on SocketException catch (_) {
      return false;
    }
  }

  static String? validateMobile(value) {
    String pattern = r'(^\+[1-9]{1}[0-9]{3,14}$)';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  static bool validateWebSite(String value) {
    String pattern =
        r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-@]+))*$";
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static String? validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter a valid email address';
    else
      return null;
  }

  static Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  static logout({required BuildContext context}) async {
    final prefs = await SharedPreferences.getInstance();
    //String sfuuid = prefs.getString(saleforceUUIDConstant) ?? '';
    //String role = prefs.getString('role').toString();
    //ProfilePendoRepo.trackLogoutEvent(sfuuid: sfuuid, role: role);
    await prefs.setString('accessToken', '');
    if (Platform.isIOS) {
      await SharedPreferenceAppGroup.setAppGroup(iOSAppGroupId);
      await SharedPreferenceAppGroup.setString('accessToken', '');
      await SharedPreferenceAppGroup.setString('role', '');
    }
    await prefs.setString('refreshToken', '');
    await prefs.setString(sfidConstant, '');
    await prefs.setString(saleforceUUIDConstant, '');
    await prefs.setString(profilePictureConstant, '');
    await prefs.clear();
    if (Platform.isAndroid) {
      await _deleteCacheDir();
    }
    await NotificationRepo.instance.removeFcmFromFirestore();
    await FirebaseAuth.instance.signOut();
    final route =
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen());

    eventTypeFilterModelList = freshEventFilterList;

    ///
    BlocProvider.of<BottomNavbarBloc>(context).add(InitialBottomNavbarEvent());
    BlocProvider.of<TodoFilterBlocStudent>(context)
        .add(InitialTodoFilterEvent());
    BlocProvider.of<CreateTodoLocalSaveBloc>(context)
        .add(ClearCreateTodoLocalSaveEvent());
    BlocProvider.of<AdminStudentBloc>(context).add(AdminInitStudentUser());
    BlocProvider.of<TodoFilterBloc>(context).add(TodoFilterListInitialEvent());

    BlocProvider.of<PendoMetaDataBloc>(context).add(PendoClearMetaDataEvent());
    BlocProvider.of<HideNavbarBloc>(context).add(ShowBottomNavbarEvent());

    isTodoListLoadedFirstTime = true;
    isTodoListLoadedFirstTimeForParent = true;
    FlutterAppBadger.updateBadgeCount(0);

    ///Badge Counter Changed
    ///

    Navigator.pushAndRemoveUntil(
      context,
      route,
      (Route<dynamic> route) => false,
    );

    BlocProvider.of<ProfileImageBloc>(context).add(InitialProfileImageEvent());
  }

  static navigateToChatSection(BuildContext context) {
    final route = MaterialPageRoute(
      builder: (_) => ChatHistoryScreen(),
      settings: RouteSettings(
        name: 'ChatHistoryPage',
      ),
    );
    Navigator.push(context, route);
  }

  static String getInitials(String otherUserName) {
    if (otherUserName == '') return '';
    List<String> names = otherUserName.split(" ");
    if (names.length > 2) {
      names = [names[0], names[1]];
    }
    String initials = "";
    names.forEach((word) {
      initials += '${word[0].toUpperCase()}';
    });
    return initials;
  }

  static Future navigateToChatScreenDueToNotifWith({
    required Map<String, dynamic> notifData,
    required BuildContext context,
  }) async {
    if (notifData['room_type'] == 'group') {
      ///
      /// Notif came from group chat...
      ///
      final roomMap = jsonDecode(notifData['group_room']);
      final usersMap = roomMap['users'] as List;

      final users = usersMap.map((userJson) {
        return types.User(
          id: userJson['id'],
          firstName: userJson['first_name'],
          lastName: userJson['last_name'],
        );
      }).toList();

      final room = types.Room(
        id: roomMap['id'],
        type: types.RoomType.group,
        name: roomMap['name'],
        users: users,
      );

      final route = MaterialPageRoute(
        builder: (_) => ChatMessageScreen(
          room: room,
          invokedFromPushNotification: true,
        ),
      );
      await Navigator.push(context, route);

      // Changed bottom nav bar to chat after user comes back from chat message screen (If chat message screen was opened by notif)
      final bloc = context.read<NavBarChangeIndexBloc>();
      bloc.add(NavBarChangeIndexEvent(
        index: 2,
      ));
    } else {
      ///
      /// Notif came from one on one chat...
      ///
      final room = await FirebaseChatCore.instance
          .createRoom(types.User(id: notifData['senderUid']));

      final route = MaterialPageRoute(
        builder: (_) => ChatMessageScreen(
          room: room,
          invokedFromPushNotification: true,
        ),
      );
      await Navigator.push(context, route);

      // Changed bottom nav bar to chat after user comes back from chat message screen (If chat message screen was opened by notif)
      final bloc = context.read<NavBarChangeIndexBloc>();
      bloc.add(NavBarChangeIndexEvent(
        index: 2,
      ));
    }
  }

  static String getFirstWord(String inputString) {
    List<String> wordList = inputString.split(" ");
    if (wordList.isNotEmpty) {
      return wordList[0];
    } else {
      return ' ';
    }
  }

  static navigateToTodoScreenDueToNotifWith(
      {required Map<String, dynamic> todoData, required BuildContext context}) {
    Map<String, dynamic> payload = jsonDecode(todoData['data']);
    final todoJson = payload['todo'];
    final todo = Todo.fromJson(payload);
    String? studentId;
    if (todoJson.containsKey('Assignee')) {
      final assigneeList = todoJson['Assignee'] as List;
      if (assigneeList.isNotEmpty) {
        studentId = assigneeList.first['Id'];
      } else {
        return;
      }
    } else {
      return;
    }

    final route = MaterialPageRoute(
      builder: (_) => TodoDetailsScreen(
        todoItem: todo,
        studentId: studentId!,
      ),
    );
    Navigator.push(context, route);
  }

  static setupPendoSDK() async {
    final prefs = await SharedPreferences.getInstance();
    final sfid = prefs.getString(sfidConstant);
    final sfuuid = prefs.getString(saleforceUUIDConstant);
    final fullName = prefs.getString(fullNameConstant);
    final role = prefs.getString('role');
    final instituteName = prefs.getString(instituteNameKey);

    print('setupPendoSDK');

    String? os;

    final status = await NewVersion().getVersionStatus();
    final appVersion = status?.localVersion;

    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      os = 'Android $release';
      print('Android $release (SDK $sdkInt), $manufacturer $model');
      // Android 9 (SDK 28), Xiaomi Redmi Note 7
    }

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      var model = iosInfo.model;
      os = '$systemName $version';
      print('$systemName $version, $name $model');
      // iOS 13.1, iPhone 11 Pro Max iPhone
    }

    if (sfid == null) {
      final initParams = {
        "visitorId": 'Pre login user',
        "accountId": 'Pre login',
        "visitorData": {
          'persona': 'NA',
          'instituteName': 'NA',
          'os': os,
          'appVersion': appVersion,
          'environment': env
        },
        "accountData": {
          'instituteName': 'NA',
        }
      };
      print('pre-login initParams: $initParams');
      PendoFlutterPlugin.setup(pendoKey, initParams);
    } else {
      final initParams = {
        "visitorId": sfuuid,
        "accountId": instituteName,
        "visitorData": {
          'persona': role,
          'instituteName': instituteName ?? 'NA',
          'os': os,
          'appVersion': appVersion,
          'environment': env,
        },
        "accountData": {
          'instituteName': instituteName ?? 'NA',
        }
      };
      print('initParams: $initParams');
      PendoFlutterPlugin.setup(pendoKey, initParams);
      PendoFlutterPlugin.startSession(sfuuid!, instituteName!, {
        'persona': role,
        'instituteName': instituteName,
        'os': os,
        'appVersion': appVersion,
        'environment': env,
      }, {
        'instituteName': instituteName,
      });
      //PendoFlutterPlugin.initSDK(pendoKey, initParams);
    }
  }
}

class CustomException implements Exception {
  final String message;

  CustomException(this.message);

  @override
  String toString() {
    return message;
  }
}
