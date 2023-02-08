class TodoList {
  final int count;
  final String? next;
  final String? previous;
  final List<Todo> todos;

  TodoList(
      {required this.count, this.next, this.previous, required this.todos});

  factory TodoList.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<Todo> todoList = list.map((e) => Todo.fromJson(e)).toList();

    return TodoList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      todos: todoList,
    );
  }
}

class Todo {
  final int id;
  final String title;
  final String content;
  final String createdAt;
  final String startAt;
  final String endAt;
  late final bool isDone;
  final bool isDeleted;
  final int user;

  Todo({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.startAt,
    required this.endAt,
    required this.isDone,
    required this.isDeleted,
    required this.user,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: json['created_at'],
      startAt: json['start_at'],
      endAt: json['end_at'],
      isDone: json['is_done'],
      isDeleted: json['is_deleted'],
      user: json['user'],
    );
  }
}
