class JobApplicationListModel {
  JobApplicationListModel({
    required this.data,
  });

  List<JobInfo> data;

  factory JobApplicationListModel.fromJson(Map<String, dynamic> json) =>
      JobApplicationListModel(
        data: List<JobInfo>.from(json["data"].map((x) => JobInfo.fromJson(x))),
      );
}

class JobInfo {
  JobInfo({
    required this.organizationName,
    required this.position,
    required this.description,
    required this.applicationStatus,
    required this.appliedDate,
    required this.stepsToTake,
    required this.applicationLink,
    required this.applicationDecisionDate,
    required this.creationdate,
  });

  String organizationName;
  String position;
  String description;
  String applicationStatus;
  String? appliedDate;
  List<String>? stepsToTake;
  String applicationLink;
  DateTime? applicationDecisionDate;
  String? creationdate;

  factory JobInfo.fromJson(Map<String, dynamic> json) => JobInfo(
        organizationName: json["organizationName"],
        position: json["position"],
        description: json["description"] == null ? '' : json["description"],
        applicationStatus: json["application_status"],
        appliedDate: json["applied_date"],
        stepsToTake: json["steps_to_take"] == null
            ? []
            : List<String>.from(json["steps_to_take"].map((x) => x)),
        applicationLink:
            json["application_link"] == null ? '' : json["application_link"],
        applicationDecisionDate: json["application_decision_date"] == null
            ? null
            : DateTime.parse(json["application_decision_date"]),
        creationdate: json["creationdate"],
      );

  // Map<String, dynamic> toJson() => {
  //   "organizationName": organizationName,
  //   "position": position,
  //   "description": description == null ? null : description,
  //   "application_status": applicationStatus,
  //   "applied_date": appliedDate,
  //   "steps_to_take": stepsToTake == null ? null : List<dynamic>.from(stepsToTake!.map((x) => x)),
  //   "application_link": applicationLink == null ? null : applicationLink,
  //   "application_decision_date": "${applicationDecisionDate.year.toString().padLeft(4, '0')}-${applicationDecisionDate.month.toString().padLeft(2, '0')}-${applicationDecisionDate.day.toString().padLeft(2, '0')}",
  //   "creationdate": creationdate,
  // };
}
