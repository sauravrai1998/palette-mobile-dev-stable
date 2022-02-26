import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/notifications_module/models/approval_notification_detail_model.dart';
import 'package:palette/modules/notifications_module/models/todo_approval_detail_model.dart';
import 'package:palette/modules/notifications_module/services/notifications_repo.dart';

abstract class NotificationsDetailEvent {}

class FetchDetailNotifications extends NotificationsDetailEvent {
  final String eventId;
  final String notificationId;
  final bool isTodo;
  FetchDetailNotifications(this.eventId, this.notificationId, this.isTodo);
}
class FetchDetailTodoNotifications extends NotificationsDetailEvent {
  final String eventId;
  final String notificationId;
  FetchDetailTodoNotifications(this.eventId, this.notificationId);
}

abstract class NotificationsDetailState {}

class NotificationsDetailInitialState extends NotificationsDetailState {}

class FetchNotificationsDetailLoadingState extends NotificationsDetailState {}
class FetchNotificationsDetailSuccessState extends NotificationsDetailState {
  ApproveNotificationDetailList notificationList;
  FetchNotificationsDetailSuccessState({required this.notificationList});
}

class FetchNotificationsDetailFailureState extends NotificationsDetailState {
  final String error;
  FetchNotificationsDetailFailureState(this.error);
}
class FetchNotificationsDetailTodoLoadingState extends NotificationsDetailState {}
class FetchNotificationsDetailTodoSuccessState extends NotificationsDetailState {
  TodoNotificationDetailList notificationList;
  FetchNotificationsDetailTodoSuccessState({required this.notificationList});
}

class FetchNotificationsDetailTodoFailureState extends NotificationsDetailState {
  final String error;
  FetchNotificationsDetailTodoFailureState(this.error);
}
class NotificationsDetailBloc extends Bloc<NotificationsDetailEvent, NotificationsDetailState> {

  final NotificationsRepository notificationsRepository;

  NotificationsDetailBloc({required this.notificationsRepository})
      : super((NotificationsDetailInitialState()));

  @override
  Stream<NotificationsDetailState> mapEventToState(NotificationsDetailEvent event) async*{

    if (event is FetchDetailNotifications) {
      yield FetchNotificationsDetailLoadingState();
      try {
        print('fetching');
        var notificationList = await notificationsRepository.getApprovalDetails(eventId: event.eventId,notificationId: event.notificationId,isTodo: event.isTodo);
        yield FetchNotificationsDetailSuccessState(notificationList: notificationList);
      } catch (e) {
        yield FetchNotificationsDetailFailureState(e.toString());
      }
    }
    if (event is FetchDetailTodoNotifications) {
      yield FetchNotificationsDetailTodoLoadingState();
      try {
        print('fetching');
        var notificationList = await notificationsRepository.getTodoApprovalDetails(eventId: event.eventId,notificationId: event.notificationId);
        yield FetchNotificationsDetailTodoSuccessState(notificationList: notificationList);
      } catch (e) {
        yield FetchNotificationsDetailFailureState(e.toString());
      }
    }
    // throw UnimplementedError();
  }
}
