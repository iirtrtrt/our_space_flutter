import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:our_space/exceptions/form_exceptions.dart';
import 'package:our_space/model/user_model.dart';
import 'package:our_space/repository/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository repository;

  RegisterBloc({required this.repository}) : super(RegisterFormState()) {
    on<RegisterRequestEvent>((event, emit) async {
      emit(RegisterLoadingState());
      try {
        // print('RegisterBloc');
        // print(event.username);
        // print(event.username);
        final success = await repository.register(
          email: event.email,
          username: event.username,
          password: event.password,
        );
        emit(RegisterSuccessState(
          success,
        ));
      } on FormGeneralException catch (e) {
        emit(RegisterErrorState(e));
      } on FormFieldsException catch (e) {
        emit(RegisterErrorState(e));
      } catch (e) {
        emit(RegisterErrorState(
          FormGeneralException(message: 'Unidentified error'),
        ));
      }
    });
  }
}
