import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/explore_module/models/create_opportunity_model.dart';
import 'package:palette/modules/explore_module/services/opportunity_repository.dart';

abstract class CancelRequestState {}

class CancelRequestInitialState extends CancelRequestState {}

class CancelRequestLoadingState extends CancelRequestState {}

class CancelRequestSuccessState extends CancelRequestState {
  final String message;
  CancelRequestSuccessState({required this.message});
}

class CancelRequestFailureState extends CancelRequestState {
  final String errorMessage;

  CancelRequestFailureState(this.errorMessage);
}

abstract class CancelRequestEvent {}

class CancelModificationRequestEvent extends CancelRequestEvent {
  final String opportunityId;
  CancelModificationRequestEvent(
      {required this.opportunityId});
}

class CancelRemovalRequestEvent extends CancelRequestEvent {
  final String opportunityId;
  CancelRemovalRequestEvent(
      {required this.opportunityId});
}

class CancelRequestBloc
    extends Bloc<CancelRequestEvent, CancelRequestState> {
  CancelRequestBloc(CancelRequestState initialState)
      : super(CancelRequestInitialState());

  @override
  Stream<CancelRequestState> mapEventToState(
      CancelRequestEvent event) async* {
    if (event is CancelModificationRequestEvent) {
      yield CancelRequestLoadingState();
      try {
        await OpportunityRepository.instance.cancelModificationRequest(
            opportunityId: event.opportunityId);
        yield CancelRequestSuccessState(message: 'Modification Request Are Cancelled Successfully');
      } catch (e) {
        yield CancelRequestFailureState(e.toString());
      }
    } else if (event is CancelRemovalRequestEvent) {
      yield CancelRequestLoadingState();
      try {
        await OpportunityRepository.instance.cancelRemovalRequest(
            opportunityId: event.opportunityId);
        yield CancelRequestSuccessState(message: 'Removal Request Are Cancelled Successfully');
      } catch (e) {
        yield CancelRequestFailureState(e.toString());
      }
    }
  }
}
