class TutoringDataModel {
  String courseName;
  String name;
  int time;
  String rating;

  TutoringDataModel({
    required this.courseName,
    required this.name,
    required this.time,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'course': this.courseName,
      'rating': this.rating,
      'platform': this.time,
    };
  }

  factory TutoringDataModel.fromMap(Map item) {
    return TutoringDataModel(
      name: item['faculty'].toString(),
      time: item['Duration'],
      rating: item['Rating'].toString(),
      courseName: item['CourseName'].toString(),
    );
  }
}
