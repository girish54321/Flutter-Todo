import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reqres_app/App/CreateTodo/CreateTodoScreen.dart';
import 'package:reqres_app/App/SelectedTodoScreen/SelectedTodoScreen.dart';
import 'package:reqres_app/network/util/helper.dart';
import 'package:reqres_app/state/userTodoState.dart';
import 'package:reqres_app/widget/pullToLoadScreen.dart';

class UserTodoScreen extends StatefulWidget {
  const UserTodoScreen({Key? key}) : super(key: key);

  @override
  State<UserTodoScreen> createState() => _UserTodoScreenState();
}

class _UserTodoScreenState extends State<UserTodoScreen> {
  final UserTodoController userTodoController = Get.find();
  ScrollController? controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller!.position.extentAfter < 500) {
      userTodoController.loadTodoMore();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Obx((() {
        return PullToLoadList(
          onLoading: () => {},
          onRefresh: () => {userTodoController.getListOfTodo()},
          refreshController: userTodoController.userTodoListController.value,
          child: ListView.builder(
            controller: controller,
            itemCount: userTodoController.userTodo.value.todo?.length,
            itemBuilder: (context, index) {
              var item = userTodoController.userTodo.value.todo?[index];
              return Container(
                margin: const EdgeInsets.only(left: 14, right: 14, bottom: 8),
                child: CardExample(
                    onPressed: () {
                      userTodoController.selectTodo(item);
                      Helper().goToPage(
                          context: context, child: const SelectedTodoScreen());
                    },
                    title: item?.title ?? "",
                    body: item?.body ?? ""),
              );
            },
          ),
        );
      })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Helper().goToPage(
              context: context,
              child: const CreateTodoScreen(
                isUpdate: false,
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CardExample extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback? onPressed;
  const CardExample(
      {Key? key, required this.title, required this.body, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(title),
              subtitle: Text(body),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: onPressed,
                  child: const Text('MARK DONE'),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
