class ApproveNotificationDetailList {
  ApproveNotificationDetailList({
    this.statusCode,
    this.modelList,
  });

  int? statusCode;
  List<ApproveNotificationDetail>? modelList;

  factory ApproveNotificationDetailList.fromJson(Map<String, dynamic> json) =>
      ApproveNotificationDetailList(
        statusCode: json["statusCode"],
        modelList: List<ApproveNotificationDetail>.from(
            json["data"].map((x) => ApproveNotificationDetail.fromJson(x))),
      );
}

class ApproveNotificationDetail {
  ApproveNotificationDetail(
      {this.creatorName,
      this.id,
      this.eventName,
      this.category,
      this.phone,
      this.creatorProfilePic,
      this.role,
      required this.createdAt,
      this.venue,
      this.description,
      this.approvalStatus,
      this.valid,
      this.website,
      this.type});

  String? creatorName;
  String? id;
  String? eventName;
  String? category;
  String? creatorProfilePic;
  String? phone;
  String? role;
  String? venue;
  String? description;
  bool? isSelected = false;
  String? createdAt;
  bool? valid;
  String? approvalStatus;
  String? website;
  String? type;

  factory ApproveNotificationDetail.fromJson(Map<String, dynamic> json) =>
      ApproveNotificationDetail(
          creatorName: json["creatorName"],
          id: json["Id"],
          category: json['category'],
          eventName: json['eventName'],
          phone: json['phone'],
          creatorProfilePic: json['creatorProfilePic'] == null
              ? null
              : json['creatorProfilePic'],
          role: json['role'],
          createdAt: json['createdAt'],
          venue: json['venue'],
          description: json['description'],
          valid: json['valid'],
          approvalStatus: json['approvalStatus'],
          website: json['website'],
          type: json['type'] == null ? null : json['type']);
}
