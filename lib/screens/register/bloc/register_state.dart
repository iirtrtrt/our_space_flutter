part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterFormState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {
  // final User user;

  // const RegisterSuccessState(this.user);

  // @override
  // List<Object> get props => [user];
  // @override
  // List<Object> get props => [];

  final success;

  const RegisterSuccessState(this.success);

  @override
  List<Object> get props => [success];
}

class RegisterErrorState extends RegisterState {
  final Exception exception;

  const RegisterErrorState(this.exception);

  @override
  List<Object> get props => [exception];
}
