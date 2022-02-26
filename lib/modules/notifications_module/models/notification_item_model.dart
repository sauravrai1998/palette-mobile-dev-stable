class NotificationListModel {
  NotificationListModel({
    this.statusCode,
    this.modelList,
  });

  int? statusCode;
  List<NotificationItemModel>? modelList;

  factory NotificationListModel.fromJson(Map<String, dynamic> json) =>
      NotificationListModel(
        statusCode: json["statusCode"],
        modelList: List<NotificationItemModel>.from(
            json["data"].map((x) => NotificationItemModel.fromJson(x))),
      );
}

class NotificationItemModel {
  NotificationItemModel(
      {required this.id,
      required this.profilePicture,
      required this.creatorName,
      required this.createdAt,
      required this.type,
      required this.title,
      required this.isRead,
      required this.eventId,
      required this.opportunityCategory,
      required this.todoType});

  final String id;
  final String profilePicture;
  final String creatorName;
  final DateTime createdAt;
  final String type;
  final String title;
  bool isRead;
  final String eventId;
  final String? opportunityCategory;
  final String? todoType;

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) =>
      NotificationItemModel(
          id: json["Id"],
          profilePicture: json["ProfilePicture"],
          creatorName: json["CreatorName"] ?? '',
          createdAt: DateTime.parse(json["CreatedAt"]).toLocal(),
          type: json["TypeName"] == null ? null : json["TypeName"],
          title: json["Title"],
          isRead: json["IsRead"],
          eventId: json['EventId'],
          opportunityCategory: json['OpportunityCategory'],
          todoType: json['TodoType']);

  Map<String, dynamic> toJson() => {
        "Id": id,
        "ProfilePicture": this.profilePicture,
        "CreatorName": this.creatorName,
        "CreatedAt": this.createdAt,
        "TypeName": this.type == null ? null : this.type,
        "Title": this.title,
        "IsRead": this.isRead,
        "EventId": this.eventId,
        "OpportunityCategory": this.opportunityCategory,
        "TodoType": this.todoType
      };
}

enum NotificationsType {
  NewToDo,
  NewConsidereation,
  ApprovalRequest,
  ToDoStatusUpdate,
  GlobalToDoApprovalRequest,
  GlobalOpportunityModificationRequest,
  GlobalOpportunityApprovalRequest,

  //
}

extension NotificationTypeExtension on NotificationsType {
  String get typeName {
    switch (this) {
      case NotificationsType.NewToDo:
        return 'New To-Do';
      case NotificationsType.NewConsidereation:
        return 'New Considereation';
      case NotificationsType.ApprovalRequest:
        return 'Approval Request';
      case NotificationsType.ToDoStatusUpdate:
        return 'To-do Status Update';
      case NotificationsType.GlobalToDoApprovalRequest:
        return 'Global To-do Approval Request';
      case NotificationsType.GlobalOpportunityModificationRequest:
        return 'Global Opportunity Modification Request';
      case NotificationsType.GlobalOpportunityApprovalRequest:
        return 'Global Opportunity Approval Request';
    }
  }
}

enum NotificationForModule { Todo, Opportunity }

extension NotificationForModuleExtension on NotificationForModule {
  String get value {
    switch (this) {
      case NotificationForModule.Todo:
        return 'To Do';
      case NotificationForModule.Opportunity:
        return 'Opportunity';
    }
  }
}
