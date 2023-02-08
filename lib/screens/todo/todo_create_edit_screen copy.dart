import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:our_space/screens/home_screen.dart';
import 'package:our_space/screens/todo/bloc/todo_bloc.dart';

class TodoCreateEditScreen extends StatefulWidget {
  const TodoCreateEditScreen({Key? key}) : super(key: key);

  @override
  _TodoCreateEditScreen createState() => _TodoCreateEditScreen();
}

class _TodoCreateEditScreen extends State<TodoCreateEditScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  void submitForm(BuildContext context) {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState?.value;
      context.read<TodoBloc>().add(
            TodoAddEvent(
              title: data!['title'],
              content: data['content'],
              startAt: data['startAt'],
              endAt: data['endAt'],
            ),
          );
    }
  }

  //앞에서 생성된 Todo Bloc을 계속해서 사용을 할것이다.
  // late TodoBloc _todoBloc;

  // @override
  // void initState() {
  //   super.initState();
  //   _todoBloc = BlocProvider.of<TodoBloc>(context);
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
        // BlocListener(
        //   listener: (BuildContext context, TodoState state) {},
        //   bloc: _todoBloc,
        //   //사실 BlcoBuilder의 경우 body 부분만 감싸주어도 충분하다.(appbar 부분에서는 변할것이 없기 때문이다.)
        //   child:
        BlocBuilder<TodoBloc, TodoState>(
            // bloc: _todoBloc,
            builder: (BuildContext context, TodoState state) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Todo Add"),
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: FormBuilder(
              key: _formKey,
              child: Builder(builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('할 일'),
                    FormBuilderTextField(
                      decoration: InputDecoration(hintText: '무엇을 하실건가요'),
                      // controller: _textEditingController,
                      name: 'title',
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text('메모'),
                    FormBuilderTextField(
                      onChanged: (value) => print(value),
                      cursorColor: Theme.of(context).primaryColor,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      // controller: _textEditingController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      name: 'content',
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text('start 날짜'),
                    FormBuilderDateTimePicker(
                      name: 'startAt',
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      // onChanged: (value) => print(value),
                    ),
                    const SizedBox(height: 16),
                    const Text('end 날짜'),
                    FormBuilderDateTimePicker(
                      name: 'endAt',
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      // onChanged: (value) => print(value),
                    ),
                    MaterialButton(
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
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        if (state is! TodoLoadingState) {
                          submitForm(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              }),
            ),
          ));
    });
    // );
  }
}
