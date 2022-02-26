import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/explore_module/models/opp_created_by_me_response.dart';
import 'package:palette/modules/explore_module/services/opportunity_repository.dart';

abstract class OpportunityVisibilityState {}

class OpportunityVisibilityInitialState extends OpportunityVisibilityState {}

class OpportunityVisibilityLoadingState extends OpportunityVisibilityState {}

class OpportunityVisibilitySuccessState extends OpportunityVisibilityState {
  final String message;
  OpportunityVisibilitySuccessState({required this.message});
}

class OpportunityVisibilityErrorState extends OpportunityVisibilityState {
  final String error;
  OpportunityVisibilityErrorState({required this.error});
}

abstract class OpportunityVisibilityEvent {}

class ToggleOpportunityVisibilityEvent extends OpportunityVisibilityEvent {
  final OpportunityVisibility visibility;
  final String opporunityId;
  ToggleOpportunityVisibilityEvent(
      {required this.visibility, required this.opporunityId});
}

class SetOpportunityVisibilityToRemovalEvent
    extends OpportunityVisibilityEvent {
  final String opporunityId;
  String? reason;
  SetOpportunityVisibilityToRemovalEvent(
      {required this.opporunityId, this.reason});
}

class SetOpportunityVisibilityToInitEvent extends OpportunityVisibilityEvent {}

class OpportunityVisibilityBloc
    extends Bloc<OpportunityVisibilityEvent, OpportunityVisibilityState> {
  OpportunityVisibilityBloc(OpportunityVisibilityState initialState)
      : super(OpportunityVisibilityInitialState());

  Stream<OpportunityVisibilityState> mapEventToState(
      OpportunityVisibilityEvent event) async* {
    if (event is ToggleOpportunityVisibilityEvent) {
      yield OpportunityVisibilityLoadingState();
      try {
        await OpportunityRepository.instance.setBulkOpportunityVisibility(
            visibilty: event.visibility, opporunityIds: [event.opporunityId]);
        yield OpportunityVisibilitySuccessState(
            message: "Opportunity visibility updated successfully");
      } catch (error) {
        yield OpportunityVisibilityErrorState(error: error.toString());
      }
    } else if (event is SetOpportunityVisibilityToInitEvent) {
      yield OpportunityVisibilityInitialState();
    } else if (event is SetOpportunityVisibilityToRemovalEvent) {
      yield OpportunityVisibilityLoadingState();
      try {
        await OpportunityRepository.instance.deleteBulkOpportunities(opportunityIds: [event.opporunityId],
            message: event.reason);
        yield OpportunityVisibilitySuccessState(
            message: "Opportunity Removed successfully");
      } catch (error) {
        yield OpportunityVisibilityErrorState(error: error.toString());
      }
    }
  }
}
