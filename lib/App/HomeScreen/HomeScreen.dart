import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:reqres_app/App/SettingsScreen/SettingsScreen.dart';
import 'package:reqres_app/App/UserTodoScreen/UserTodoScreen.dart';
import 'package:reqres_app/state/authState.dart';

class AppMenuItem {
  final String id;
  final Widget widget;
  AppMenuItem(this.id, this.widget);
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find();

  @override
  void initState() {
    authController.fetchUserProfile();
    super.initState();
  }

  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
        body: IndexedStack(
          index: currentPageIndex,
          children: [const UserTodoScreen(), SettingsScreen()],
        ));
  }
}
