import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/explore_module/models/opp_created_by_me_response.dart';
import 'package:pendo_sdk/pendo_sdk.dart';

class ExplorePendoRepo {
  static trackExploreDetailViewEvent({
    required String eventTitle,
    required String eventType,
    required String eventVenue,
    required String startDate,
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'eventTitle': eventTitle,
      'eventType': eventType,
      'eventVenue': eventVenue,
      'eventStartDate': startDate,
    };

    PendoFlutterPlugin.track(
      'Explore | EventList - ViewDetailsPage - OpenDetailsPage',
      arg,
    );
  }

  static trackExploreOpenWebsiteLinkEvent({
    required String eventTitle,
    required String eventWebsite,
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'eventTitle': eventTitle,
      'eventWebsite': eventWebsite,
    };
    PendoFlutterPlugin.track(
        'Explore | EventDetailPage - ViewEventWebsite - OpenEventWebsite', arg);
  }

  static trackExploreOpenContactNoEvent({
    required String eventTitle,
    required String eventContactNo,
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'eventTitle': eventTitle,
      'eventContactNo': eventContactNo,
    };

    PendoFlutterPlugin.track(
        'Explore | EventDetailPage - ViewEventContactNo - OpenEventContactNo',
        arg);
  }

  static trackExploreWishlistEvent({
    required String eventTitle,
    required bool isEventWishlist,
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'eventTitle': eventTitle,
      'isEventWishlist': isEventWishlist,
    };

    PendoFlutterPlugin.track(
        'Explore | EventDetailPage - Tap on \"Save\" button - Added Opportunity to Consideration',
        arg);
  }

  static trackExploreOpenShareBottomSheetEvent({
    required String eventTitle,
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'eventTitle': eventTitle,
    };
    PendoFlutterPlugin.track(
        'Explore | EventDetailPage - ViewShareStudentList - OpenShareStudentList',
        arg);
  }

  static trackExploreEnrolledEvent({
    required String eventTitle,
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'eventTitle': eventTitle,
    };

    PendoFlutterPlugin.track(
        'Explore | EventDetailPage - Tap on \"Add to To-Do\" button - Added Opportunity to To-Do',
        arg);
  }

  static trackBulkAddOppToTodo({
    required List<String> eventIds,
    required List<String> assigneesIds,
    required bool isSendToProgramSelected,
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'opportunityIds': eventIds,
      'assigneeIds': assigneesIds,
      'isSendToProgramSelected': isSendToProgramSelected
    };

    if (eventIds.length <= 1)
      PendoFlutterPlugin.track(
          'Explore | EventDetailPage - Tap on \"Add to To-Do\" button - Added Opportunity to To-Do',
          arg);
    else
      PendoFlutterPlugin.track(
          'Explore | EventDetailPage - Tap on Bulk \"Add to To-Do\" - Added Bulk Opportunities to To-Do',
          arg);
  }

  static trackBulkAddOppToConsideration({
    required List<String> eventIds,
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'opportunityIds': eventIds
    };

    PendoFlutterPlugin.track(
        'Opportunity | EventDetailPage - Tap on Bulk \"Consider\" button - Added Bulk Opportunity to Consideration',
        arg);
  }

  static trackEditOpportunity({
    required String eventTitle,
    required String eventId,
    required PendoMetaDataState pendoState,
    required String eventScope,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'eventTitle': eventTitle,
      'eventId': eventId,
      'eventScope': eventScope
    };

    PendoFlutterPlugin.track(
        'Explore | EventDetailPage - Edit Discrete Opportunity', arg);
  }

  static trackBulkShareOpp({
    required List<String> eventIds,
    required List<String> assigneesIds,
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'opportunityIds': eventIds,
      'assigneeIds': assigneesIds
    };

    PendoFlutterPlugin.track(
        'Opportunity | OpportunityListPage - Shared Bulk Opportunity to Assignees',
        arg);
  }

  static trackExploreShareEvent({
    required String eventTitle,
    required List studentList,
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'eventTitle': eventTitle,
      'selectedStudentList': studentList,
    };

    PendoFlutterPlugin.track(
        'Explore | EventDetailPage - Recommend Event to Student - ShareEvent',
        arg);
  }

  static trackNavigateBack({
    required String eventTitle,
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'eventTitle': eventTitle,
    };

    PendoFlutterPlugin.track(
        'Explore | EventDetailPage - TapOnBackButton - NavigatedBackToEventListPage',
        arg);
  }

