abstract class EventDetailEnrollEvent {}

class EventEnrollEvent extends EventDetailEnrollEvent {
  final String opportunityId;

  EventEnrollEvent({required this.opportunityId});
}
