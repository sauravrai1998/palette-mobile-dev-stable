import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:pendo_sdk/pendo_sdk.dart';

class NotificationPendoRepo {
  static trackApproveApprovalRequest({
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'NotificationModule | NotificationApprovalDetailScreen - Approve Approval Requests in ${pendoState.role}',
      arg,
    );
  }

  static trackNotificationDetailVisit({
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'NotificationModule | NotificationDetailScreen - Visit details of a single notification in ${pendoState.role}',
      arg,
    );
  }

  static trackViewApprovalOpportunity({
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'NotificationModule | NotificationApprovalDetailScreen - View Approval Requests for opportunity in ${pendoState.role}',
      arg,
    );
  }

  static trackRejectApprovalRequest({
    required PendoMetaDataState pendoState,
  }) async {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'NotificationModule | NotificationApprovalDetailScreen - Reject Approval Requests in ${pendoState.role}',
      arg,
    );
  }

  static trackViewCommentOnApprovalRequests({
    required PendoMetaDataState pendoState,
    required String eventId,
  }) async {
    final arg = {
      'eventId': eventId,
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'NotificationModule | NotificationApprovalDetailScreen - View Comments on Approval Requests',
      arg,
    );
  }

  static trackMarkAllNotificationsRead({
    required PendoMetaDataState pendoState,
  }) {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'NotificationModule | NotificationApprovalDetailScreen - Mark all Notifications read',
      arg,
    );
  }
}
