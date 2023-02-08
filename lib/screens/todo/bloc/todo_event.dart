part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

class TodoGetListEvent extends TodoEvent {
  final int page;

  const TodoGetListEvent({required this.page});

  @override
  List<Object> get props => [page];
}

class TodoGetRecycleBinListEvent extends TodoEvent {
  final int page;

  const TodoGetRecycleBinListEvent({required this.page});

  @override
  List<Object> get props => [page];
}

class TodoAddEvent extends TodoEvent {
  final String title;
  final String content;
  final DateTime startAt;
  final DateTime endAt;

  const TodoAddEvent({
    required this.title,
    required this.content,
    required this.startAt,
    required this.endAt,
  });

  @override
  List<Object?> get props => [title, content, startAt, endAt];
}

class TodoDeleteEvent extends TodoEvent {
  final int id;

  const TodoDeleteEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

class TodoRecycleEvent extends TodoEvent {
  final int id;
  final bool isDeleted;

  const TodoRecycleEvent({
    required this.id,
    required this.isDeleted,
  });

  @override
  List<Object?> get props => [id, isDeleted];
}

class TodoDoneEvent extends TodoEvent {
  final int id;
  final bool isDone;

  const TodoDoneEvent({
    required this.id,
    required this.isDone,
  });

  @override
  List<Object?> get props => [id, isDone];
}

class TodoEditEvent extends TodoEvent {
  final int id;
  final String title;
  final String content;
  final DateTime startAt;
  final DateTime endAt;

  const TodoEditEvent({
    required this.id,
    required this.title,
    required this.content,
    required this.startAt,
    required this.endAt,
  });

  @override
  List<Object?> get props => [id, title, content, startAt, endAt];
}
