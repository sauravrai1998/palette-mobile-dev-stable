import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/profile_module/bloc/postimage_bloc/postImage_events.dart';
import 'package:palette/modules/profile_module/bloc/postimage_bloc/postImage_states.dart';
import 'package:palette/modules/profile_module/services/profile_repository.dart';

class PostImageBloc extends Bloc<PostImageEvent, PostImageState> {
  final ProfileRepository profileRepo;

  PostImageBloc({required this.profileRepo}) : super((PostImageInitialState()));

  @override
  Stream<PostImageState> mapEventToState(PostImageEvent event) async* {
    if (event is PostImageUrlEvent) {
      yield PostImageLoadingState();
      try {
        bool result = await profileRepo.postProfileImageUrl(
          url: event.url,
        );
        if (result)
          yield PostImageSuccessState();
        else
          yield PostImageFailedState();
      } catch (e) {}
    }
  }
}
