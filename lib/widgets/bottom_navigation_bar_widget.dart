import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_space/blocs/auth/auth_bloc.dart';
import 'package:our_space/screens/home_screen.dart';
import 'package:our_space/screens/setting/setting_screen.dart';

class BottomNavigationBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double _width = screenSize.width;
    double _height = screenSize.height;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: _width / 3,
                height: 52,
                color: Colors.red,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: _width / 3,
                height: 52,
                color: Colors.black,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ),
              ),
              Container(
                width: _width / 3,
                height: 52,
                color: Colors.red,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingScreen()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(48);
}
