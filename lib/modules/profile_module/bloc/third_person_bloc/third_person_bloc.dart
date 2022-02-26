import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_events.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_states.dart';
import 'package:palette/modules/profile_module/services/third_person_repository.dart';

class ThirdPersonBloc extends Bloc<ThirdPersonEvent, ThirdPersonState> {
  final ThirdPersonRepository thirdPersonRepo;

  ThirdPersonBloc({required this.thirdPersonRepo})
      : super((InitialUserState()));

  @override
  Stream<ThirdPersonState> mapEventToState(ThirdPersonEvent event) async* {
    if (event is GetThirdPersonProfileScreenUser) {
      yield ThirdPersonLoadingState();
      try {
        final profileUser = await thirdPersonRepo.getProfileUser(
            event.studentId, event.role, event.context,);
        yield ThirdPersonSuccessState(profileUser: profileUser);
      } catch (e) {
        print(e);
        yield ThirdPersonFailedState(error: e.toString());
      }
    }
  }
}
