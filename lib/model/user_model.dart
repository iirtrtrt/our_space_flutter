import 'dart:convert';

class User {
  int id;
  String email;
  String username;
  String accessToken;
  String refreshToken;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  });
  // {
  //   if (isValidRefreshToken()) {
  //     getNewToken();
  //   } else {
  //     throw InvalidUserException();
  //   }
  // }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      refreshToken: json['tokens']['refresh'],
      accessToken: json['tokens']['access'],
    );
  }
  // factory User.fromJson(Map<String, dynamic> json) {
  //   final user = User(
  //     id: json['id'],
  //     email: json['email'],
  //     username: json['username'],
  //     refreshToken: json['tokens']['refresh'],
  //     accessToken: json['tokens']['access'],
  //   );
  //   if (user.isValidRefreshToken()) {
  //     return user;
  //   } else {
  //     throw InvalidUserException();
  //   }
  // }

  // bool isValidRefreshToken() {
  //   final jwtData = JwtDecoder.decode(refreshToken);
  //   return jwtData['exp'] < DateTime.now().millisecondsSinceEpoch;
  // }

  // void getNewToken() async {
  //   final jwtData = JwtDecoder.decode(accessToken);
  //   await Future.delayed(
  //     Duration(
  //       milliseconds:
  //           jwtData['exp'] * 1000 - DateTime.now().millisecondsSinceEpoch,
  //     ),
  //     () async {
  //       try {
  //         await AuthService.refreshToken(this);
  //       } catch (e) {}
  //     },
  //   );
  //   getNewToken();
  // }

  String toJson() {
    return jsonEncode(
      {
        'id': id,
        'email': email,
        'username': username,
        "tokens": {"refresh": refreshToken, "access": accessToken},
      },
    );
  }
}
