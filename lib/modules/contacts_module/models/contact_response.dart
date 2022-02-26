class ContactsResponse {
  ContactsResponse({
    required this.statusCode,
    required this.message,
    required this.contacts,
  });
  late final int statusCode;
  late final String message;
  late final List<ContactsData> contacts;

  ContactsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    contacts = List.from(json['contacts'])
        .map((e) => ContactsData.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['message'] = message;
    _data['contacts'] = contacts.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ContactsData {
  ContactsData({
    required this.sfid,
    required this.name,
    required this.profilePicture,
    required this.relationship,
    required this.firebaseUuid,
    required this.canCreateOpportunity,
    required this.canShareOpportuity,
    required this.canCreateTodo,
    required this.canChat,
    required this.isRegistered,
    this.isSelected = false,
  });

  final String sfid;
  final String name;
  final String? profilePicture;
  final String? relationship;
  final String firebaseUuid;
  final bool canCreateOpportunity;
  final bool canShareOpportuity;
  final bool canCreateTodo;
  final bool canChat;
  final bool isRegistered;
  bool isSelected;

  factory ContactsData.fromJson(Map<String, dynamic> json) {
    return ContactsData(
      sfid: json['id'],
      name: json['name'],
      profilePicture: json['profilePicture'],
      firebaseUuid: json['firebase_uuid'],
      relationship: json['relationship'],
      canCreateOpportunity: json['createOpportunity'],
      canShareOpportuity: json['shareOpportuity'],
      canCreateTodo: json['createTodo'],
      canChat: json['chat'],
      isRegistered: json['isRegistered'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = sfid;
    _data['name'] = name;
    _data['profilePicture'] = profilePicture;
    _data['firebase_uuid'] = firebaseUuid;
    _data['relationship'] = relationship;
    _data['createOpportunity'] = canCreateOpportunity;
    _data['shareOpportuity'] = canShareOpportuity;
    _data['createTodo'] = canCreateTodo;
    _data['chat'] = canChat;
    _data['isRegistered'] = isRegistered;
    return _data;
  }
}