  static trackMyCreationSingleDeactivate({
    required BuildContext context,
    required String id,
    required String type,
    required String? scope,
  }) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    Map<String, dynamic> arg = {
      'oppId': id,
      'oppType': type,
      'oppScope': scope,
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'MyCreations | MyCreationsListScreen - MyCreationSingleDeactivate',
      arg,
    );
  }

  static trackMyCreationSingleHide({
    required BuildContext context,
    required String id,
    required String type,
    required String oppScope,
  }) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    Map<String, dynamic> arg = {
      'oppId': id,
      'oppType': type,
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };
    if (oppScope == 'Global') {
      PendoFlutterPlugin.track(
        'MyCreations | MyCreationsListScreen - MyCreationSingleHideGlobalOpportunity',
        arg,
      );
    } else {
      PendoFlutterPlugin.track(
        'MyCreations | MyCreationsListScreen - MyCreationSingleHideDiscreteOpportunity',
        arg,
      );
    }
  }

  static trackMyCreationBulkDeactivate({
    required List<String> ids,
    required BuildContext context,
  }) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    Map<String, dynamic> arg = {
      'oppIds': ids,
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'MyCreations | MyCreationsListScreen - MyCreationBulkDeactivate',
      arg,
    );
  }

  static trackMyCreationBulkHide({
    required List<String> ids,
    required BuildContext context,
  }) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    Map<String, dynamic> arg = {
      'oppIds': ids,
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'MyCreations | MyCreationsListScreen - MyCreationBulkHide',
      arg,
    );
  }

  static trackBulkShareInMyCreations({
    required List<String> ids,
    required BuildContext context,
  }) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    Map<String, dynamic> arg = {
      'oppIds': ids,
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'MyCreations | MyCreationsListScreen - MyCreationBulkShare',
      arg,
    );
  }

  static trackMyCreationSingleShare({
    required BuildContext context,
    required List<String> oppIds,
    required List<String> assigneesIds,
  }) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'MyCreations | MyCreationsDetailsScreen - MyCreationShare',
      arg,
    );
  }

  static trackCreateOpportunity({
    required String title,
    required String type,
    required PendoMetaDataState pendoState,
    List<String> assignee = const [],
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

    if (isSendToProgramSelectedFlag) {
      PendoFlutterPlugin.track(
        'Opportunity | CreateOpportunityScreen - Tap on Submit button - Request creation of global Opportunity',
        arg,
      );
    } else {
      PendoFlutterPlugin.track(
          'Opportunity | CreateOpportunityScreen - Tap on Submit button - Create Opportunity',
          arg);
    }
  }

  static trackSaveDraftOpportunity({
    required String title,
    required String type,
    required PendoMetaDataState pendoState,
    List<String> assignee = const [],
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

    PendoFlutterPlugin.track(
      'Opportunity | CreateOpportunityScreen - Tap on Save button - Save Draft Opportunity',
      arg,
    );
  }

  static trackViewMyCreationPage({
    required PendoMetaDataState pendoState,
  }) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };
    PendoFlutterPlugin.track(
      'Opportunity | OpportunityMoreOptionsPopUp - Tap on my creations - View My Creation Page',
      arg,
    );
  }

  static trackSearchInMyCreationPage(
      {required PendoMetaDataState pendoState, required String title}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'searchedString': title
    };
    PendoFlutterPlugin.track(
      'MyCreation | MyCreationListScreen - On Enter Search Text- Search in My Creation Page',
      arg,
    );
  }

  static trackViewMyCreationDetailPage(
      {required PendoMetaDataState pendoState,
      required OppCreatedByMeModel oppCreatedByMeObj}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'eventName': oppCreatedByMeObj.eventName,
      'eventType': oppCreatedByMeObj.type,
      'eventStatus': oppCreatedByMeObj.status,
      'eventVisibility': oppCreatedByMeObj.visibility
    };
    PendoFlutterPlugin.track(
      'MyCreation | MyCreationListScreen - Tap on My Creation Item - View My Creation Detail Page',
      arg,
    );
  }

  static trackBulkHideInMyCreationPage(
      {required PendoMetaDataState pendoState,
      required List<String> opportunityIds}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'opportunityIds': opportunityIds
    };
    PendoFlutterPlugin.track(
      'MyCreation | MyCreationListScreen - Tap on Bulk Hide - Bulk Hide In My Creation Page',
      arg,
    );
  }

  static trackBulkRemoveInMyCreationPage(
      {required PendoMetaDataState pendoState,
      required List<String> opportunityIds}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'opportunityIds': opportunityIds
    };
    PendoFlutterPlugin.track(
      'MyCreation | MyCreationListScreen - Tap on Bulk Remove - Bulk Remove In My Creation Page',
      arg,
    );
  }

  static trackMyCreationBulkShare({
    required PendoMetaDataState pendoState,
    required List<String> oppIds,
    required List<String> assigneesIds,
  }) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'opportunityIds': oppIds,
      'assigneesIds': assigneesIds
    };
    PendoFlutterPlugin.track(
      'MyCreation | MyCreationListScreen - Tap on Bulk Share - Bulk Share In My Creation Page',
      arg,
    );
  }

  static trackOpportunityListFilter(
      {required PendoMetaDataState pendoState, required String eventType}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'eventType': eventType
    };
    PendoFlutterPlugin.track(
      'Opportunity | OpportunityListScreen - Tap on Filter Options - Filter in Opportunities Page',
      arg,
    );
  }

  static trackSearchInOpportunity(
      {required PendoMetaDataState pendoState, required String title}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'searchedString': title
    };
    PendoFlutterPlugin.track(
      'Opportunity | OpportunityListScreen - On Enter Search Text- Search in My Opportunity Page',
      arg,
    );
  }
}
