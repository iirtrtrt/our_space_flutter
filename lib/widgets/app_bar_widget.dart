import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_space/blocs/auth/auth_bloc.dart';
import 'package:our_space/screens/login/login_screen.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AppBar(
          title: const Text("asdf"),
          automaticallyImplyLeading: false,
          // actions: [
          //   (state is AuthAuthenticatedState)
          //       ? IconButton(
          //           onPressed: () {
          //             context.read<AuthBloc>().add(AuthLogoutEvent());
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(builder: (context) => LoginScreen()),
          //             );
          //           },
          //           splashRadius: 23,
          //           icon: const Icon(
          //             Icons.logout,
          //           ),
          //         )
          //       : IconButton(
          //           onPressed: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(builder: (context) => LoginScreen()),
          //             );
          //           },
          //           splashRadius: 23,
          //           icon: const Icon(
          //             Icons.login,
          //           ),
          //         ),
          // ],
        );
      },
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(48);
}
