
import 'package:palette/common_components/common_components_link.dart';

class ShareDetailViewForOppModel{
  final String title;
  final String webUrl;
  final String eventType;
  final String description;
  final DateTime expireDate;

  ShareDetailViewForOppModel(
      {required this.title,
      required this.webUrl,
      required this.eventType,
      required this.description,
      required this.expireDate});
}

class ShareDetailForTodoViewModel {
  final String title;
  final String webUrl;
  final String eventType;
  final String description;
  final DateTime? eventDate;
  final TimeOfDay? eventTime;

  ShareDetailForTodoViewModel(
      {required this.title,
      required this.webUrl,
      required this.eventType,
      required this.description,
      required this.eventDate,
      required this.eventTime});
}
