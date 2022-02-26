import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/explore_module/services/opportunity_repository.dart';

abstract class AddOpportunitiesToTodoState {}

class AddOpportunitiesToTodoInitialState extends AddOpportunitiesToTodoState {}
class AddOpportunitiesToTodoLoadingState extends AddOpportunitiesToTodoState {}
class AddOpportunitiesToTodoSuccessState extends AddOpportunitiesToTodoState {}
class AddOpportunitiesToTodoFailureState extends AddOpportunitiesToTodoState {
  final String error;
  AddOpportunitiesToTodoFailureState({required this.error});
}

//event
abstract class AddOpportunitiesToTodoEvent {}

class AddOppToTodoEvent extends AddOpportunitiesToTodoEvent {
  final List<String> opportunitiesIds;
  final List<String> assigneesIds;
  bool instituteId;
  BuildContext context;
  AddOppToTodoEvent({required this.opportunitiesIds,required this.assigneesIds, required this.instituteId, required this.context});
}

class AddOpportunitiesToTodoBloc extends Bloc<AddOpportunitiesToTodoEvent, AddOpportunitiesToTodoState> {
  AddOpportunitiesToTodoBloc(AddOpportunitiesToTodoState initialState) : super(AddOpportunitiesToTodoInitialState());


  @override
  Stream<AddOpportunitiesToTodoState> mapEventToState(AddOpportunitiesToTodoEvent event) async* {
    if (event is AddOppToTodoEvent) {
      yield AddOpportunitiesToTodoLoadingState();
      try {
        await OpportunityRepository.instance.addOpportunitiesToTodo(oppIds: event.opportunitiesIds,assigneesIds:  event.assigneesIds, instituteId: event.instituteId, context: event.context);
        yield AddOpportunitiesToTodoSuccessState();
      } catch (error) {
        yield AddOpportunitiesToTodoFailureState(error: error.toString());
      }
    }
  }
}