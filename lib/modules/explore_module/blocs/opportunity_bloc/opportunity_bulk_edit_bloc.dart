import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/explore_module/services/opportunity_repository.dart';

abstract class OpportunityBulkEditEvent {}

class OpportunityBulkAddToTodoForStudent extends OpportunityBulkEditEvent {
  List<String> ids;
  OpportunityBulkAddToTodoForStudent({required this.ids});
}

class OpportunityBulkConsider extends OpportunityBulkEditEvent {
  List<String> ids;
  OpportunityBulkConsider({required this.ids});
}

class OpportunityBulkAddToTodoForOthers extends OpportunityBulkEditEvent {
  List<String> ids;
  OpportunityBulkAddToTodoForOthers({required this.ids});
}

///
/// States
///
abstract class OpportunityBulkEditState {}

/// Initial Opportunity state
class OpportunityBulkInitiaState extends OpportunityBulkEditState {}

/// Opportunity Add To Todo States
class OpportunityBulkAddToTodoLoadingState extends OpportunityBulkEditState {}

class OpportunityBulkAddToTodoSuccessState extends OpportunityBulkEditState {}

class OpportunityBulkAddToTodoFailedState extends OpportunityBulkEditState {
  final String err;
  OpportunityBulkAddToTodoFailedState({required this.err});
}

/// Opportunity Consider States
class OpportunityBulkConsiderLoadingState extends OpportunityBulkEditState {}

class OpportunityBulkConsiderSuccessState extends OpportunityBulkEditState {}

class OpportunityBulkConsiderFailedState extends OpportunityBulkEditState {
  final String err;
  OpportunityBulkConsiderFailedState({required this.err});
}

///
///Bloc
///
class OpportunityBulkEditBloc
    extends Bloc<OpportunityBulkEditEvent, OpportunityBulkEditState> {
  OpportunityBulkEditBloc() : super((OpportunityBulkInitiaState()));

  @override
  Stream<OpportunityBulkEditState> mapEventToState(
      OpportunityBulkEditEvent event) async* {
    if (event is OpportunityBulkAddToTodoForStudent) {
      yield OpportunityBulkAddToTodoLoadingState();
      try {
        await OpportunityRepository.instance.opportunityBulkAddToTodo(
          event.ids,
        );
        yield OpportunityBulkAddToTodoSuccessState();
      } catch (e) {
        print(e);
        yield OpportunityBulkAddToTodoFailedState(err: e.toString());
      }
    } else if (event is OpportunityBulkConsider) {
      yield OpportunityBulkConsiderLoadingState();
      try {
        await OpportunityRepository.instance.opportunityBulkConsiderations(
          event.ids,
        );
        yield OpportunityBulkConsiderSuccessState();
      } catch (e) {
        print(e);
        yield OpportunityBulkConsiderFailedState(err: e.toString());
      }
    }
  }
}

class OpportunityBulkAddToTodoForOthersModel {
  final String id;
  final String eventTitle;
  final String eventDescription;

  OpportunityBulkAddToTodoForOthersModel({
    required this.id,
    required this.eventTitle,
    required this.eventDescription,
  });
}
