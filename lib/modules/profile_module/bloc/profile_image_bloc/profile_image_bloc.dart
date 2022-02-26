import 'package:flutter_bloc/flutter_bloc.dart';

/// States
abstract class ProfileImageState {}

class ProfileImageInitialState extends ProfileImageState {}

class ProfileImageDeleteState extends ProfileImageState {}

class ProfileImageSuccessState extends ProfileImageState {
  final String url;
  ProfileImageSuccessState({required this.url});
}

/// Events

abstract class ProfileImageEvent {}

class AddProfileImageEvent extends ProfileImageEvent {
  final String url;
  AddProfileImageEvent({required this.url});
}

class InitialProfileImageEvent extends ProfileImageEvent {}

class DeleteProfileImageEvent extends ProfileImageEvent {}

class ProfileImageBloc extends Bloc<ProfileImageEvent, ProfileImageState> {
  ProfileImageBloc() : super((ProfileImageInitialState()));

  @override
  Stream<ProfileImageState> mapEventToState(ProfileImageEvent event) async* {
    if (event is AddProfileImageEvent) {
      print('success state profile image in bloc');
      yield ProfileImageSuccessState(url: event.url);
    } else if (event is InitialProfileImageEvent) {
      yield ProfileImageInitialState();
    } else if (event is DeleteProfileImageEvent) {
      yield ProfileImageDeleteState();
    }
  }
}
