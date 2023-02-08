import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:our_space/blocs/auth/auth_bloc.dart';
import 'package:our_space/exceptions/secure_storage_exceptions.dart';
import 'package:our_space/model/user_model.dart';
import 'package:our_space/screens/login/login_screen.dart';
import 'package:our_space/screens/setting/bloc/setting_bloc.dart';
import 'package:our_space/screens/setting/edit_user_info_screen.dart';
import 'package:our_space/screens/todo/bloc/todo_bloc.dart';
import 'package:our_space/utils/secure_storage.dart';
import 'package:our_space/widgets/bottom_navigation_bar_widget.dart';
import 'package:our_space/widgets/setting_info_btn.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  void submitForm(BuildContext context) {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState?.value;
      context.read<SettingBloc>().add(
            SettingEditEvent(
              username: data!['username'],
            ),
          );
    }
  }

  final AsyncMemoizer _memoizer = AsyncMemoizer();
  late String username = 'error occured retry';
  Future<void> _getUsername() async {
    _memoizer.runOnce(() async {
      final json = await SecureStorage.storage.read(
        key: SecureStorage.userKey,
      );

      if (json != null) {
        username = User.fromJson(jsonDecode(json)).username;
      } else {
        throw SecureStorageNotFoundException();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
        builder: (BuildContext context, SettingState state) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('setting'),
            automaticallyImplyLeading: false,
          ),
          bottomNavigationBar: const BottomNavigationBarWidget(),
          body: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: FormBuilder(
              key: _formKey,
              child: Builder(builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: _getUsername(),
                      builder: (context, snapshot) {
                        return SettingInfoBtn(
                            title: 'username',
                            data: username,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditUserInfoScreen()),
                              );
                            });
                      },
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                        builder: (BuildContext context, AuthState state) {
                      return MaterialButton(
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthLogoutEvent());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: const Text(
                          'Logout',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }),
            ),
          ));
    });
  }
}
