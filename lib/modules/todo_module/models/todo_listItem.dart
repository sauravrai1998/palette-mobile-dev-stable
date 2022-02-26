class TodoListItem {
  String org;
  String status;
  String type;
  DateTime date;
  TodoListItem(
    this.org,
    this.status,
    this.type,
    this.date,
  );
}

List<TodoListItem> todoList = [];

void getTodoData() {
  todoList = [];
  todoList.add(
    TodoListItem(
      "Montogoetry College",
      "open",
      "EDUCATION",
      DateTime.now(),
    ),
  );
  todoList.add(
    TodoListItem(
      "Microsoft",
      "completed",
      "COMPANY",
      DateTime.now(),
    ),
  );
  todoList.add(
    TodoListItem(
      "Soccer Night '21",
      "open",
      "SPORTS",
      DateTime.now(),
    ),
  );
  todoList.add(
    TodoListItem(
      "DebateNight",
      "open",
      "SOCIAL",
      DateTime.now(),
    ),
  );
  todoList.add(
    TodoListItem(
      "Soccer Night '21",
      "open",
      "SPORTS",
      DateTime.now(),
    ),
  );
  todoList.add(
    TodoListItem(
      "Soccer Night '21",
      "open",
      "SPORTS",
      DateTime.now(),
    ),
  );
}
