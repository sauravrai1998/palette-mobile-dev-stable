class AdvisorStudentList {
  AdvisorStudentList({
    required this.statusCode,
    required this.data,
  });

  int statusCode;
  Data data;

  factory AdvisorStudentList.fromJson(Map<String, dynamic> json) =>
      AdvisorStudentList(
        statusCode: json["statusCode"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.mentor,
    required this.students,
  });

  Advisor mentor;
  List<AdvisorStudent> students;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        mentor: Advisor.fromJson(json["mentor"]),
        students: List<AdvisorStudent>.from(
            json["students"].map((x) => AdvisorStudent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mentor": mentor.toJson(),
        "students": List<dynamic>.from(students.map((x) => x.toJson())),
      };
}

class Advisor {
  Advisor({
    required this.name,
    required this.phone,
    required this.email,
    required this.instituteName,
    required this.designation,
    required this.mailingCity,
    required this.mailingCountry,
    required this.mailingState,
    required this.mailingStreet,
    required this.mailingPostalCode,
    required this.facebookLink,
    required this.whatsappLink,
    required this.instagramLink,
    required this.websiteLink,
    required this.websiteTitle,
    required this.githubLink,
    required this.linkedinLink,
  });

  String? name;
  String? phone;
  String? email;
  String? instituteName;
  String? designation;
  String? mailingCity;
  String? mailingCountry;
  String? mailingState;
  String? mailingStreet;
  String? mailingPostalCode;
  String? facebookLink;
  String? whatsappLink;
  String? instagramLink;
  String? websiteLink;
  String? websiteTitle;
  String? githubLink;
  String? linkedinLink;

  factory Advisor.fromJson(Map<String, dynamic> json) => Advisor(
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        instituteName: json["institute_name"],
        designation: json["designation"],
        mailingCity: json["mailingCity"],
        mailingCountry: json["mailingCountry"],
        mailingState: json["mailingState"],
        mailingStreet: json["mailingStreet"],
        mailingPostalCode: json["mailingPostalCode"],
        facebookLink: json["facebook_link"],
        whatsappLink: json["whatsapp_link"],
        instagramLink: json["instagram_link"],
        websiteLink: json["website_link"],
        websiteTitle: json["website_Title"],
        githubLink: json["github_link"],
        linkedinLink: json["linkedin_link"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "email": email,
        "institute_name": instituteName,
        "designation": designation,
        "mailingCity": mailingCity,
        "mailingCountry": mailingCountry,
        "mailingState": mailingState,
        "mailingStreet": mailingStreet,
        "mailingPostalCode": mailingPostalCode,
        "facebook_link": facebookLink,
        "whatsapp_link": whatsappLink,
        "instagram_link": instagramLink,
        "website_link": websiteLink,
        "website_Title": websiteTitle,
        "github_link": githubLink,
        "linkedin_link": linkedinLink,
      };
}

class AdvisorStudent {
  AdvisorStudent({
    required this.id,
    required this.name,
    required this.profilePicture
  });

  String? id;
  String? name;
  String? profilePicture;

  factory AdvisorStudent.fromJson(Map<String, dynamic> json) => AdvisorStudent(
        id: json["Id"],
        name: json["name"],
      profilePicture: json["profilePicture"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "name": name,
    "profilePicture": profilePicture
      };
}
