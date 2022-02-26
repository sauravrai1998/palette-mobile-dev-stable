import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/notifications_module/services/notifications_repo.dart';

abstract class SinlgeNotificationsEvent {}

class ReadNotification extends SinlgeNotificationsEvent {
  final String notificationId;
  ReadNotification(this.notificationId);
}

abstract class SingleNotificationsState {}

class NotificationsInitialState extends SingleNotificationsState {}

class ReadNotificationLoadingState extends SingleNotificationsState{}
class ReadNotificationSuccessState extends SingleNotificationsState {}
class ReadNotificationFailureState extends SingleNotificationsState {
  final String error;
  ReadNotificationFailureState(this.error);
}

class SingleNotificationsBloc extends Bloc<SinlgeNotificationsEvent, SingleNotificationsState> {

// final notificationsRepository = NotificationsRepository.instance;
  final NotificationsRepository notificationsRepository;
  // NotificationsBloc() : super(NotificationsInitialState());
  SingleNotificationsBloc({required this.notificationsRepository})
      : super((NotificationsInitialState()));

  @override
  Stream<SingleNotificationsState> mapEventToState(SinlgeNotificationsEvent event) async*{

    if (event is ReadNotification) {
      yield ReadNotificationLoadingState();
      try {
        await notificationsRepository.readNotifications(id: event.notificationId);
        yield ReadNotificationSuccessState();
      } catch (e) {
        yield ReadNotificationFailureState(e.toString());
      }
    }
    // throw UnimplementedError();
  }
}

