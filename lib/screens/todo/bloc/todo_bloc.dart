import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:our_space/exceptions/form_exceptions.dart';
import 'package:our_space/model/todo_model.dart';
import 'package:our_space/repository/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc({required this.repository}) : super(TodoEmptyState()) {
    on<TodoGetListEvent>((event, emit) async {
      emit(TodoLoadingState());
      try {
        final todos = await repository.getTodoList(event.page);
        // print(todos);
        emit(TodoLoadedState(todos: todos));
      } on FormGeneralException catch (e) {
        emit(TodoErrorState(e));
      } on FormFieldsException catch (e) {
        emit(TodoErrorState(e));
      } catch (e) {
        emit(TodoErrorState(
          FormGeneralException(message: 'Unidentified error'),
        ));
      }
    });
    on<TodoGetRecycleBinListEvent>((event, emit) async {
      emit(TodoLoadingState());
      try {
        final todos = await repository.getRecycleBinTodoList(event.page);
        // print(todos);
        emit(TodoLoadedState(todos: todos));
      } on FormGeneralException catch (e) {
        emit(TodoErrorState(e));
      } on FormFieldsException catch (e) {
        emit(TodoErrorState(e));
      } catch (e) {
        emit(TodoErrorState(
          FormGeneralException(message: 'Unidentified error'),
        ));
      }
    });

    on<TodoAddEvent>((event, emit) async {
      emit(TodoLoadingState());
      try {
        await repository.addTodo(
          title: event.title,
          content: event.content,
          startAt: event.startAt,
          endAt: event.endAt,
        );
        emit(TodoAddedState());
      } on FormGeneralException catch (e) {
        emit(TodoErrorState(e));
      } on FormFieldsException catch (e) {
        emit(TodoErrorState(e));
      } catch (e) {
        emit(TodoErrorState(
          FormGeneralException(message: 'Unidentified error'),
        ));
      }
    });

    on<TodoDeleteEvent>((event, emit) async {
      emit(TodoLoadingState());
      try {
        await repository.deleteTodo(
          id: event.id,
        );
        final todos = await repository.getTodoList(1);

        emit(TodoLoadedState(todos: todos));
      } on FormGeneralException catch (e) {
        emit(TodoErrorState(e));
      } on FormFieldsException catch (e) {
        emit(TodoErrorState(e));
      } catch (e) {
        emit(TodoErrorState(
          FormGeneralException(message: 'Unidentified error'),
        ));
      }
    });

    on<TodoRecycleEvent>((event, emit) async {
      emit(TodoLoadingState());
      try {
        await repository.updateTodo(
          id: event.id,
          isDeleted: event.isDeleted,
        );
        final todos = await repository.getTodoList(1);

        emit(TodoLoadedState(todos: todos));
      } on FormGeneralException catch (e) {
        emit(TodoErrorState(e));
      } on FormFieldsException catch (e) {
        emit(TodoErrorState(e));
      } catch (e) {
        emit(TodoErrorState(
          FormGeneralException(message: 'Unidentified error'),
        ));
      }
    });
  }
}
