import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/notifications_module/services/notifications_repo.dart';

abstract class AllNotificationsEvent {}

class ReadAllNotifications extends AllNotificationsEvent {
  ReadAllNotifications();
}

abstract class AllNotificationsState {}

class NotificationsInitialState extends AllNotificationsState {}

class ReadAllNotificationsLoadingState extends AllNotificationsState {}
class ReadAllNotificationsSuccessState extends AllNotificationsState {}
class ReadAllNotificationsFailureState extends AllNotificationsState {
  final String error;
  ReadAllNotificationsFailureState(this.error);
}


class AllNotificationsBloc extends Bloc<AllNotificationsEvent, AllNotificationsState> {

// final notificationsRepository = NotificationsRepository.instance;
  final NotificationsRepository notificationsRepository;
  // NotificationsBloc() : super(NotificationsInitialState());
  AllNotificationsBloc({required this.notificationsRepository})
      : super((NotificationsInitialState()));

  @override
  Stream<AllNotificationsState> mapEventToState(AllNotificationsEvent event) async*{

    if (event is ReadAllNotifications) {
      yield ReadAllNotificationsLoadingState();
      try {
        await notificationsRepository.readAllNotifications();
        yield ReadAllNotificationsSuccessState();
      } catch (e) {
        yield ReadAllNotificationsFailureState(e.toString());
      }}
  }
}

