class ContactUsModel {
  String name;
  String email;
  String message;
  ContactUsModel(
      {required this.name, required this.email, required this.message});

  Map<String, dynamic> toMap() {
    return {'email': this.email, 'message': this.message, 'name': this.name};
  }

  factory ContactUsModel.fromMap(Map item) {
    return ContactUsModel(
      email: item['email'].toString(),
      message: item['message'].toString(),
      name: item['name'].toString(),
    );
  }
}

class FeedbackModel {
  String name;
  String email;
  String feedback;
  String rating;
  FeedbackModel(
      {required this.name,
      required this.email,
      required this.feedback,
      required this.rating});

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'feedback': this.feedback,
      'name': this.name,
      'rating': this.rating
    };
  }

  factory FeedbackModel.fromMap(Map item) {
    return FeedbackModel(
      email: item['email'].toString(),
      feedback: item['feedback'].toString(),
      name: item['name'].toString(),
      rating: item['rating'].toString(),
    );
  }
}

class ResourceCenterGuides {
  String name;
  String description;
  String eventString;

  ResourceCenterGuides(
      {required this.name,
      required this.description,
      required this.eventString});

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'description': this.description,
      'event_string': this.eventString
    };
  }

  factory ResourceCenterGuides.fromMap(Map item) {
    return ResourceCenterGuides(
      name: item['name'].toString(),
      description: item['description'].toString(),
      eventString: item['event_string'].toString(),
    );
  }
}


class ReportBugModel {
  String name;
  String email;
  String message;
  List<String>? screenshots;
  ReportBugModel(
      {required this.name,
      required this.email,
      required this.message,
      this.screenshots});

  Map<String, dynamic> toMap() {
    if (screenshots != null) {
      return {
        'email': this.email,
        'message': this.message,
        'name': this.name,
        'screenshots':
            this.screenshots != null ? this.screenshots : [] as List<String>
      };
    } else
      return {'email': this.email, 'message': this.message, 'name': this.name};
  }

  factory ReportBugModel.fromMap(Map item) {
    return ReportBugModel(
      email: item['email'].toString(),
      message: item['message'].toString(),
      name: item['name'].toString(),
      screenshots: item['screenshots'] != null
          ? item['screenshots'].toString().split(",")
          : [],
    );
  }
}
