import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:pendo_sdk/pendo_sdk.dart';

class CommonPendoRepo {
  static trackTodoListScreenVisit({required BuildContext context}) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;

    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'Todo | TodoListScreen - NavigateToTodoListScreen',
      arg,
    );
  }

  static trackChatSectionVisit({required BuildContext context}) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;

    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'Chat | ChatSection - NavigateToChatSection',
      arg,
    );
  }

  static trackRecommendationScreenVisit({required BuildContext context}) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;

    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'Recommendation | RecommendationScreen - NavigateToRecommendationScreen',
      arg,
    );
  }

  static trackExploreScreenVisit({required BuildContext context}) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;

    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'Explore | ExploreScreen - NavigateToExploreScreen',
      arg,
    );
  }

  static trackResourceCenterGuide(
      {required PendoMetaDataState pendoState,
      required String eventName}) async {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      eventName,
      arg,
    );
  }

  static trackTapOnNotification({
    required PendoMetaDataState pendoState,
  }) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'Dashboard | NotificationScreen - Tap on notification icon - Opens Notification screen',
      arg,
    );
  }
}
