import 'dart:convert';

import 'package:our_space/model/todo_model.dart';
import 'package:http/http.dart' as http;
import 'package:our_space/exceptions/form_exceptions.dart';
import 'package:our_space/utils/api.dart';

import 'package:our_space/utils/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _todoListPath = 'todo/list/';
const String _todoRecycleBinListPath = 'todo/recyclebinlist/';
const String _todoCreatePath = 'todo/create/';
const String _todoUpdateDestroyePath = 'todo/updatedestroy/';

class TodoRepository {
  Future<List<Todo>> getTodoList(int page) async {
    final json = await SecureStorage.storage.read(
      key: SecureStorage.userKey,
    );
    final prefs = await SharedPreferences.getInstance();
    final Map<String, String> queryParameters = {
      'page': page.toString(),
    };
    final response = await http.get(
      API.queryParametersBuildUri(
          path: _todoListPath, queryParameters: queryParameters),
      headers:
          API.buildHeaders(accessToken: jsonDecode(json!)['tokens']['access']),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        final TodoList todos = TodoList.fromJson(json);
        // print(todos.next);
        if (todos.next != null) {
          final int next = int.parse(todos.next![todos.next!.length - 1]);
          prefs.setInt('next', next);
        } else {
          prefs.setInt('next', 0);
        }
        return todos.todos;
      case 400:
        final json = jsonDecode(response.body);
        throw handleFormErrors(json);
      case 300:
      case 500:
      default:
        throw FormGeneralException(message: 'Error contacting the server!');
    }
  }

  Future<List<Todo>> getRecycleBinTodoList(int page) async {
    final json = await SecureStorage.storage.read(
      key: SecureStorage.userKey,
    );
    final prefs = await SharedPreferences.getInstance();
    final Map<String, String> queryParameters = {
      'page': page.toString(),
    };
    final response = await http.get(
      API.queryParametersBuildUri(
          path: _todoRecycleBinListPath, queryParameters: queryParameters),
      headers:
          API.buildHeaders(accessToken: jsonDecode(json!)['tokens']['access']),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        final TodoList todos = TodoList.fromJson(json);

        if (todos.next != null) {
          final int next = int.parse(todos.next![todos.next!.length - 1]);
          prefs.setInt('next', next);
        } else {
          prefs.setInt('next', 0);
        }
        return todos.todos;
      case 400:
        final json = jsonDecode(response.body);
        throw handleFormErrors(json);
      case 300:
      case 500:
      default:
        throw FormGeneralException(message: 'Error contacting the server!');
    }
  }

  Future<void> addTodo({
    required String title,
    required String content,
    required DateTime startAt,
    required DateTime endAt,
  }) async {
    final json = await SecureStorage.storage.read(
      key: SecureStorage.userKey,
    );

    final response = await http.post(
      API.buildUri(_todoCreatePath),
      headers:
          API.buildHeaders(accessToken: jsonDecode(json!)['tokens']['access']),
      body: jsonEncode(
        {
          'title': title,
          'content': content,
          'start_at': startAt.toString(),
          'end_at': endAt.toString(),
        },
      ),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        break;
      case 400:
        final json = jsonDecode(response.body);
        throw handleFormErrors(json);
      case 300:
      case 500:
      default:
        throw FormGeneralException(message: 'Error contacting the server!');
    }
  }

  Future<void> deleteTodo({
    required int id,
  }) async {
    final json = await SecureStorage.storage.read(
      key: SecureStorage.userKey,
    );

    final response = await http.delete(
      API.buildUri('$_todoUpdateDestroyePath$id'),
      headers:
          API.buildHeaders(accessToken: jsonDecode(json!)['tokens']['access']),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        break;
      case 400:
        final json = jsonDecode(response.body);
        throw handleFormErrors(json);
      case 300:
      case 500:
      default:
        throw FormGeneralException(message: 'Error contacting the server!');
    }
  }

  Future<void> updateTodo({
    required int id,
    bool? isDone,
    bool? isDeleted,
    String? title,
    String? content,
    DateTime? startAt,
    DateTime? endAt,
  }) async {
    final json = await SecureStorage.storage.read(
      key: SecureStorage.userKey,
    );
    dynamic body;

    if (isDone != null) {
      body = jsonEncode({
        'is_done': isDone,
      });
    } else if (isDeleted != null) {
      body = jsonEncode({
        'is_deleted': isDeleted,
      });
    } else {
      body = jsonEncode({
        'title': title,
        'content': content,
        'start_at': startAt.toString(),
        'end_at': endAt.toString(),
      });
    }

    final response = await http.patch(
        API.buildUri('$_todoUpdateDestroyePath$id'),
        headers: API.buildHeaders(
            accessToken: jsonDecode(json!)['tokens']['access']),
        body: body);

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        break;
      case 400:
        final json = jsonDecode(response.body);
        throw handleFormErrors(json);
      case 300:
      case 500:
      default:
        throw FormGeneralException(message: 'Error contacting the server!');
    }
  }
}
