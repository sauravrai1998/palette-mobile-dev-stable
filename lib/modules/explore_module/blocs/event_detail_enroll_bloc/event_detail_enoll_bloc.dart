import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/explore_module/blocs/event_detail_enroll_bloc/event_detail_enroll_states.dart';
import 'package:palette/modules/explore_module/services/explore_repository.dart';
import 'event_details_enroll_events.dart';

class EventDetailEnrollBloc
    extends Bloc<EventDetailEnrollEvent, EventDetailEnrollState> {
  final ExploreRepository exploreRepository;

  EventDetailEnrollBloc({
    required this.exploreRepository,
  }) : super((EventDetailEnrollInitialState()));

  @override
  Stream<EventDetailEnrollState> mapEventToState(
      EventDetailEnrollEvent event) async* {
    ///
    if (event is EventEnrollEvent) {
      yield EventDetailEnrollLoadingState();
      try {
        await exploreRepository.enroll({
          'oppid': event.opportunityId,
        });
        yield EventDetailEnrollSuccessState();
      } catch (e) {
        yield EventDetailEnrollErrorState(err: e.toString());
      }
    }
  }
}
