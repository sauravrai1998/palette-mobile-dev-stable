abstract class ProfileEvent {}

class GetProfileScreenUser extends ProfileEvent {}

class LinkDataEvent extends ProfileEvent {
  final String title;
  final String value;
  final String webTitle;

  LinkDataEvent({
    required this.title,
    required this.value,
    required this.webTitle,
  });
}

class GetEducationClassData extends ProfileEvent {}
