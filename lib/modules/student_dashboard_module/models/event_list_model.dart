import 'dart:convert';

EventList eventListListFromJson(String str) => EventList.fromJson(json.decode(str));

String eventListToJson(EventList data) => json.encode(data.toJson());

class EventList {
  EventList({
    required this.data,
  });

  List<EventInfo> data;

  factory EventList.fromJson(Map<String, dynamic> json) => EventList(
    data: List<EventInfo>.from(json["data"].map((x) => EventInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class EventInfo {
  EventInfo({
    required this.activityId,
    required this.name,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.venue,
    required this.phone,
    required this.website,
  });

  String activityId;
  String name;
  String category;
  DateTime startDate;
  DateTime endDate;
  String description;
  String venue;
  String phone;
  String website;

  factory EventInfo.fromJson(Map<String, dynamic> json) => EventInfo(
    activityId: json["activity_id"],
    name: json["name"],
    category: json["category"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    description: json["description"],
    venue: json["venue"],
    phone: json["phone"],
    website: json["website"] == null ? 'null' : json["website"],
  );

  Map<String, dynamic> toJson() => {
    "activity_id": activityId,
    "name": name,
    "category": category,
    "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "description": description,
    "venue": venue,
    "phone": phone,
    "website": website == null ? null : website,
  };
}

