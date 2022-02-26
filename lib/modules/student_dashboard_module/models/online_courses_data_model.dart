class OnlineCoursesDataModel {
  String course;
  String name;
  String platform;
  String rating;

  OnlineCoursesDataModel({
    required this.course,
    required this.name,
    required this.platform,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'course': this.course,
      'rating': this.rating,
      'platform': this.platform,
    };
  }

  factory OnlineCoursesDataModel.fromMap(Map item) {
    return OnlineCoursesDataModel(
      name: item['faculty'].toString(),
      platform: item['location'].toString(),
      rating: item['CompletedPercentage'].toString(),
      course: item['CourseName'].toString(),
    );
  }
}
