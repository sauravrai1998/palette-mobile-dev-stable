class RecipientsResponse {
  RecipientsResponse({
    required this.statusCode,
    required this.message,
    required this.instituteID,
    required this.data,
  });
  late final int statusCode;
  late final String message;
  late final String instituteID;
  late final List<RecipientsData> data;

  RecipientsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    instituteID = json['InstituteID'];
    data = List.from(json['data']).map((e) => RecipientsData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['message'] = message;
    _data['InstituteID'] = instituteID;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class RecipientsData {
  RecipientsData({
    required this.id,
    required this.name,
    required this.profilePicture,
    this.institute,
  });
  late final String id;
  late final String name;
  late final String profilePicture;
  late final String? institute;

  RecipientsData.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['name'];
    profilePicture = json['profilePicture'];
    institute = json['institute'] == null ? null : json['institute'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Id'] = id;
    _data['name'] = name;
    _data['profilePicture'] = profilePicture;
    _data['institute'] = institute;
    return _data;
  }
}
