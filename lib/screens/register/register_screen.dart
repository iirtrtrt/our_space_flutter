import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:our_space/blocs/auth/auth_bloc.dart';
import 'package:our_space/exceptions/form_exceptions.dart';
import 'package:our_space/repository/auth_repository.dart';
import 'package:our_space/widgets/cellphone_field.dart';
import 'package:our_space/widgets/form_error_widget.dart';
import 'package:our_space/widgets/success_dialog.dart';

import 'bloc/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  String? password;
  bool enableBtn = false;

  void submitForm(BuildContext context) {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState?.value;
      // print(data!['username']);
      // print(data['username']);
      // print(data['username']);
      // print(data['username']);
      context.read<RegisterBloc>().add(
            RegisterRequestEvent(
              email: data!['email'],
              username: data['username'],
              password: data['password'],
            ),
          );
    }
  }

  Future<bool> popScreen(state) async {
    return state is! RegisterLoadingState;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocProvider(
          create: (context) => RegisterBloc(repository: AuthRepository()),
          child: BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccessState) {
                // context.read<AuthBloc>().add(
                //       AuthAuthenticateEvent(),
                //     );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SuccessDialog(
                      title: 'Success',
                      text: 'Your register was successful!',
                      buttonText: 'Continue',
                      onPressed: () {},
                    );
                  },
                );
              }
            },
            builder: (context, state) {
              return WillPopScope(
                onWillPop: () => popScreen(state),
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text("Sign Up"),
                    leading: IconButton(
                      onPressed: () async {
                        if (await popScreen(state)) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.arrow_back),
                      splashRadius: 23,
                    ),
                  ),
                  body: Builder(
                    builder: (_) {
                      return Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: FormBuilder(
                              key: _formKey,
                              child: Builder(builder: (context) {
                                if (state is RegisterErrorState) {
                                  if (state.exception is FormFieldsException) {
                                    for (var error in (state.exception
                                            as FormFieldsException)
                                        .errors
                                        .entries) {
                                      _formKey.currentState?.invalidateField(
                                        name: error.key,
                                        errorText: error.value,
                                      );
                                    }
                                  }
                                }

                                return Column(
                                  children: [
                                    Builder(builder: (context) {
                                      if (state is RegisterErrorState) {
                                        if (state.exception
                                            is FormGeneralException) {
                                          return Column(
                                            children: [
                                              FormErrorWidget(
                                                (state.exception
                                                        as FormGeneralException)
                                                    .message,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              )
                                            ],
                                          );
                                        }
                                      }
                                      return Container();
                                    }),
                                    FormBuilderTextField(
                                      name: 'email',
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Email',
                                      ),
                                      textInputAction: TextInputAction.next,
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                        FormBuilderValidators.email(),
                                      ]),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    FormBuilderTextField(
                                      name: 'username',
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Username',
                                      ),
                                      textInputAction: TextInputAction.next,
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                        FormBuilderValidators.match(
                                          r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$",
                                        ),
                                      ]),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    FormBuilderTextField(
                                      name: 'password',
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Password',
                                      ),
                                      obscureText: true,
                                      textInputAction: TextInputAction.done,
                                      onChanged: (value) {
                                        setState(() {
                                          password = value;
                                        });
                                      },
                                      // onSubmitted: (_) {
                                      //   if (state is! AuthLoadingState) {
                                      //     submitForm(context);
                                      //   }
                                      // },
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Re-enter password',
                                      ),
                                      obscureText: true,
                                      textInputAction: TextInputAction.done,
                                      onChanged: (value) {
                                        setState(() {
                                          if (value == password) {
                                            enableBtn = true;
                                          } else {
                                            enableBtn = false;
                                          }
                                        });
                                      },
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    MaterialButton(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      onPressed: () {
                                        if (state is! RegisterLoadingState &&
                                            enableBtn) {
                                          submitForm(context);
                                        }
                                      },
                                      child: (state is RegisterLoadingState)
                                          ? const Center(
                                              child: SizedBox(
                                                height: 15,
                                                width: 15,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            )
                                          : const SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                'Register',
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
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
