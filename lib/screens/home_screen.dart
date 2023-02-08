import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_space/screens/todo/bloc/todo_bloc.dart';
import 'package:our_space/screens/todo/todo_create_edit_screen.dart';
import 'package:our_space/widgets/bottom_navigation_bar_widget.dart';
import 'package:our_space/widgets/app_bar_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TodoBloc>(context).add(const TodoGetListEvent(page: 1));
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    BlocProvider.of<TodoBloc>(context).add(const TodoGetListEvent(page: 1));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    final prefs = await SharedPreferences.getInstance();
    final next = prefs.getInt('next');
    if (next != null || next! != 0) {
      BlocProvider.of<TodoBloc>(context).add(TodoGetListEvent(page: next));
      if (mounted) setState(() {});
      _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      bottomNavigationBar: BottomNavigationBarWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TodoCreateEditScreen()),
          );
        },
        child: const Icon(
          Icons.edit,
        ),
      ),
      body: Column(
        children: [
          // TextField(
          //   onChanged: (val) {
          //     this.title = val;
          //   },
          // ),
          SizedBox(height: 16.0),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (_, state) {
                if (state is TodoEmptyState) {
                  return Container();
                } else if (state is TodoErrorState) {
                  return const Center(
                    child: Text('error occured'),
                  );
                } else if (state is TodoLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TodoLoadedState) {
                  final items = state.todos;

                  return SmartRefresher(
                    enablePullDown: true,
                    // enablePullUp: true,
                    header: WaterDropHeader(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    // onLoading: _onLoading,
                    child: ListView.separated(
                      itemBuilder: (_, index) {
                        final item = items[index];

                        return Row(
                          children: [
                            Checkbox(value: item.isDone, onChanged: (_) {}),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(item.title),
                                      Spacer(),
                                      IconButton(
                                          onPressed: (() {
                                            BlocProvider.of<TodoBloc>(context)
                                                .add(
                                              TodoRecycleEvent(
                                                  id: item.id, isDeleted: true),
                                            );
                                          }),
                                          icon: const Icon(Icons.delete))
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        'start at ${item.startAt.substring(0, 10)}, end at ${item.endAt.substring(0, 10)}'),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (_, index) => const Divider(),
                      itemCount: items.length,
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
