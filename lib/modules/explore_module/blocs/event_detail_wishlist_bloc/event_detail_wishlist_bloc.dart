import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/explore_module/blocs/event_detail_wishlist_bloc/event_detail_wishlist_events.dart';
import 'package:palette/modules/explore_module/blocs/event_detail_wishlist_bloc/event_detail_wishlist_states.dart';
import 'package:palette/modules/explore_module/services/explore_repository.dart';

class EventDetailWishlistBloc
    extends Bloc<EventDetailWishlistEvent, EventDetailWishlistState> {
  final ExploreRepository exploreRepository;

  EventDetailWishlistBloc({
    required this.exploreRepository,
  }) : super((EventDetailWishlistInitialState()));

  @override
  Stream<EventDetailWishlistState> mapEventToState(
      EventDetailWishlistEvent event) async* {
    if (event is EventWishlistEvent) {
      yield EventDetailWishlistLoadingState();
      try {
        await exploreRepository.wishlist({
          'eventId': event.eventId,
          'wishList': event.wishList,
        });
        yield EventDetailWishlistSuccessState(wishListed: event.wishList);
      } catch (e) {
        yield EventDetailWishlistErrorState(err: e.toString());
      }
    }
  }
}
