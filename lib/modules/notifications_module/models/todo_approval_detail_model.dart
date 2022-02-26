import 'package:intl/intl.dart';

class TodoNotificationDetailList {
  TodoNotificationDetailList({
    this.statusCode,
    required this.modelList,
  });

  int? statusCode;
  TodoNotificationDetail modelList;

  factory TodoNotificationDetailList.fromJson(Map<String, dynamic> json) =>
      TodoNotificationDetailList(
        statusCode: json["statusCode"],
        modelList: TodoNotificationDetail.fromJson(json["data"]),
      );
}

class TodoNotificationDetail {
  TodoNotificationDetail(
      {this.creatorName,
      this.id,
      this.eventName,
      this.category,
      this.phone,
      this.creatorProfilePic,
      this.completeBy,
      this.listedBy,
      this.venue,
      this.description,
      this.approvalStatus,
      this.valid,
      this.taskStatus,
      this.eventAt,
      this.createdAt,
        this.website});

  String? creatorName;
  String? id;
  String? eventName;
  String? category;
  String? creatorProfilePic;
  String? phone;
  String? venue;
  String? description;
  bool? isSelected = false;
  String? completeBy;
  String? listedBy;
  String? eventAt;
  bool? valid;
  String? approvalStatus;
  String? taskStatus;
  String? createdAt;
  String? website;

  factory TodoNotificationDetail.fromJson(Map<String, dynamic> json) =>
      TodoNotificationDetail(
          creatorName: json["creatorName"],
          id: json["id"],
          category: json['type'],
          eventName: json['name'],
          phone: json['phone'],
          creatorProfilePic: json['creatorPic'] == null
              ? null
              : json['creatorPic'],
          completeBy: json['completeBy'],
          createdAt: json['createdAt'],
          listedBy: json['listedBy'],
          venue: json['eventVenue'],
          description: json['description'],
          valid: json['valid'],
          approvalStatus: json['approvalStatus'],
          taskStatus: json['taskStatus'],
          eventAt: json['eventAt'],
          website:json['website']);
}
