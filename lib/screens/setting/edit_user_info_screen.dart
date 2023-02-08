import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:our_space/exceptions/secure_storage_exceptions.dart';
import 'package:our_space/model/user_model.dart';
import 'package:our_space/repository/setting_repository.dart';
import 'package:our_space/screens/setting/bloc/setting_bloc.dart';
import 'package:our_space/screens/setting/setting_screen.dart';
import 'package:our_space/screens/todo/bloc/todo_bloc.dart';
import 'package:our_space/utils/secure_storage.dart';
import 'package:our_space/widgets/success_dialog.dart';

class EditUserInfoScreen extends StatelessWidget {
  EditUserInfoScreen({Key? key}) : super(key: key);
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
  final TextEditingController _textEditingController = TextEditingController();

  Future<void> _getUsername() async {
    _memoizer.runOnce(() async {
      final json = await SecureStorage.storage.read(
        key: SecureStorage.userKey,
      );

      if (json != null) {
        _textEditingController.text = User.fromJson(jsonDecode(json)).username;
      } else {
        throw SecureStorageNotFoundException();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
        builder: (BuildContext context, SettingState state) {
      return BlocProvider(
        create: (context) => SettingBloc(repository: SettingRepository()),
        child: BlocConsumer<SettingBloc, SettingState>(
          listener: (context, state) {
            if (state is SettingUpdatedState) {
              _getUsername();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingScreen()),
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    title: 'Success',
                    text: 'Updating your username was successful!',
                    buttonText: 'Continue',
                    onPressed: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingScreen()),
                      );
                    },
                  );
                },
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text('setting'),
                ),
                body: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: FormBuilder(
                    key: _formKey,
                    child: Builder(builder: (context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('username'),
                          FutureBuilder(
                            future: _getUsername(),
                            builder: (context, snapshot) {
                              // print(snapshot.data);
                              return FormBuilderTextField(
                                decoration:
                                    const InputDecoration(hintText: 'username'),
                                name: 'username',
                                controller: _textEditingController,
                              );
                            },
                          ),
                          MaterialButton(
                            color: Theme.of(context).colorScheme.secondary,
                            onPressed: () {
                              if (state is! TodoLoadingState) {
                                submitForm(context);
                                // _getUsername();
                              }
                            },
                            child: (state is TodoLoadingState)
                                ? const Center(
                                    child: SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : const SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      'submit',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      );
                    }),
                  ),
                ));
          },
        ),
      );
    });
  }
}
