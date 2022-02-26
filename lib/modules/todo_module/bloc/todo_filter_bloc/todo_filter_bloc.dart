import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/todo_module/models/filter_models.dart';

abstract class TodoFilterEvent {}

class TodoFilterListInitialEvent extends TodoFilterEvent {}

class TodoFilterListEvent extends TodoFilterEvent {
  final List<FilterCheckboxHeadingModel> filterCheckboxHeadingList;
  final bool isFilterOn;
  final bool byme;

  TodoFilterListEvent({
    required this.isFilterOn,
    required this.filterCheckboxHeadingList,
    required this.byme,
  });
}

abstract class TodoFilterState {}

class TodoFilterInitialState extends TodoFilterState {}

class TodoFilterListState extends TodoFilterState {
  final List<FilterCheckboxHeadingModel> filterCheckboxHeadingList;
  final bool isFilterOn;
  final bool byme;
  TodoFilterListState({
    required this.isFilterOn,
    required this.filterCheckboxHeadingList,
    required this.byme,
  });
}

class TodoFilterBloc extends Bloc<TodoFilterEvent, TodoFilterState> {
  TodoFilterBloc(TodoFilterState initialState) : super(initialState);

  @override
  Stream<TodoFilterState> mapEventToState(TodoFilterEvent event) async* {
    if (event is TodoFilterListEvent) {
      yield TodoFilterListState(
        isFilterOn: event.isFilterOn,
        filterCheckboxHeadingList: event.filterCheckboxHeadingList,
        byme: event.byme,
      );
    } else if (event is TodoFilterListInitialEvent) {
      yield TodoFilterInitialState();
    }
  }
}

abstract class TodoFilterEventStudent {}

class InitialTodoFilterEvent extends TodoFilterEventStudent {}

class TodoFilterListEventStudent extends TodoFilterEventStudent {
  final List<FilterCheckboxHeadingModel> filterCheckboxHeadingList;
  final bool isFilterOn;
  final bool byme;

  TodoFilterListEventStudent({
    required this.isFilterOn,
    required this.filterCheckboxHeadingList,
    required this.byme,
  });
}

abstract class TodoFilterStateStudent {}

class TodoFilterInitialStateStudent extends TodoFilterStateStudent {}

class TodoFilterListStateStudent extends TodoFilterStateStudent {
  final List<FilterCheckboxHeadingModel> filterCheckboxHeadingList;
  final bool isFilterOn;
  final bool byme;
  TodoFilterListStateStudent({
    required this.isFilterOn,
    required this.filterCheckboxHeadingList,
    required this.byme,
  });
}

class TodoFilterBlocStudent
    extends Bloc<TodoFilterEventStudent, TodoFilterStateStudent> {
  TodoFilterBlocStudent(TodoFilterStateStudent initialState)
      : super(initialState);

  @override
  Stream<TodoFilterStateStudent> mapEventToState(
      TodoFilterEventStudent event) async* {
    if (event is TodoFilterListEventStudent) {
      yield TodoFilterListStateStudent(
        isFilterOn: event.isFilterOn,
        filterCheckboxHeadingList: event.filterCheckboxHeadingList,
        byme: event.byme,
      );
    } else if (event is InitialTodoFilterEvent) {
      yield TodoFilterInitialStateStudent();
    }
  }
}
