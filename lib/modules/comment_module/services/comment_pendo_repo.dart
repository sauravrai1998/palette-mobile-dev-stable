import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:pendo_sdk/pendo_sdk.dart';

class CommentPendoRepo {

  static trackViewCommentBottomSheet({
    required PendoMetaDataState pendoState,
    required String eventId,
    required String commentOn,
  }) async {
    final arg = {
      'eventId': eventId,
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    if(commentOn == "OpportunityRequest") {
      PendoFlutterPlugin.track(
        'NotificationModule | NotificationApprovalDetailScreen - View Comments on Opportunity Approval Requests',
        arg,
      );
    }
    else if (commentOn == "TodoRequest") {
      PendoFlutterPlugin.track(
        'NotificationModule | NotificationApprovalDetailScreen - View Comments on To-Do Approval Requests',
        arg,
      );
    }
    else if (commentOn == "MyCreation") {
      PendoFlutterPlugin.track(
        'MyCreation | MyCreationDetailScreen - View Comments on MyCreation Event',
        arg,
      );
    }
    else if (commentOn == "Opportunity") {
      PendoFlutterPlugin.track(
        'Opportunity | OpportunityDetailScreen - View Comments on Opportunity',
        arg,
      );
    }
    else {
      PendoFlutterPlugin.track(
        'Consideration | ConsiderationDetailScreen - View Comments on Considered Event',
        arg,
      );
    }
  }
  static trackSendComment({
    required PendoMetaDataState pendoState,
    required String eventId,
    required String commentType,
    required String commentOn,
  }) async {
    final arg = {
      'eventId': eventId,
      'commentType': commentType,
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };
    if(commentOn == "OpportunityRequest") {
      PendoFlutterPlugin.track(
        'NotificationModule | NotificationApprovalDetailScreen - Comment on Opportunity Approval Requests',
        arg,
      );
    }
    else if (commentOn == "TodoRequest") {
      PendoFlutterPlugin.track(
        'NotificationModule | NotificationApprovalDetailScreen - Comment on To-Do Approval Requests',
        arg,
      );
    }
    else if (commentOn == "MyCreation") {
      PendoFlutterPlugin.track(
        'MyCreation | MyCreationDetailScreen - Comment on MyCreation Event',
        arg,
      );
    }
    else if (commentOn == "Opportunity") {
      PendoFlutterPlugin.track(
        'Opportunity | OpportunityDetailScreen - Comment on Opportunity',
        arg,
      );
    }
    else {
      PendoFlutterPlugin.track(
        'Consideration | ConsiderationDetailScreen - Comment on Considered Event',
        arg,
      );
    }
  }

}
