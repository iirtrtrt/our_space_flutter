import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:our_space/exceptions/form_exceptions.dart';
import 'package:our_space/model/user_model.dart';
import 'package:our_space/repository/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repository;

  LoginBloc({required this.repository}) : super(LoginFormState()) {
    on<LoginRequestEvent>((event, emit) async {
      emit(LoginLoadingState());
      try {
        final user = await repository.login(
          email: event.email,
          password: event.password,
        );
        emit(LoginSuccessState(
          user,
        ));
      } on FormGeneralException catch (e) {
        emit(LoginErrorState(e));
      } on FormFieldsException catch (e) {
        emit(LoginErrorState(e));
      } catch (e) {
        emit(LoginErrorState(
          FormGeneralException(message: 'Unidentified error'),
        ));
      }
    });
  }
}
