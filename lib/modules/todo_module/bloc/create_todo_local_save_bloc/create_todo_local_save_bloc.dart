import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/todo_module/models/asignee.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';

class CreateTodoLocalSaveState {
  final String todoType;
  final String actionText;
  final String? descriptionText;
  DateTime? dueDate;
  TimeOfDay? dueTime;
  DateTime? remainderDate;
  TimeOfDay? remainderTime;
  DateTime? eventDate;
  TimeOfDay? eventTime;
  final String? venue;
  bool isAddResoucesClicked = false;
  List<Resources>? linkResources = [];
  List<Resources>? fileResources = [];
  bool isLoading = false;
  List<FileLoaderForBloc>? filesLoaderForBloc = [];
  final String? assignee;
  List<Asignee>? assigneeDropDown;
  List<String>? selectedAssignees;

  CreateTodoLocalSaveState({
    this.todoType = "to-do type",
    this.actionText = "",
    this.descriptionText,
    this.dueDate,
    this.dueTime,
    this.remainderDate,
    this.remainderTime,
    this.eventDate,
    this.eventTime,
    this.venue,
    this.isAddResoucesClicked = false,
    this.linkResources,
    this.fileResources,
    this.isLoading = false,
    this.filesLoaderForBloc,
    this.assignee = "Assignee",
    this.assigneeDropDown,
    this.selectedAssignees,
  });

  CreateTodoLocalSaveState copyWith({
    String? todoType,
    String? actionText,
    String? descriptionText,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    DateTime? remainderDate,
    TimeOfDay? remainderTime,
    DateTime? eventDate,
    TimeOfDay? eventTime,
    String? venue,
    bool? isAddResoucesClicked,
    List<Resources>? linkresources,
    List<Resources>? fileresources,
    bool? isLoading,
    List<FileLoaderForBloc>? filesLoaderForBloc,
    String? assignee,
    List<Asignee>? assigneeDropDown,
    List<String>? selectedAssignees,
  }) {
    return CreateTodoLocalSaveState(
      todoType: todoType ?? this.todoType,
      actionText: actionText ?? this.actionText,
      descriptionText: descriptionText ?? this.descriptionText,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      remainderDate: remainderDate ?? this.remainderDate,
      remainderTime: remainderTime ?? this.remainderTime,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      venue: venue ?? this.venue,
      isAddResoucesClicked: isAddResoucesClicked ?? this.isAddResoucesClicked,
      linkResources: linkresources ?? this.linkResources,
      fileResources: fileresources ?? this.fileResources,
      isLoading: isLoading ?? this.isLoading,
      filesLoaderForBloc: filesLoaderForBloc ?? this.filesLoaderForBloc,
      assignee: assignee ?? this.assignee,
      assigneeDropDown: assigneeDropDown ?? this.assigneeDropDown,
      selectedAssignees: selectedAssignees ?? this.selectedAssignees,
    );
  }
}

abstract class CreateTodoLocalSaveEvent {}

class TodoTypeChanged extends CreateTodoLocalSaveEvent {
  final String todoType;

  TodoTypeChanged({required this.todoType});
}

class ActionTextChanged extends CreateTodoLocalSaveEvent {
  final String actionText;

  ActionTextChanged({required this.actionText});
}

class DescriptionTextChanged extends CreateTodoLocalSaveEvent {
  final String descriptionText;

  DescriptionTextChanged({required this.descriptionText});
}

class DueDateChanged extends CreateTodoLocalSaveEvent {
  final DateTime? dueDate;

  DueDateChanged({required this.dueDate});
}

class DueTimeChanged extends CreateTodoLocalSaveEvent {
  final TimeOfDay dueTime;

  DueTimeChanged({required this.dueTime});
}

class RemainderDateChanged extends CreateTodoLocalSaveEvent {
  final DateTime? remainderDate;

  RemainderDateChanged({required this.remainderDate});
}

class RemainderTimeChanged extends CreateTodoLocalSaveEvent {
  final TimeOfDay remainderTime;

  RemainderTimeChanged({required this.remainderTime});
}

class EventDateChanged extends CreateTodoLocalSaveEvent {
  final DateTime? eventDate;

  EventDateChanged({required this.eventDate});
}

class EventTimeChanged extends CreateTodoLocalSaveEvent {
  final TimeOfDay eventTime;

