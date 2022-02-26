class OpportunitiesModel {
  String eventTitle;
  String description;
  DateTime? eventDateTime;
  DateTime? expirationDateTime;
  String phone;
  String website;
  String venue;
  String eventType;

  OpportunitiesModel({
      required this.eventTitle,
      required this.description,
      required this.eventDateTime,
      required this.expirationDateTime,
      required this.phone,
      required this.website,
      required this.venue,
      required this.eventType});
  
}
