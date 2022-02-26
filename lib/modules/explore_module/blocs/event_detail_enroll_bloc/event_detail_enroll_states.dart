abstract class EventDetailEnrollState {}

class EventDetailEnrollInitialState extends EventDetailEnrollState {}

class EventDetailEnrollLoadingState extends EventDetailEnrollState {}

class EventDetailEnrollSuccessState extends EventDetailEnrollState {}

class EventDetailEnrollErrorState extends EventDetailEnrollState {
  final String err;

  EventDetailEnrollErrorState({required this.err});
}
