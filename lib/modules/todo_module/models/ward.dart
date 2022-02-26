class Ward {
  final String id;
  final String name;
 String? profilePicture;
  Ward({required this.id, required this.name, this.profilePicture});

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(id: json['Id'], name: json['Name'], profilePicture: json['profilePicture']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['profilePicture'] = this.profilePicture;
    return data;
  }
}
