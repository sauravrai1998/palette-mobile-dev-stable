class ModificationRequestResponse {
  final int statusCode;
  final ModificationRequest modificationDetail;

  ModificationRequestResponse({
    required this.statusCode,
    required this.modificationDetail,
  });

  factory ModificationRequestResponse.fromJson(Map<String, dynamic> json) =>
      ModificationRequestResponse(
        statusCode: json["statusCode"],
        modificationDetail: ModificationRequest.fromJson(json["data"]),
      );

}

class ModificationRequest {
  String id;
  String eventName;
  String? description;
  String? venue;
  String? website;
  String? eventDate;
  String type;
  String? approvalStatus;
  String? expirationDate;
  String? phoneNumber;
  String? visibility;
  String? status;
  String? opportunityScope;
  String? modificationId;
  String? removalStatus;
  List<String>? assignees;
  bool isSelected;

  ModificationRequest({
    required this.id,
    required this.eventName,
    required this.description,
    required this.venue,
    required this.website,
    required this.eventDate,
    required this.type,
    required this.approvalStatus,
    required this.phoneNumber,
    required this.expirationDate,
    required this.visibility,
    required this.status,
    required this.opportunityScope,
    required this.assignees,
    required this.modificationId,
    required this.removalStatus,
    this.isSelected = false,
  });

  factory ModificationRequest.fromJson(Map<String, dynamic> json) {
    final id = json['Id'];
    final eventName = json['Name'];
    final description = json['description'];
    final venue = json['venue'];
    final website = json['website'];
    final eventDate = json['eventDate'];
    final type = json['Type'];
    final approvalStatus = json['status'];
    final phoneNumber = json['phone'];
    final expirationDate = json['expirationDate'];
    final visibility = json['visibility'];
    final status = json['status'];
    final opportunityScope = json['opportunityScope'];
    final modificationId = json['modificationId'];
    final removalStatus = json['RemovalStatus'];
    final List<String> assignees = [];
    if (json['assignees'] != null) {
      json['assignees'].forEach((v) {
        assignees.add(v);
      });
    }

    return ModificationRequest(
        id: id,
        eventName: eventName,
        description: description,
        venue: venue,
        website: website,
        eventDate: eventDate,
        type: type,
        approvalStatus: approvalStatus,
        phoneNumber: phoneNumber,
        expirationDate: expirationDate,
        visibility: visibility,
        status: status,
        opportunityScope: opportunityScope,
        assignees: assignees,
        modificationId: modificationId,
        removalStatus: removalStatus);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.eventName;
    data['description'] = this.description;
    data['venue'] = this.venue;
    data['website'] = this.website;
    data['eventDate'] = this.eventDate;
    data['type'] = this.type;
    data['status'] = this.approvalStatus;
    data['expirationDate'] = this.expirationDate;
    data['phone'] = this.phoneNumber;
    data['visibility'] = this.visibility;
    data['status'] = this.status;
    data['opportunityScope'] = this.opportunityScope;
    data['modificationId'] = this.modificationId;
    data['RemovalStatus'] = this.removalStatus;
    if (this.assignees != null) {
      data['assignees'] = this.assignees;
    }
    return data;
  }
}

// class RecipientsDataForCreateByOpp {
//   RecipientsDataForCreateByOpp({
//     required this.id,
//     required this.name,
//     required this.profilePicture,
//     required this.isAssignee,
//   });
//     String id;
//     String name;
//     String profilePicture;
//     bool isAssignee;

//   factory RecipientsDataForCreateByOpp.fromJson(Map<String, dynamic> json) {
//    final id = json['Id'];
//    final name = json['name'];
//    final profilePicture = json['profilePicture'] ;
//    final isAssignee = json['isAssignee'];
//     return RecipientsDataForCreateByOpp(
//         id: id,
//         name: name,
//         profilePicture: profilePicture,
//         isAssignee: isAssignee);
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['Id'] = id;
//     _data['name'] = name;
//     _data['profilePicture'] = profilePicture;
//     _data['isAssignee'] = isAssignee;
//     return _data;
//   }
// }
// enum OpportunityVisibility {
//   Available,
//   Hidden,
//   Removed,
// }
//
// extension MyCreationVisibilityExtension on OpportunityVisibility {
//   String get name {
//     switch (this) {
//       case OpportunityVisibility.Available:
//         return 'Available';
//       case OpportunityVisibility.Hidden:
//         return 'Hidden';
//       case OpportunityVisibility.Removed:
//         return 'Removed';
//     }
//   }
// }
