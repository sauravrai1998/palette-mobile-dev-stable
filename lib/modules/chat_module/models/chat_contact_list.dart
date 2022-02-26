class ChatContactList {
  ChatContactList({
    required this.chatContactList,
  });

  List<ChatContact> chatContactList;

  factory ChatContactList.fromJson(Map<String, dynamic> json) =>
      ChatContactList(
        chatContactList: List<ChatContact>.from(
            json["data"].map((x) => ChatContact.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(chatContactList.map((x) => x.toJson())),
      };
}

class ChatContact {
  ChatContact({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.uuid,
    required this.role,
    required this.isRegistered,
    this.isSelected = false,
    this.profilePicture,
  });

  String id;
  String firstName;
  String lastName;
  String uuid;
  String role;
  bool isSelected;
  String? profilePicture;
  bool? isRegistered;

  factory ChatContact.fromJson(Map<String, dynamic> json) => ChatContact(
        id: json["Id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        uuid: json["uuid"],
        role: json["role"],
        profilePicture: json["profilePicture"],
        isRegistered: json["isRegistered"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "firstName": firstName,
        "lastName": lastName,
        "uuid": uuid,
        "role": role,
        "profilePicture": profilePicture,
        "isRegistered": isRegistered,
      };
}
