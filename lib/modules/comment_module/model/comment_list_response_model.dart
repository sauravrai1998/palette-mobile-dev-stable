class CommentListModel {
  CommentListModel({
    this.statusCode,
    this.commentList,
  });

  int? statusCode;
  List<CommentItemModel>? commentList;

  factory CommentListModel.fromJson(Map<String, dynamic> json) =>
      CommentListModel(
        statusCode: json["statusCode"],
        commentList: List<CommentItemModel>.from(
            json["data"].map((x) => CommentItemModel.fromJson(x))),
      );
}


class CommentItemModel {
  CommentItemModel({
    required this.id,
    required this.profilePicture,
    required this.creatorName,
    required this.postedAt,
    required this.comment,
  });

  final String id;
  final String profilePicture;
  final String creatorName;
  final DateTime postedAt;
  final String comment;

  factory CommentItemModel.fromJson(Map<String, dynamic> json) => CommentItemModel(
    id: json["Id"],
    profilePicture: json["profilePicture"] ?? '',
    creatorName: json["name"] ?? '',
    postedAt: DateTime.parse(json["posted_at"]).toLocal(),
    comment: json["comment"],

  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "profilePicture": this.profilePicture,
    "name": this.creatorName,
    "posted_at": this.postedAt,
    "comment": this.comment,
  };
}

