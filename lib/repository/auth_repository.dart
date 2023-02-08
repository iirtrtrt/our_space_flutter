import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:our_space/exceptions/form_exceptions.dart';
import 'package:our_space/exceptions/secure_storage_exceptions.dart';
import 'package:our_space/model/user_model.dart';
import 'package:our_space/utils/api.dart';

import 'package:our_space/utils/secure_storage.dart';

const String loginPath = 'auth/login/';
const String registerPath = 'auth/register/';
const String refreshPath = 'auth/refresh/';

class AuthRepository {
  Future<User> loadUser() async {
    final json = await SecureStorage.storage.read(
      key: SecureStorage.userKey,
    );

    if (json != null) {
      return User.fromJson(jsonDecode(json));
    } else {
      throw SecureStorageNotFoundException();
    }
  }

  void saveUser(User user) async {
    await SecureStorage.storage.write(
      key: SecureStorage.userKey,
      value: user.toJson(),
    );
  }

  Future<void> refreshToken(User user) async {
    final response = await http.post(
      API.buildUri(refreshPath),
      headers: API.buildHeaders(),
      body: jsonEncode(
        {
          'refresh': user.refreshToken,
        },
      ),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        user.accessToken = json['access'];
        saveUser(user);
        break;
      case 400:
      case 300:
      case 500:
      default:
        throw Exception('Error contacting the server!');
    }
  }

  Future<bool> register({
    required String email,
    required String username,
    required String password,
  }) async {
    print('$email $username $email');
    print('$email $username $email');
    print('$email $username $email');
    final response = await http.post(
      API.buildUri(registerPath),
      headers: API.buildHeaders(),
      body: jsonEncode(
        {
          'email': email,
          'username': username,
          'password': password,
        },
      ),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        // final json = jsonDecode(response.body);
        // final user = User.fromJson(json);

        // saveUser(user);

        return true;
      case 400:
        final json = jsonDecode(response.body);
        throw handleFormErrors(json);
      case 300:
      case 500:
      default:
        throw FormGeneralException(message: 'Error contacting the server!');
    }
  }

  Future<void> logout() async {
    await SecureStorage.storage.delete(
      key: SecureStorage.userKey,
    );
  }

  Future<User> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      API.buildUri(loginPath),
      headers: API.buildHeaders(),
      body: jsonEncode(
        {
          'email': email,
          'password': password,
        },
      ),
    );
    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        final user = User.fromJson(json);
        saveUser(user);

        return user;
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
