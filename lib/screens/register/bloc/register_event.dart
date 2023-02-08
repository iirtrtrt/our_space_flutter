part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterRequestEvent extends RegisterEvent {
  final String email;
  final String username;
  final String password;

  const RegisterRequestEvent({
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
