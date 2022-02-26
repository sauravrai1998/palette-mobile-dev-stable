import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/notifications_module/models/notification_item_model.dart';
import 'package:palette/modules/notifications_module/services/notifications_repo.dart';

abstract class NotificationsEvent {}

class FetchNotifications extends NotificationsEvent {
  FetchNotifications();
}

abstract class NotificationsState {}

class NotificationsInitialState extends NotificationsState {}

class FetchNotificationsLoadingState extends NotificationsState {}
class FetchNotificationsSuccessState extends NotificationsState {
  NotificationListModel notificationList;
  FetchNotificationsSuccessState({required this.notificationList});
}

class FetchNotificationsFailureState extends NotificationsState {
  final String error;
  FetchNotificationsFailureState(this.error);
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {

final NotificationsRepository notificationsRepository;

NotificationsBloc({required this.notificationsRepository})
    : super((NotificationsInitialState()));

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async*{
    
    if (event is FetchNotifications) {
      yield FetchNotificationsLoadingState();
      try {
        print('fetching');
        var notificationList = await notificationsRepository.fetchAllNotifications();
        yield FetchNotificationsSuccessState(notificationList: notificationList);
      } catch (e) {
        yield FetchNotificationsFailureState(e.toString());
      }
    }
    // throw UnimplementedError();
  }
}

