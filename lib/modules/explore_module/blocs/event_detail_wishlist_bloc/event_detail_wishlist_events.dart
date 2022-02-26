abstract class EventDetailWishlistEvent {}

class EventWishlistEvent extends EventDetailWishlistEvent {
  final String eventId;
  final bool wishList;

  EventWishlistEvent({required this.eventId, required this.wishList});
}
