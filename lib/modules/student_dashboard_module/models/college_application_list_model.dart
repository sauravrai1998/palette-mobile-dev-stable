class CollegeApplicationList {
  CollegeApplicationList({
    required this.data,
  });

  List<CollegeInfo> data;

  factory CollegeApplicationList.fromJson(Map<String, dynamic> json) {
    List<CollegeInfo> infoList = [];

    List data = json['data'];

    for (int i = 0; i < data.length; i++) {
      var model = CollegeInfo.fromJson(data[i]);
      infoList.add(model);
    }

    var myVal = CollegeApplicationList(data: infoList);
    return myVal;
  }

  // Map<String, dynamic> toJson() => {
  //       "data": List<dynamic>.from(data.map((x) => x.toJson())),
  //     };
}

class CollegeInfo {
  CollegeInfo({
    required this.universityName,
    required this.program,
    required this.intake,
    required this.description,
    required this.applicationStatus,
    required this.appliedDate,
    required this.stepsToTake,
    required this.applicationLink,
    required this.applicationDecisionDate,
    required this.creationdate,
  });

  String universityName;
  String program;
  String intake;
  String description;
  String applicationStatus;
  String? appliedDate;
  List<String?>? stepsToTake;
  String applicationLink;
  DateTime? applicationDecisionDate;
  String? creationdate;

  factory CollegeInfo.fromJson(Map<String, dynamic> json) => CollegeInfo(
        universityName: json["universityName"],
        program: json["program"],
        intake: json["intake"],
        description: json["description"] == null ? '' : json["description"],
        applicationStatus: json["application_status"],
        appliedDate: json["applied_date"],
        stepsToTake: json["steps_to_take"] == null
            ? []
            : List<String>.from(json["steps_to_take"].map((x) => x)),
        applicationLink:
            json["application_link"] == null ? "" : json["application_link"],
        applicationDecisionDate: json["application_decision_date"] == null
            ? null
            : DateTime.parse(json["application_decision_date"]),
        creationdate: json["creationdate"],
      );

  // Map<String, dynamic> toJson() => {
  //       "universityName": universityName,
  //       "program": program,
  //       "intake": intake,
  //       "description": description == null ? null : description,
  //       "application_status": applicationStatus,
  //       "applied_date": appliedDate,
  //       "steps_to_take": stepsToTake == null
  //           ? null
  //           : List<dynamic>.from(stepsToTake!.map((x) => x)),
  //       "application_link": applicationLink == null ? null : applicationLink,
  //       "application_decision_date":
  //           "${applicationDecisionDate.year.toString().padLeft(4, '0')}-${applicationDecisionDate.month.toString().padLeft(2, '0')}-${applicationDecisionDate.day.toString().padLeft(2, '0')}",
  //       "creationdate": creationdate,
  //     };
}
