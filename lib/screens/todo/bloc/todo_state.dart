part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoEmptyState extends TodoState {}

class TodoLoadingState extends TodoState {}

class TodoLoadedState extends TodoState {
  final List<Todo> todos;

  const TodoLoadedState({
    required this.todos,
  });

  @override
  List<Object> get props => [todos];
}

class TodoAddedState extends TodoState {}

class TodoErrorState extends TodoState {
  final Exception exception;

  const TodoErrorState(this.exception);

  @override
  List<Object> get props => [exception];
}
