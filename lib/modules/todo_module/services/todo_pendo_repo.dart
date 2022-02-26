import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/utils/konstants.dart';
import 'package:pendo_sdk/pendo_sdk.dart';

class TodoPendoRepo {
  static trackCreateTodoEvent({
    required String title,
    required String type,
    required PendoMetaDataState pendoState,
    List<String> assignee = const [],
    required bool isForOthers,
    required bool isForSelf,
    required bool isSendToProgramSelectedFlag,
  }) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'title': title,
      'type': type,
    };

    if (assignee.isNotEmpty) {
      arg['assignee'] = assignee;
    }

    if (isForSelf) {
      PendoFlutterPlugin.track(
        'Todo | CreateTodoScreen - Tap on Create button - Created todo for self',
        arg,
      );
    }

    if (isSendToProgramSelectedFlag) {
      PendoFlutterPlugin.track(
        'Todo | CreateTodoScreen - Tap on Create button - Request creation of global todo',
        arg,
      );
    } else {
      PendoFlutterPlugin.track(
          'Todo | CreateTodoScreen - Tap on Create button - Create todo task and navigate to Upload resources form',
          arg);
    }
  }

  static trackSaveTodoEvent({
    required String title,
    required String type,
    required PendoMetaDataState pendoState,
    List<String> assignee = const [],
    required bool isForOthers,
    required bool isForSelf,
    required bool isSendToProgramSelectedFlag,
  }) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'title': title,
      'type': type,
    };

    if (assignee.isNotEmpty) {
      arg['assignee'] = assignee;
    }

    if (isForSelf) {
      PendoFlutterPlugin.track(
        'Todo | CreateTodoScreen - Tap on Save button - Created Draft todo for self',
        arg,
      );
    }

    if (isSendToProgramSelectedFlag) {
      PendoFlutterPlugin.track(
        'Todo | CreateTodoScreen - Tap on Save button - Created Draft global todo',
        arg,
      );
    } else {
      PendoFlutterPlugin.track(
          'Todo | CreateTodoScreen - Tap on Save button - Created Draft todo',
          arg);
    }
  }

  static trackEditTodoEvent(
      {required String type,
      required String title,
      required PendoMetaDataState pendoState}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'title': title,
      'type': type,
    };

    // print('pendo edit tødo: $arg');
    PendoFlutterPlugin.track(
        'Todo | EditTodoScreen - Tap on Update button - Upload the updated todo',
        arg);
  }

  static trackTodoAddResourcesEvent({
    required List<Resources> resources,
    required List<String> todoIds,
    required PendoMetaDataState pendoState,
  }) {
    final List<Map> resourcesArray = [];
    resources.forEach((element) {
      resourcesArray.add(element.toJson());
    });

    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'resources': resourcesArray,
      'todoIds': todoIds,
    };

    PendoFlutterPlugin.track(
        'Todo | TodoListScreen - Tap on Upload Resources button - show options for selecting resource type to attach',
        arg);
  }

  static trackTodoStatusChange({
    required String todoId,
    required String status,
    required String todoTitle,
    required String todoType,
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      'todoId': todoId,
      'todoTitle': todoTitle,
      'todoType': todoType,
      'status': status,
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    // print('pendo status change: $arg');
    PendoFlutterPlugin.track(
        'Todo | TodoDetailScreen - Select a status option - Todo Status Change Event',
        arg);
  }

  static trackTodoBulkStatusChange({
    required List<String> todoIds,
    required String status,
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      'todoIds': todoIds,
      'status': status,
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    // print('pendo status change: $arg');
    PendoFlutterPlugin.track(
      'Todo | TodoListScreen - Select a status option - Todo Status Change Event Bulk',
      arg,
    );
  }

  static trackThirdPersonSearch({
    required String thirdPersonSfid,
    required PendoMetaDataState pendoState,
    required String thirdPersonName,
  }) {
    final arg = {
      'thirdPersonSfid': thirdPersonSfid,
      'thirdPersonName': thirdPersonName,
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    // print('pendo status change: $arg');
    PendoFlutterPlugin.track(
      'Todo | TodoListScreenThirdPerson - Search Todo - Tap on Search Button',
      arg,
    );
  }

  static trackTodoSearch({required PendoMetaDataState pendoState}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    // print('pendo status change: $arg');
    PendoFlutterPlugin.track(
      'Todo | TodoListScreen - Search Todo - Tap on Search Button',
      arg,
    );
  }

  static trackAcceptTodoRequest({
    required PendoMetaDataState pendoState,
    required String todoId,
  }) {
    final arg = {
      'todoId': todoId,
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    // print('pendo status change: $arg');
    PendoFlutterPlugin.track(
      'Todo | TodoDetailScreen - Tap on Accept Button - Todo Accept Request',
      arg,
    );
  }

  static trackPublishDraftTodo({
    required PendoMetaDataState pendoState,
    required String todoId,
  }) {
    final arg = {
      'todoId': todoId,
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    // print('pendo status change: $arg');
    PendoFlutterPlugin.track(
      'Todo | TodoDetailScreen - Tap on Publish Button - Publish Draft Todo To Live',
      arg,
    );
  }

  static trackRejectTodoRequest({
    required PendoMetaDataState pendoState,
    required String todoId,
  }) {
    final arg = {
      'todoId': todoId,
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    // print('pendo status change: $arg');
    PendoFlutterPlugin.track(
      'Todo | TodoDetailScreen - Tap on Reject Button - Todo Reject Request',
      arg,
    );
  }

  static trackViewTodoRequests({
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    // print('pendo status change: $arg');
    PendoFlutterPlugin.track(
      'Todo | TodoScreen - Tap on Request Tab - View to-do requests',
      arg,
    );
  }

  ///TODO: add todo detail event
  static trackTodoDetailViewEvent({
    required String status,
    required String todoTitle,
    required String todoType,
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'todoTitle': todoTitle,
      'todoType': todoType,
      'status': status,
    };

    // print('pendo detailView: $arg');
    PendoFlutterPlugin.track(
        'Todo | TodoListScreen - Tap on Any Todo Tile - Todo Detail View Event',
        arg);
  }

  // static trackLoginEvent({required PendoMetaDataState pendoState}) {
  //   final arg = {
  //     visitorIdKey: pendoState.visitorId,
  //
  //     personaTypeKey: pendoState.role,
  //     accountIdKey: pendoState.instituteName,
  //     instituteIdKey: pendoState.instituteId,
  //     instituteName: pendoState.instituteName,
  //   };

  //   print('login event logged');
  //   PendoFlutterPlugin.track('Login Event', arg);
  // }

  static trackFilterDoneEvent({required PendoMetaDataState pendoState}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };
    PendoFlutterPlugin.track(
        'Todo | TodoListScreen - Filter Done button Tapped - Apply selected filter to todo list',
        arg);
  }

  static trackFilterClearEvent({required PendoMetaDataState pendoState}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };
    PendoFlutterPlugin.track(
        'Todo | TodoListScreen - Filter Clear All button Tapped - clear all applied filter options',
        arg);
  }

  static trackTodoSortingEvent(
      {required PendoMetaDataState pendoState, required bool isDescending}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };
    if (isDescending) {
      PendoFlutterPlugin.track(
          'Todo | TodoListScreen - Tap Sorting Button - Sort Todo list in descending order',
          arg);
    } else {
      PendoFlutterPlugin.track(
          'Todo | TodoListScreen - Tap Sorting Button Again - Sort Todo list in Ascending order',
          arg);
    }
  }

  static trackTodoByMeEvent(
      {required PendoMetaDataState pendoState, required bool isByme}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    if (isByme) {
      PendoFlutterPlugin.track(
          'Todo | TodoListScreen - Tap Byme Button - Filter todo created by user',
          arg);
    } else {
      PendoFlutterPlugin.track(
          'Todo | TodoListScreen - Tap Byme Button Again - Remove Byme Filter',
          arg);
    }
  }

  static trackTapOnProfilePictureEvent(
      {required PendoMetaDataState pendoState}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };
    PendoFlutterPlugin.track(
        'Todo | TodoListScreen - Tap on Profile Image - Navigate To Profile Screen',
        arg);
  }

  static trackTapOnChatEvent({required PendoMetaDataState pendoState}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };
    PendoFlutterPlugin.track('Chat | ChatSection - NavigateToChatSection', arg);
  }

  static trackTapOnTodoTabEvent({
    required PendoMetaDataState pendoState,
    required int index,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };
    final desc = [
      'Tap on First tab/ + icon tab - navigate to create new todo form',
      'Tap on All category tab - navigate to All todo type list',
      'Tap on Open category tab - navigate to Open todo type list',
      'Tap on Completed category tab - navigate to Completed todo type list',
      'Tap on Closed category tab - navigate to Closed todo type list'
    ];
    PendoFlutterPlugin.track('Todo | TodoListScreen - ${desc[index]}', arg);
  }

  //MARK: - Todo Detail Screen
  //Todo detail page
  static trackTapOnBackEvent({
    required PendoMetaDataState pendoState,
    required String todoTitle,
    required String todoType,
    required String status,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'todoTitle': todoTitle,
      'todoType': todoType,
      'status': status
    };
    PendoFlutterPlugin.track(
        'Todo | TodoDetailScreen - Tap on Back - Navigate Back to Todo List Screen Event',
        arg);
  }

  static trackTapOnEditTodoEvent(
      {required PendoMetaDataState pendoState,
      required String todoTitle,
      required String todoType,
      required String status}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'todoTitle': todoTitle,
      'todoType': todoType,
      'status': status,
    };

    PendoFlutterPlugin.track(
        'Todo | TodoDetailScreen - Tap on Edit button -  open bottom sheet to edit/update todo',
        arg);
  }
  //trackTapOnUpdateTodoStatusEvent

  static trackTapOnUpdateTodoStatusEvent(
      {required PendoMetaDataState pendoState,
      required String status,
      required String todoTitle,
      required String todoType}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'todoTitle': todoTitle,
      'todoType': todoType,
      'status': status
    };
    PendoFlutterPlugin.track(
        'Todo | TodoDetailScreen - Tap on Status button - Open Bottom Sheet For Update Status',
        arg);
  }

  static trackTapOnDownloadResourcesEvent({
    required PendoMetaDataState pendoState,
    required String todoTitle,
    required String filelink,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'todoTitle': todoTitle,
      'filelink': filelink
    };
    PendoFlutterPlugin.track(
        'Todo | TodoDetailScreen - Tap on Resources File - To Downlod Resources',
        arg);
  }

  static trackTapOnLinkResourcesEvent(
      {required PendoMetaDataState pendoState,
      required String todoTitle,
      required String link}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'todoTitle': todoTitle,
      'link': link,
    };
    PendoFlutterPlugin.track(
        'Todo | TodoDetailScreen - Tap on Resources File - To Downlod Resources',
        arg);
  }

  //Create Todo
  static trackTapOnUploadResourcesEvent(
      {required PendoMetaDataState pendoState}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };
    PendoFlutterPlugin.track(
        'Todo | CreateTodoScreen - Tap on Upload Resources button - show options for selecting resource type to attach',
        arg);
  }

  static trackTapOnAddResourcesEvent(
      {required PendoMetaDataState pendoState,
      required bool isLink,
      required bool isEdit}) {
    String screenName = isEdit ? 'EditTodoScreen' : 'CreateTodoScreen';
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };
    isLink
        ? PendoFlutterPlugin.track(
            'Todo | $screenName - Tap on Link - Add link title and url', arg)
        : PendoFlutterPlugin.track(
            'Todo | $screenName - Tap on Flie - Select file from device and upload',
            arg);
  }

  static trackCreateTodoDoneEvent(
      {required PendoMetaDataState pendoState, required List<String> todoIds}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'todoIds': todoIds,
    };
    PendoFlutterPlugin.track(
        'Todo | CreateTodoScreen - Tap on Done button - Upload attached resources',
        arg);
  }

  //MARK: - Todo Edit/Update Screen

  static trackTapOnDeleteResourceEvent(
      {required PendoMetaDataState pendoState, required String link}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'link': link,
    };
    PendoFlutterPlugin.track(
        'Todo | EditTodoScreen - Tap on cross button on resources - delete resource',
        arg);
  }

  static trackTapOnUpdateLinkEvent(
      {required PendoMetaDataState pendoState, required String link}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'link': link,
    };
    PendoFlutterPlugin.track(
        'Todo | EditTodoScreen - Tap on link container - open bottom sheet to update link',
        arg);
  }

  static trackTapOnCancelLinkEvent({required PendoMetaDataState pendoState}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };
    PendoFlutterPlugin.track(
        'Todo | EditTodoScreen - Tap on cancel button - PopUp Bottom sheet',
        arg);
  }

  static trackTapOnEditLinkEvent(
      {required PendoMetaDataState pendoState, required String link}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'link': link,
    };
    PendoFlutterPlugin.track(
        'Todo | EditTodoScreen - Tap on Edit button - Edit link Event', arg);
  }

  //Tap on trash button - delete link

  static trackTapOnDeleteLinkEvent(
      {required PendoMetaDataState pendoState, required String link}) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'link': link,
    };
    PendoFlutterPlugin.track(
        'Todo | EditTodoScreen - Tap On Trash Button - Delete Link Event', arg);
  }

  static trackTapOnDoneLinkEvent({
    required PendoMetaDataState pendoState,
    required String link,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'link': link,
    };
    PendoFlutterPlugin.track(
        'Todo | EditTodoScreen - Tap On Done Button -  Finish adding link Event',
        arg);
  }
}
