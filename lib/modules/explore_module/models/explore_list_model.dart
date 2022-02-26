import 'dart:convert';

ExploreListModel exploreListModelFromJson(String str) =>
    ExploreListModel.fromJson(json.decode(str));

class ExploreListModel {
  ExploreListModel({
    this.statusCode,
    this.exploreList,
  });

  int? statusCode;
  List<ExploreModel>? exploreList;

  factory ExploreListModel.fromJson(Map<String, dynamic> json) =>
      ExploreListModel(
        statusCode: json["statusCode"],
        exploreList: List<ExploreModel>.from(
            json["data"].map((x) => ExploreModel.fromJson(x))),
      );
}

class ExploreModel {
  ExploreModel({
    this.activity,
    required this.enrolledEvent,
    required this.wishListedEvent,
    this.isSelected = false,
    // this.resources,
  });

  Activity? activity;
  bool wishListedEvent;
  bool enrolledEvent;
  bool isSelected;
  // List<Resource>? resources;

  factory ExploreModel.fromJson(Map<String, dynamic> json) {
    return ExploreModel(
      activity: Activity.fromJson(json["activity"]),
      wishListedEvent:
          json['wishListedEvent'] == null ? false : json['wishListedEvent'],
      enrolledEvent:
          json['enrolledEvent'] == null ? false : json['enrolledEvent'],
      // resources: List<Resource>.from(json["resources"].map((x) => Resource.fromJson(x))),
    );
  }
}

class Activity {
  Activity({
    this.activityId,
    this.name,
    this.category,
    this.startDate,
    this.endDate,
    this.description,
    this.venue,
    this.phone,
    // this.shippingAddress,
    this.website,
    this.listedBy,
    this.opportunityScope,
  });

  String? activityId;
  String? name;
  String? category;
  String? startDate;
  String? endDate;
  String? description;
  String? venue;
  String? phone;
  // ShippingAddress? shippingAddress;
  String? website;
  String? listedBy;
  String? opportunityScope;

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        activityId: json["activity_id"],
        name: json["name"],
        category: json["category"],
        startDate: json["start_date"] == null
            ? ''
            : json["start_date"], //json["start_date"],
        endDate: json["end_date"] == null
            ? ''
            : json["end_date"], // DateTime.parse(json["end_date"]),
        description: json["description"],
        venue: json["venue"],
        phone: json["phone"] == null ? null : json["phone"],
        // shippingAddress: ShippingAddress.fromJson(json["shipping_address"]),
        website: json["website"],
        listedBy: json["ListedBy"] == null ? null : json["ListedBy"],
        opportunityScope: json["OpportunityScope"] == null
            ? null
            : json["OpportunityScope"],
      );
}

/*
class ShippingAddress {
  ShippingAddress({
    this.city,
    this.country,
    this.postalCode,
    this.state,
    this.street,
  });

  String city;
  String country;
  String postalCode;
  String state;
  String street;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
    city: json["city"],
    country: json["country"],
    postalCode: json["postal_code"] == null ? null : json["postal_code"],
    state: json["state"] == null ? null : json["state"],
    street: json["street"] == null ? null : json["street"],
  );

  Map<String, dynamic> toJson() => {
    "city": city,
    "country": country,
    "postal_code": postalCode == null ? null : postalCode,
    "state": state == null ? null : state,
    "street": street == null ? null : street,
  };
}

class Resource {
  Resource({
    this.name,
    this.url,
    this.type,
  });

  String name;
  String url;
  String type;

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
    name: json["name"],
    url: json["url"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "url": url,
    "type": type,
  };
}

*/
