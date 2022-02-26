abstract class RefreshProfileEvent {}

class RefreshUserProfileDetails extends RefreshProfileEvent {}

class AddSkillsInterestActivities extends RefreshProfileEvent {
  final Map data;
  AddSkillsInterestActivities({required this.data});
}
