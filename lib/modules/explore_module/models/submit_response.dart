class SubmitResponse {
  SubmitResponse({
    this.statusCode,
    this.message,
  });

  int? statusCode;
  String? message;

  factory SubmitResponse.fromJson(Map<String, dynamic> json) => SubmitResponse(
    statusCode: json["statusCode"],
    message: json["message"]
  );

}