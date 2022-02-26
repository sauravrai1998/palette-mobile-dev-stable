class InstituteDetails {
  final String instituteId;
  final String designation;

  InstituteDetails({required this.instituteId, required this.designation});

  factory InstituteDetails.fromJson(Map<String, dynamic> json) {
    return InstituteDetails(
      instituteId: json['institute_id'],
      designation: json['designation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institute_id': this.instituteId,
      'designation': this.designation,
    };
  }
}
