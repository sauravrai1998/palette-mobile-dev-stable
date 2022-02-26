import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/student_recommendation_module/models/user_models/recommendation_model.dart';
import 'package:palette/utils/konstants.dart';
import 'package:pendo_sdk/pendo_sdk.dart';

class RecommendationPendoRepo {
  static trackVisitedDetailScreen({
    required Event? event,
    required PendoMetaDataState pendoState,
  }) {
    if (event == null) {
      return;
    }

    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'category': event.category,
      'endDate': event.endDate,
      'name': event.name,
      'startDate': event.startDate,
      'venue': event.venue,
      'website': event.website,
    };

    PendoFlutterPlugin.track(
        'Recommendation | RecommendationDetailScreen - VisitRecommendationDetailScreen',
        arg);
  }

  static trackBulkDecline({
    required BuildContext context,
    required List<String> considerationIds,
  }) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'considerationIds': considerationIds,
    };

    PendoFlutterPlugin.track(
      'Recommendation | RecommendationListScreen - RecommendationBulkDecline',
      arg,
    );
  }

  static trackBulkShareConsiderations({
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
        'Consideration | ConsiderationListScreen - Shared Bulk Opportunity to Assignees',
        arg);
  }

  static trackBulkAddToTodo({
    required BuildContext context,
    required List<String> considerationIds,
  }) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'considerationIds': considerationIds,
    };

    PendoFlutterPlugin.track(
      'Recommendation | RecommendationListScreen - RecommendationBulkAddToTodo',
      arg,
    );
  }

  static trackSearchInRecommendation({
    required BuildContext context,
  }) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'Recommendation | RecommendationListScreen - RecommendationListSearch',
      arg,
    );
  }

  static trackOpenConsiderationPageEvent({
    required BuildContext context,
  }) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
      'Opportunity | OpportunityListScreen - RecommendationPageOpen',
      arg,
    );
  }

  static trackVisitedUrlInRecommendationDetailScreen({
    required BuildContext context,
    required String url,
    required Event? event,
  }) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    if (event == null) return;
    final eventName = event.name;
    final category = event.category;

    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'url': url,
      'eventName': eventName,
      'category': category,
    };

    PendoFlutterPlugin.track(
      'Recommendation | RecommendationDetailScreen - VisitLinkOfRecommendationEvent',
      arg,
    );
  }

  static trackTappingPhoneButtonInRecommendationDetailScreen({
    required String phone,
    required Event? event,
    required BuildContext context,
  }) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    if (event == null) return;
    final eventName = event.name;
    final category = event.category;

    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'phone': phone,
      'eventName': eventName,
      'category': category,
    };

    PendoFlutterPlugin.track(
      'Recommendation | RecommendationDetailScreen - TappingPhoneButtonInRecommendationEvent',
      arg,
    );
  }

  static trackTappingRecommendedByButton({
    required List<String> recommendedBy,
    required Event? event,
    required PendoMetaDataState pendoState,
  }) {
    if (event == null) return;
    final eventName = event.name;
    final category = event.category;

    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'recommendedBy': recommendedBy,
      'eventName': eventName,
      'category': category,
    };

    PendoFlutterPlugin.track(
      'Recommendation | RecommendationDetailScreen - DisplayNameOfRecommendedByPerson',
      arg,
    );
  }

  static trackAcceptRecommendation({
    required PendoMetaDataState pendoState,
    required Event? event,
  }) {
    if (event == null) {
      return;
    }

    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'category': event.category,
      'endDate': event.endDate,
      'name': event.name,
      'startDate': event.startDate,
      'venue': event.venue,
      'website': event.website,
    };

    PendoFlutterPlugin.track(
        'Recommendation | RecommendationDetailScreen - AcceptRecommendation',
        arg);
  }

  static trackRejectRecommendation({
    required Event? event,
    required PendoMetaDataState pendoState,
  }) {
    if (event == null) {
      return;
    }

    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'category': event.category,
      'endDate': event.endDate,
      'name': event.name,
      'startDate': event.startDate,
      'venue': event.venue,
      'website': event.website,
    };

    PendoFlutterPlugin.track(
        'Recommendation | RecommendationDetailScreen - RejectRecommendation',
        arg);
  }
}
