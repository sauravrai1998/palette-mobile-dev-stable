import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/explore_module/models/create_opportunity_model.dart';
import 'package:palette/modules/explore_module/services/opportunity_repository.dart';

abstract class SaveOpportunityState {}

class SaveOpportunityInitialState extends SaveOpportunityState {}

class SaveOpportunityLoadingState extends SaveOpportunityState {}

class SaveOpportunitySuccessState extends SaveOpportunityState {}

class SaveOpportunityFailureState extends SaveOpportunityState {
  final String errorMessage;

  SaveOpportunityFailureState(this.errorMessage);
}

abstract class SaveOpportunityEvent {}

class SaveOpportunityForStudentEvent extends SaveOpportunityEvent {
  final OpportunitiesModel opportunitiesModel;
  SaveOpportunityForStudentEvent({required this.opportunitiesModel});
}

class SaveOpportunityForOtherRolesEvent extends SaveOpportunityEvent {
  final OpportunitiesModel opportunitiesModel;
  final List<String> assigneesId;
  final bool isGlobal;
  final BuildContext context;
  SaveOpportunityForOtherRolesEvent(
      {required this.opportunitiesModel, required this.assigneesId, required this.isGlobal,required this.context});
}

class SaveEditedOpportunityEvent extends SaveOpportunityEvent {
  final OpportunitiesModel opportunitiesModel;
  final List<String> assigneesId;
  final bool isGlobal;
  final BuildContext context;
  final String opportunityId;
  SaveEditedOpportunityEvent(
      {required this.opportunitiesModel, required this.assigneesId, required this.isGlobal,required this.context, required this.opportunityId,});
}

class SaveOpportunityBloc
    extends Bloc<SaveOpportunityEvent, SaveOpportunityState> {
  SaveOpportunityBloc(SaveOpportunityState initialState)
      : super(SaveOpportunityInitialState());

  @override
  Stream<SaveOpportunityState> mapEventToState(
      SaveOpportunityEvent event) async* {
    if (event is SaveOpportunityForStudentEvent) {
      yield SaveOpportunityLoadingState();
      try {
        await OpportunityRepository.instance.saveOpportunitybyStudent(
            opportunitiesInfoDto: event.opportunitiesModel);
        yield SaveOpportunitySuccessState();
      } catch (e) {
        yield SaveOpportunityFailureState(e.toString());
      }
    } else if (event is SaveOpportunityForOtherRolesEvent) {
      yield SaveOpportunityLoadingState();
      try {
        await OpportunityRepository.instance.saveOpportunitybyOthersRole(
            opportunitiesInfoDto: event.opportunitiesModel,
            assginesId: event.assigneesId,
            isGlobal: event.isGlobal,
            context: event.context);
        yield SaveOpportunitySuccessState();
      } catch (e) {
        yield SaveOpportunityFailureState(e.toString());
      }
    }
    else if (event is SaveEditedOpportunityEvent) {
      yield SaveOpportunityLoadingState();
      try {
        await OpportunityRepository.instance.saveEditedOpportunity(
            opportunityId: event.opportunityId,
            opportunitiesInfoDto: event.opportunitiesModel,
            assginesId: event.assigneesId,
            isGlobal: event.isGlobal,
            context: event.context);
        yield SaveOpportunitySuccessState();
      } catch (e) {
        yield SaveOpportunityFailureState(e.toString());
      }
    }
  }
}
