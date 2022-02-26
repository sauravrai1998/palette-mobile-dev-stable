
class InstituteListModel {
  InstituteListModel({
    this.statusCode,
    this.modelList,
  });

  int? statusCode;
  List<Institute>? modelList;

  factory InstituteListModel.fromJson(Map<String, dynamic> json) => InstituteListModel(
    statusCode: json["statusCode"],
    modelList: List<Institute>.from(json["data"].map((x) => Institute.fromJson(x))),
  );
}

class Institute {
  Institute({
    this.name,
    this.id,
  });

  String? name;
  String? id;

  factory Institute.fromJson(Map<String, dynamic> json) => Institute(
    name: json["Name"],
    id: json["Id"]

  );

}