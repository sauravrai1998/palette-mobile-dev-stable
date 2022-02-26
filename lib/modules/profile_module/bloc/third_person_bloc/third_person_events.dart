import 'package:palette/common_components/common_components_link.dart';

abstract class ThirdPersonEvent {}

class GetThirdPersonProfileScreenUser extends ThirdPersonEvent {
  String role;
  String studentId;
  BuildContext context;

  GetThirdPersonProfileScreenUser(
      {required this.studentId, required this.context, required this.role});
}
