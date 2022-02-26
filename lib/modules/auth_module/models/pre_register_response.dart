class PreRegisterResponse {
  PreRegisterResponse({
    required this.message,
    required this.data,
  });

  String message;
  Data data;

  factory PreRegisterResponse.fromJson(Map<String, dynamic> json) =>
      PreRegisterResponse(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.sfId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });

  String sfId;
  String firstName;
  String lastName;
  String email;
  String role;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        sfId: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": sfId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "role": role,
      };
}
