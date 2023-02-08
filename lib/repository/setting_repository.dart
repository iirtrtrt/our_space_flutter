import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:our_space/exceptions/form_exceptions.dart';
import 'package:our_space/model/user_model.dart';
import 'package:our_space/repository/auth_repository.dart';
import 'package:our_space/utils/api.dart';

import 'package:our_space/utils/secure_storage.dart';

const String updateUserInfoPath = 'auth/updateuserinfo/';

class SettingRepository {
  final AuthRepository authRepository = AuthRepository();

  void saveUser(User user) async {
    await SecureStorage.storage.write(
      key: SecureStorage.userKey,
      value: user.toJson(),
    );
  }

  Future<User> updateUserInfo({
    required int id,
    required String username,
  }) async {
    final json = await SecureStorage.storage.read(
      key: SecureStorage.userKey,
    );

    final response = await http.patch(API.buildUri('$updateUserInfoPath$id'),
        headers: API.buildHeaders(
            accessToken: jsonDecode(json!)['tokens']['access']),
        body: jsonEncode({'username': username}));

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final newUsername = jsonDecode(response.body)['username'];
        final user = User(
          id: User.fromJson(jsonDecode(json)).id,
          email: User.fromJson(jsonDecode(json)).email,
          username: newUsername,
          accessToken: User.fromJson(jsonDecode(json)).accessToken,
          refreshToken: User.fromJson(jsonDecode(json)).refreshToken,
        );
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
