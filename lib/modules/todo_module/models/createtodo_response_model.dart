class ResponseDataAfterCreateTodo {
  String gId;
  List<String> ids;
  ResponseDataAfterCreateTodo({
    required this.gId,
    required this.ids,
  });
  factory ResponseDataAfterCreateTodo.fromJson(Map<String, dynamic> json) {
    final List<String> data = [];
    json['ids'].forEach((v) {
      data.add(v);
    });
    return ResponseDataAfterCreateTodo(gId: json['groupId'], ids: data);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['groupId'] = this.gId;
    data['data'] = this.ids.toList();
    return data;
  }
}
