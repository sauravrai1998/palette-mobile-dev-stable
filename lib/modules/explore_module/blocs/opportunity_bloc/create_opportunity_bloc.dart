import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/explore_module/models/create_opportunity_model.dart';
import 'package:palette/modules/explore_module/services/opportunity_repository.dart';

abstract class CreateOpportunityState {}

class CreateOpportunityInitialState extends CreateOpportunityState {}

class CreateOpportunityLoadingState extends CreateOpportunityState {}

class CreateOpportunitySuccessState extends CreateOpportunityState {}

class CreateOpportunityFailureState extends CreateOpportunityState {
  final String errorMessage;

  CreateOpportunityFailureState(this.errorMessage);
}

abstract class CreateOpportunityEvent {}

class CreateOpportunityForStudentEvent extends CreateOpportunityEvent {
  final OpportunitiesModel opportunitiesInfoDto;
  CreateOpportunityForStudentEvent({required this.opportunitiesInfoDto});
}

class CreateOpportunityForAllRolesEvent extends CreateOpportunityEvent {
  final OpportunitiesModel opportunitiesInfoDto;
  final List<String> assigneesId;
  final bool isGlobal;
  final BuildContext context;
  CreateOpportunityForAllRolesEvent(
      {required this.opportunitiesInfoDto,
      required this.assigneesId,
      required this.isGlobal,
      required this.context});
}

class CreateOpportunityBloc
    extends Bloc<CreateOpportunityEvent, CreateOpportunityState> {
  CreateOpportunityBloc(CreateOpportunityState initialState)
      : super(CreateOpportunityInitialState());

  @override
  Stream<CreateOpportunityState> mapEventToState(
      CreateOpportunityEvent event) async* {
    if (event is CreateOpportunityForAllRolesEvent) {
      yield CreateOpportunityLoadingState();
      try {
        await OpportunityRepository.instance.createOpportunityForAllRoles(
            opportunitiesInfoDto: event.opportunitiesInfoDto,
            assginesId: event.assigneesId,isGlobal: event.isGlobal,
            context: event.context);
        yield CreateOpportunitySuccessState();
      } catch (e) {
        yield CreateOpportunityFailureState(e.toString());
      }
    } else if (event is CreateOpportunityForStudentEvent) {
      yield CreateOpportunityLoadingState();
      try {
        await OpportunityRepository.instance.createOpportunitybyStudent(
            opportunitiesInfoDto: event.opportunitiesInfoDto);
        yield CreateOpportunitySuccessState();
      } catch (e) {
        yield CreateOpportunityFailureState(e.toString());
      }
    }
  }
}
