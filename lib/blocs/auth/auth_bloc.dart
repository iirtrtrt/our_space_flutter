import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:our_space/model/user_model.dart';
import 'package:our_space/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthLoadingState()) {
    on<AuthLogoutEvent>((event, emit) async {
      repository.logout();
      emit(AuthUnauthenticatedState());
    });

    on<AuthLoadUserEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        print('from load user bloc');
        User user = await repository.loadUser();
        await repository.refreshToken(user);
        emit(AuthAuthenticatedState(user: user));
      } catch (e) {
        emit(AuthUnauthenticatedState());
      }
    });

    on<AuthAuthenticateEvent>((event, emit) async {
      emit(AuthAuthenticatedState(user: event.user));
    });

    add(AuthLoadUserEvent());
  }
}
