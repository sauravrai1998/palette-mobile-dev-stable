import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/explore_module/models/opp_created_by_me_response.dart';
import 'package:palette/modules/explore_module/services/explore_repository.dart';

abstract class GetMyCreationsEvent {}

class GetMyCreationsFetchEvent extends GetMyCreationsEvent {}

abstract class GetMyCreationsState {}

class GetMyCreationsLoadingState extends GetMyCreationsState {}

class GetMyCreationsSuccessState extends GetMyCreationsState {
  final OppCreatedByMeResponse oppCreatedByMeResp;
  GetMyCreationsSuccessState({required this.oppCreatedByMeResp});
}

class GetMyCreationsGetFailedState extends GetMyCreationsState {
  final String err;
  GetMyCreationsGetFailedState({required this.err});
}

class GetMyCreationsInitiaState extends GetMyCreationsState {}

class GetMyCreationsBloc
    extends Bloc<GetMyCreationsEvent, GetMyCreationsState> {
  GetMyCreationsBloc() : super((GetMyCreationsInitiaState()));

  @override
  Stream<GetMyCreationsState> mapEventToState(
      GetMyCreationsEvent event) async* {
    if (event is GetMyCreationsFetchEvent) {
      yield GetMyCreationsLoadingState();
      try {
        final oppCreatedByMeResp = await ExploreRepository.instance.getOppCreatedByMe();
        yield GetMyCreationsSuccessState(
          oppCreatedByMeResp: oppCreatedByMeResp,
            );
      } catch (e) {
        print(e);
        yield GetMyCreationsGetFailedState(err: e.toString());
      }
    }
  }
}
