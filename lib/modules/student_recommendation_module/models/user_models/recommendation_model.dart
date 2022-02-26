class Recommendation {
  Recommendation({
    required this.statusCode,
    required this.data,
  });

  int statusCode;
  List<RecommendedByData>? data;

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    print(json["data"]);
    List<RecommendedByData> datasend = [];
    final jsondata = json['data'] as List;
    jsondata.forEach((v) {
      datasend.add(RecommendedByData.fromJson(v));
      print(v);
    });
    return Recommendation(
      statusCode: json["statusCode"],
      data: datasend,
    );
  }

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class RecommendedByData {
  RecommendedByData({
    required this.id,
    required this.recommendedBy,
    required this.event,
    this.isSelected = false,
  });

  List<String> id;
  List<RecommendedBy> recommendedBy;
  Event? event;
  bool isSelected;

  factory RecommendedByData.fromJson(Map<String, dynamic> json) {
    List<RecommendedBy> recommendedby = [];
    List<String> iD = [];
    print(json);
    final jsonrecommendedbyList = json['recommendedBy'] as List;
    final ids = json["Id"] as List;
    ids.forEach((v) {
      iD.add(v);
    });
    jsonrecommendedbyList.forEach((v) {
      recommendedby.add(RecommendedBy.fromJson(v));
    });
    return RecommendedByData(
      id: iD,
      recommendedBy: recommendedby,
      event: Event.fromJson(json["event"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "Id": id,
        "recommendedBy": recommendedBy,
        "event": event!.toJson(),
      };
}

class Event {
  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.venue,
    required this.phone,
    required this.website,
    required this.opportunityScope,
  });

  String? id;
  String? name;
  String? description;
  String? category;
  String? startDate;
  DateTime? endDate;
  String? venue;
  String? phone;
  String? website;
  String? opportunityScope;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["Id"],
        name: json["Name"],
        description: json["Description"],
        category: json["Category"],
        startDate: json["StartDate"],
        endDate:
            json["EndDate"] != null ? DateTime.parse(json["EndDate"]) : null,
        venue: json["Venue"],
        phone: json["Phone"],
        website: json["Website"],
        opportunityScope: json["OpportunityScope"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Description": description,
        "Category": category,
        "StartDate": startDate,
        "EndDate":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "Venue": venue,
        "Phone": phone,
        "Website": website,
        "OpportunityScope": opportunityScope,
      };
}

class RecommendedBy {
  RecommendedBy({
    required this.id,
    required this.name,
    required this.role,
  });

  String? id;
  String name;
  String role;

  factory RecommendedBy.fromJson(Map<String, dynamic> json) {
    print(json);
    return RecommendedBy(
      id: json["Id"] == null ? null : json["Id"],
      name: json["Name"],
      role: json["Role"],
    );
  }

  Map<String, dynamic> toJson() => {
        "Id": id == null ? null : id,
        "Name": name,
        "Role": role,
      };
}
