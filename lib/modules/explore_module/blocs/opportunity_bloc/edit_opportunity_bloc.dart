import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/explore_module/models/create_opportunity_model.dart';
import 'package:palette/modules/explore_module/services/opportunity_repository.dart';

abstract class EditOpportunityState {}

class EditOpportunityInitialState extends EditOpportunityState {}

class EditOpportunityLoadingState extends EditOpportunityState {}

class EditOpportunitySuccessState extends EditOpportunityState {}

class EditOpportunityFailureState extends EditOpportunityState {
  final String errorMessage;

  EditOpportunityFailureState(this.errorMessage);
}

abstract class EditOpportunityEvent {}

class EditOpportunityForDiscreteEvent extends EditOpportunityEvent {
  final OpportunitiesModel opportunitiesInfoDto;
  final String opportunityId;
  final List<String> recipientIds;
  EditOpportunityForDiscreteEvent(
      {required this.opportunitiesInfoDto,
      required this.opportunityId,
      required this.recipientIds});
}

class EditOpportunityForGlobalEvent extends EditOpportunityEvent {
  final OpportunitiesModel opportunitiesInfoDto;
  final String opportunityId;
  EditOpportunityForGlobalEvent(
      {required this.opportunitiesInfoDto, required this.opportunityId});
}

class EditDraftOpporunityToLiveEvent extends EditOpportunityEvent {
  final OpportunitiesModel opportunitiesInfoDto;
  final String opportunityId;
  final List<String> recipientIds;
  final bool isGlobal;
  final BuildContext context;
  EditDraftOpporunityToLiveEvent(
      {required this.opportunitiesInfoDto,
      required this.opportunityId,
      required this.recipientIds,
      required this.isGlobal,
      required this.context});
}

class EditOpportunityBloc
    extends Bloc<EditOpportunityEvent, EditOpportunityState> {
  EditOpportunityBloc(EditOpportunityState initialState)
      : super(EditOpportunityInitialState());

  @override
  Stream<EditOpportunityState> mapEventToState(
      EditOpportunityEvent event) async* {
    if (event is EditOpportunityForDiscreteEvent) {
      yield EditOpportunityLoadingState();
      try {
        await OpportunityRepository.instance.editOpportunityforDiscrete(
            opportunitiesInfoDto: event.opportunitiesInfoDto,
            recipientIds: event.recipientIds,
            opportunityId: event.opportunityId);
        yield EditOpportunitySuccessState();
      } catch (e) {
        yield EditOpportunityFailureState(e.toString());
      }
    } else if (event is EditOpportunityForGlobalEvent) {
      yield EditOpportunityLoadingState();
      try {
        await OpportunityRepository.instance.editOpportunitybyOtherGlobal(
            opportunitiesInfoDto: event.opportunitiesInfoDto,
            opportunityId: event.opportunityId);
        yield EditOpportunitySuccessState();
      } catch (e) {
        yield EditOpportunityFailureState(e.toString());
      }
    } else if (event is EditDraftOpporunityToLiveEvent) {
      yield EditOpportunityLoadingState();
      try {
        await OpportunityRepository.instance
            .editDraftOpportunityToLive(opportunityId: event.opportunityId, opportunitiesInfoDto: event.opportunitiesInfoDto, recipientIds: event.recipientIds, isGlobal: event.isGlobal,context: event.context);
        yield EditOpportunitySuccessState();
      } catch (e) {
        yield EditOpportunityFailureState(e.toString());
      }
    }
  }
}
