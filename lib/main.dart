import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_space/repository/auth_repository.dart';
import 'package:our_space/repository/setting_repository.dart';
import 'package:our_space/repository/todo_repository.dart';
import 'package:our_space/screens/home_screen.dart';
import 'package:our_space/screens/login/login_screen.dart';
import 'package:our_space/screens/setting/bloc/setting_bloc.dart';
import 'package:our_space/screens/todo/bloc/todo_bloc.dart';
import 'package:our_space/screens/splash_screen.dart';

import 'blocs/auth/auth_bloc.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) =>
              AuthBloc(repository: AuthRepository()),
        ),
        BlocProvider<TodoBloc>(
          create: (BuildContext context) =>
              TodoBloc(repository: TodoRepository()),
        ),
        BlocProvider<SettingBloc>(
          create: (BuildContext context) =>
              SettingBloc(repository: SettingRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Pet Home',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'NotoSans',
        ),
        // routes: {
        //   // "/todoList": (BuildContext context) => TodoList(),
        //   // "/todoAdd": (BuildContext context) => TodoAdd(),
        // },
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const SplashScreen();
            }
            return (state is AuthAuthenticatedState)
                ? HomeScreen()
                : LoginScreen();
          },
        ),
      ),
    );
  }
}
