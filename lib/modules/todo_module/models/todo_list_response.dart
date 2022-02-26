import 'dart:developer';

class TodoListResponse {
  final int statusCode;
  final List<Todo> todoList;
  final List<ListedByForList> allListedByInOneList;

  TodoListResponse({
    required this.statusCode,
    required this.todoList,
    required this.allListedByInOneList,
  });

  factory TodoListResponse.fromJson(Map<String, dynamic> json) {
    final List<Todo> data = [];
    final List<ListedByForList> allListedByInOneList = [];

    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Todo.fromJson(v));
      });
    }

    if (json['listedBy'] != null) {
      json['listedBy'].forEach((v) {
        allListedByInOneList.add(ListedByForList.fromJson(v));
      });
    }

    return TodoListResponse(
      statusCode: json['statusCode'],
      todoList: data,
      allListedByInOneList: allListedByInOneList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['data'] = this.todoList.map((v) => v.toJson()).toList();
    return data;
  }
}

class Todo {
  TodoTask task;
  List<Resources> todoResources;
  bool isopen;
  bool iscomp;
  bool isSelected;

  Todo({
    required this.task,
    required this.todoResources,
    this.isopen = false,
    this.iscomp = false,
    this.isSelected = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    List<Resources> resources = [];

    final jsonResourceList = json['resources'] as List;
    jsonResourceList.forEach((v) {
      resources.add(Resources.fromJson(v));
    });

    return Todo(
        task: TodoTask.fromJson(json['todo']), todoResources: resources);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.task.toJson();
    data['resources'] = this.todoResources.map((v) => v.toJson()).toList();
    return data;
  }
}

class Asigned {
  String id;
  String todoId;
  bool isArchived;
  String asigneeName;
  String status;
  String? acceptedStatus;
  String? profilePicture;

  Asigned(
      {required this.id,
      required this.todoId,
      required this.asigneeName,
      required this.isArchived,
      required this.status,
      required this.acceptedStatus,
      required this.profilePicture});

  factory Asigned.fromJson(Map<String, dynamic> json) {
    var assigneName = "Palette User";
    if (json.containsKey('name')) {
      assigneName = json['name'] ?? "Palette User";
    }

    return Asigned(
      id: json['Id'],
      todoId: json['todoId'],
      asigneeName: assigneName,
      status: json['status'],
      isArchived: json['Archived'],
      acceptedStatus: json['acceptedStatus'],
      profilePicture:
          json['profilePicture'] == null ? null : json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Id'] = this.id;
    data['todoId'] = this.todoId;
    data['name'] = this.asigneeName;
    data['status'] = this.status;
    data['acceptedStatus'] = this.acceptedStatus;
    data['Archived'] = this.isArchived;
    data['profilePicture'] = this.profilePicture;
    return data;
  }
}

class TodoTask {
  String? gid;
  String? name;
  String id;
  String? description;
  String? type;
  String? eventAt;
  String? venue;
  DateTime completeBy;
  String createdAt;
  ListedByForSingleTodo listedBy;
  List<Asigned> asignee;
  String? approvalStatus;
  String? todoScope;
  String taskStatus;
  String? acceptedStatus;
  String? creatorStatus;
  DateTime reminderAt;

  TodoTask(
      {required this.gid,
      required this.id,
      required this.taskStatus,
      required this.name,
      required this.description,
      required this.asignee,
      required this.type,
      required this.eventAt,
      required this.venue,
      required this.completeBy,
      required this.createdAt,
      required this.listedBy,
      required this.approvalStatus,
      required this.todoScope,
      required this.acceptedStatus,
      required this.creatorStatus,
      required this.reminderAt});

  factory TodoTask.fromJson(Map<String, dynamic> json) {
    final gid = json['groupId'];
    final name = json['name'];
    final id = json['Id'];
    final description = json['description'];
    final type = json['type'];
    final eventAt = json['eventAt'];
    final venue = json['venue'];
    final approvalStatus = json['status'];
    final acceptedStatus = json['acceptedStatus'];

    String? completeByVal = json['completeBy'] ?? "";
    final todoScope = json['todoScope'];

    DateTime completeBy;
    if (completeByVal != null && completeByVal.trim() != '') {
      completeBy = DateTime.parse(completeByVal);
    } else {
      completeBy = DateTime(9998);
    }

    final createdAt = json['createdAt'] ?? '9999-01-00T00:18:00.000+0000';
    final listedBy = ListedByForSingleTodo.fromJson(json['listedBy']);
    List<Asigned> asignee = [];

    final jsonAsigneeList = json['Assignee'] as List;
    jsonAsigneeList.forEach((v) {
      asignee.add(Asigned.fromJson(v));
    });
    final taskStatus = json['taskStatus'];
    final creatorStatus = json['creatorStatus'];
    String? remainderAtVal = json['reminderAt'] ?? "";
    DateTime reminderAt;
    if (remainderAtVal != null && remainderAtVal.trim() != '') {
      reminderAt = DateTime.parse(remainderAtVal);
    } else {
      reminderAt = DateTime(9998);
    }
    return TodoTask(
        gid: gid,
        id: id,
        name: name,
        acceptedStatus: acceptedStatus,
        description: description,
        approvalStatus: approvalStatus,
        type: type,
        eventAt: eventAt,
        taskStatus: taskStatus,
        venue: venue,
        completeBy: completeBy,
        todoScope: todoScope,
        createdAt: createdAt,
        listedBy: listedBy,
        asignee: asignee,
        creatorStatus: creatorStatus,
        reminderAt: reminderAt);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupId'] = this.gid;
    data['name'] = this.name;
    data['description'] = this.description;
    data['type'] = this.type;
    data['eventAt'] = this.eventAt;
    data['venue'] = this.venue;
    data['completeBy'] = this.completeBy;
    data['status'] = this.approvalStatus;
    data['acceptedStatus'] = this.acceptedStatus;
    data['createdAt'] = this.createdAt;
    data['listedBy'] = this.listedBy.toJson();
    data['todoScope'] = this.todoScope;
    data['resources'] = this.asignee.map((v) => v.toJson()).toList();
    data['creatorStatus'] = this.creatorStatus;
    data['reminderAt'] = this.reminderAt;
    return data;
  }
}

class ListedByForSingleTodo {
  final String id;
  final String name;

  ListedByForSingleTodo({required this.id, required this.name});

  factory ListedByForSingleTodo.fromJson(Map<String, dynamic> json) =>
      ListedByForSingleTodo(id: json['Id'] ?? "", name: json['Name'] ?? "");

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Id'] = this.id;
    data['Name'] = this.name;
    return data;
  }
}

class ListedByForList {
  final String id;
  final String name;

  ListedByForList({required this.id, required this.name});

  factory ListedByForList.fromJson(Map<String, dynamic> json) =>
      ListedByForList(id: json['Id'] ?? "", name: json['Name'] ?? "");

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Id'] = this.id;
    data['Name'] = this.name;
    return data;
  }
}

class Resources {
  String name;
  String url;
  String type;
  String? id;

  Resources(
      {required this.name, required this.url, required this.type, this.id});

  factory Resources.fromJson(Map<String, dynamic> json) => Resources(
        name: json['name'],
        url: json['url'],
        type: json['type'],
        id: json['Id'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = this.name;
    data['url'] = this.url;
    data['type'] = this.type;
    if (id != null) data['Id'] = this.id;
    return data;
  }
}
