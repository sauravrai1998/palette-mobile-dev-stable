import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_events.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_states.dart';
import 'package:palette/modules/profile_module/services/profile_repository.dart';

class RefreshProfileBloc
    extends Bloc<RefreshProfileEvent, RefreshProfileState> {
  final ProfileRepository profileRepo;

  RefreshProfileBloc({required this.profileRepo})
      : super((RefreshProfileScreenInitialState()));

  @override
  Stream<RefreshProfileState> mapEventToState(
      RefreshProfileEvent event) async* {
    if (event is RefreshUserProfileDetails) {
      yield RefreshProfileScreenLoadingState();
      try {
        final profileUser = await profileRepo.getProfileUser();
        print('profileUser : $profileUser');
        yield RefreshProfileScreenSuccessState(profileUser: profileUser);
      } catch (e) {
        print(e);
        yield RefreshProfileScreenFailedState(error: e.toString());
      }
    } else if (event is AddSkillsInterestActivities) {
      yield SkillsInterestActivitiesLoadingState();
      try {
        await profileRepo.skillInterestActivites(
          data: event.data,
        );
        yield SkillsInterestActivitiesSuccessState();
      } catch (e) {
        yield SkillsInterestActivitiesFailedState(err: e.toString());
      }
    }
  }
}
