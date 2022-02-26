abstract class EventDetailWishlistState {}

class EventDetailWishlistInitialState extends EventDetailWishlistState {}

class EventDetailWishlistLoadingState extends EventDetailWishlistState {}

class EventDetailWishlistSuccessState extends EventDetailWishlistState {
  final bool wishListed;
  EventDetailWishlistSuccessState({required this.wishListed});
}

class EventDetailWishlistErrorState extends EventDetailWishlistState {
  final String err;

  EventDetailWishlistErrorState({required this.err});
}
