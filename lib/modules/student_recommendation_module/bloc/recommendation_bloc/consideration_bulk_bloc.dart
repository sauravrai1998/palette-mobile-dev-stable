import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_repository.dart';

abstract class ConsiderationBulkEvent {}

class ConsiderationBulkAddToTodo extends ConsiderationBulkEvent{
  final List<String> ids;
  ConsiderationBulkAddToTodo({required this.ids});
}

class ConsiderationBulkDismissTodo extends ConsiderationBulkEvent{
  final List<String> ids;
  ConsiderationBulkDismissTodo({required this.ids});
}

abstract class ConsiderationBulkState {}

class ConsiderationBulkInitialState extends ConsiderationBulkState {}

class ConsiderationBulkAddToTodoLoadingState extends ConsiderationBulkState {}

class ConsiderationBulkAddToTodoSuccessState extends ConsiderationBulkState {}

class ConsiderationBulkAddToTodoErrorState extends ConsiderationBulkState {
  final String errorMessage;

  ConsiderationBulkAddToTodoErrorState({required this.errorMessage});
}

class ConsiderationBulkDismissLoadingState extends ConsiderationBulkState {}

class ConsiderationBulkDismissSuccessState extends ConsiderationBulkState {}

class ConsiderationBulkDismissErrorState extends ConsiderationBulkState {
  final String errorMessage;

  ConsiderationBulkDismissErrorState({required this.errorMessage});
}

class ConsiderationBulkBloc extends Bloc<ConsiderationBulkEvent, ConsiderationBulkState> {

  ConsiderationBulkBloc() : super(ConsiderationBulkInitialState());

  @override
  Stream<ConsiderationBulkState> mapEventToState(ConsiderationBulkEvent event) async*{
    if (event is ConsiderationBulkAddToTodo) {
      yield ConsiderationBulkAddToTodoLoadingState();
      try {
        await RecommendRepository.instance.addTodoBulk(todoIds: event.ids);
        yield ConsiderationBulkAddToTodoSuccessState();
      } catch (e) {
        yield ConsiderationBulkAddToTodoErrorState(errorMessage: e.toString());
      }
    }
    else if (event is ConsiderationBulkDismissTodo) {
      yield ConsiderationBulkDismissLoadingState();
      try {
        await RecommendRepository.instance.dismissBulk(todoIds: event.ids);
        yield ConsiderationBulkDismissSuccessState();
      } catch (e) {
        yield ConsiderationBulkDismissErrorState(errorMessage: e.toString());
      }
    }
  }
}