  EventTimeChanged({required this.eventTime});
}

class VenueChanged extends CreateTodoLocalSaveEvent {
  final String venue;

  VenueChanged({required this.venue});
}

class AddResourcesClicked extends CreateTodoLocalSaveEvent {}

class LinkResourcesChanged extends CreateTodoLocalSaveEvent {
  final List<Resources> linkresources;

  LinkResourcesChanged({required this.linkresources});
}

class FileResourcesChanged extends CreateTodoLocalSaveEvent {
  final List<Resources> fileresources;

  FileResourcesChanged({required this.fileresources});
}

class IsLoadingCreateTodo extends CreateTodoLocalSaveEvent {
  final bool isLoading;

  IsLoadingCreateTodo({required this.isLoading});
}

class FilesLoaderForBlocChanged extends CreateTodoLocalSaveEvent {
  final List<FileLoaderForBloc> filesLoaderForBloc;

  FilesLoaderForBlocChanged({required this.filesLoaderForBloc});
}

class ClearCreateTodoLocalSaveEvent extends CreateTodoLocalSaveEvent {}

class AssigneeChanged extends CreateTodoLocalSaveEvent {
  final String assignee;

  AssigneeChanged({required this.assignee});
}

class SelectedAssigneesChanged extends CreateTodoLocalSaveEvent {
  final List<String> selectedAssignees;

  SelectedAssigneesChanged({required this.selectedAssignees});
}

class AssigneeDropDownChanged extends CreateTodoLocalSaveEvent {
  final List<Asignee> assigneeDropDown;

  AssigneeDropDownChanged({required this.assigneeDropDown});
}

class CreateTodoLocalSaveBloc
    extends Bloc<CreateTodoLocalSaveEvent, CreateTodoLocalSaveState> {
  CreateTodoLocalSaveBloc() : super(CreateTodoLocalSaveState());

  @override
  Stream<CreateTodoLocalSaveState> mapEventToState(
      CreateTodoLocalSaveEvent event) async* {
    if (event is TodoTypeChanged) {
      yield state.copyWith(todoType: event.todoType);
    } else if (event is ActionTextChanged) {
      yield state.copyWith(actionText: event.actionText);
    } else if (event is DescriptionTextChanged) {
      yield state.copyWith(descriptionText: event.descriptionText);
    } else if (event is DueDateChanged) {
      yield state.copyWith(dueDate: event.dueDate);
    } else if (event is DueTimeChanged) {
      yield state.copyWith(dueTime: event.dueTime);
    } else if (event is RemainderDateChanged) {
      yield state.copyWith(remainderDate: event.remainderDate);
    } else if (event is RemainderTimeChanged) {
      yield state.copyWith(remainderTime: event.remainderTime);
    } else if (event is EventDateChanged) {
      yield state.copyWith(eventDate: event.eventDate);
    } else if (event is EventTimeChanged) {
      yield state.copyWith(eventTime: event.eventTime);
    } else if (event is VenueChanged) {
      yield state.copyWith(venue: event.venue);
    } else if (event is AddResourcesClicked) {
      yield state.copyWith(isAddResoucesClicked: true);
    } else if (event is LinkResourcesChanged) {
      yield state.copyWith(linkresources: event.linkresources);
    } else if (event is FileResourcesChanged) {
      yield state.copyWith(fileresources: event.fileresources);
    } else if (event is IsLoadingCreateTodo) {
      yield state.copyWith(isLoading: event.isLoading);
    } else if (event is FilesLoaderForBlocChanged) {
      yield state.copyWith(filesLoaderForBloc: event.filesLoaderForBloc);
    } else if (event is ClearCreateTodoLocalSaveEvent) {
      yield CreateTodoLocalSaveState();
    } else if (event is AssigneeChanged) {
      yield state.copyWith(assignee: event.assignee);
    } else if (event is AssigneeDropDownChanged) {
      yield state.copyWith(assigneeDropDown: event.assigneeDropDown);
    } else if (event is SelectedAssigneesChanged) {
      yield state.copyWith(selectedAssignees: event.selectedAssignees);
    }
  }
}

class FileLoaderForBloc {
  String fileName;
  String filePath;
  String fileType;
  File file;

  FileLoaderForBloc(
      {required this.fileName,
      required this.filePath,
      required this.fileType,
      required this.file});
}
