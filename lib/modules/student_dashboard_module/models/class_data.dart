class ClassData {
  String name;


  ClassData({
    required this.name,

  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,

    };
  }

  factory ClassData.fromMap(Map item) {
    return ClassData(
      name: item['CourseName'],
    );
  }
}
