import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/explore_module/models/student_list_response.dart';
import 'package:palette/modules/explore_module/services/explore_repository.dart';

abstract class GetShareUsersEvent {}

class GetShareUsersFetchEvent extends GetShareUsersEvent {
  final String eventId;
  GetShareUsersFetchEvent({required this.eventId});
}

abstract class GetShareUsersState {}

class ShareUsersLoadingState extends GetShareUsersState {}

class ShareUsersSuccessState extends GetShareUsersState {
  final List<StudentByInstitute> userList;
  ShareUsersSuccessState({required this.userList});
}

class ShareUsersFailedState extends GetShareUsersState {
  final String err;
  ShareUsersFailedState({required this.err});
}

class ShareUsersInitialState extends GetShareUsersState {}

class OpportunityShareUsersBloc
    extends Bloc<GetShareUsersEvent, GetShareUsersState> {
  OpportunityShareUsersBloc() : super((ShareUsersInitialState()));

  @override
  Stream<GetShareUsersState> mapEventToState(GetShareUsersEvent event) async* {
    if (event is GetShareUsersFetchEvent) {
      yield ShareUsersLoadingState();
      try {
        final userList =
            await ExploreRepository.instance.getUsersToShareOpportunity(
          eventId: event.eventId,
        );
        yield ShareUsersSuccessState(userList: userList.modelList ?? []);
      } catch (e) {
        print(e);
        yield ShareUsersFailedState(err: e.toString());
      }
    }
  }
}
