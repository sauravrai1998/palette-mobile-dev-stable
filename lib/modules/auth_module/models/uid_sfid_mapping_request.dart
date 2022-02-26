class UidSFidMappingRequest {
  UidSFidMappingRequest({
    required this.sfId,
    required this.uuid,
    required this.email,
  });

  final String sfId;
  final String uuid;
  final String email;

  factory UidSFidMappingRequest.fromJson(Map<String, dynamic> json) =>
      UidSFidMappingRequest(
        sfId: json["SFId"],
        uuid: json["uuid"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "SFId": sfId,
        "uuid": uuid,
        "email": email,
      };
}
