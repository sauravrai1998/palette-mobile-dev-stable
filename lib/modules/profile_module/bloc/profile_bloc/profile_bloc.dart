import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_events.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_states.dart';
import 'package:palette/modules/profile_module/services/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepo;

  ProfileBloc({required this.profileRepo}) : super((InitialUserState()));

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is GetProfileScreenUser) {
      yield ProfileUserLoadingState();
      try {
        final profileUser = await profileRepo.getProfileUser();
        print('profileUSer : $profileUser');
        yield ProfileUserSuccessState(profileUser: profileUser);
      } catch (e) {
        print(e);
        yield ProfileUserFailedState(error: e.toString());
      }
    } else if (event is LinkDataEvent) {
      try {
        yield LinkDataLoadingState();
        bool result = await profileRepo.sendLinkData(
            title: event.title, value: event.value, webTitle: event.webTitle);
        if (result)
          yield LinkDataSuccessState();
        else
          yield LinkDataFailedState();
      } catch (e) {}
    } else if (event is GetEducationClassData) {
      yield EducationDataLoadingState();
      var educationData = await profileRepo.educationPageData();
      if (educationData.isNotEmpty) {
        yield EducationDataSuccessState(educationData: educationData);
      }

      /// Add a failed state @amar
    }
  }
}
