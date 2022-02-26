class TodoModel {
  String name;
  String description;
  String status;
  String type;
  String? venue;
  String? eventAt;
  String completedBy;
  String? reminderAt;
  bool isArchive;
  TodoApprovalStatus approvalStatus;

  TodoModel({
    required this.name,
    required this.description,
    this.eventAt,
    required this.status,
    required this.completedBy,
    this.reminderAt,
    required this.type,
    this.venue,
    this.isArchive = false,
    this.approvalStatus = TodoApprovalStatus.Requested,
  });
}

enum TodoApprovalStatus {
  Approved,
  NotApproved,
  Requested,
  InReview,
}

extension TodoApprovalStatusExtension on TodoApprovalStatus {
  String get value {
    switch (this) {
      case TodoApprovalStatus.Approved:
        return 'Approved';
      case TodoApprovalStatus.NotApproved:
        return 'Not Approved';
      case TodoApprovalStatus.Requested:
        return 'Requested';
      case TodoApprovalStatus.InReview:
        return 'In Review';
    }
  }
}
