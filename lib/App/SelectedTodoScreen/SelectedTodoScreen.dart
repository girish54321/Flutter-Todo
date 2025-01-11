import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reqres_app/App/CreateTodo/CreateTodoScreen.dart';
import 'package:reqres_app/App/HomeScreen/HomeScreen.dart';
import 'package:reqres_app/AppConst/AppConst.dart';
import 'package:reqres_app/network/util/helper.dart';
import 'package:reqres_app/state/userTodoState.dart';
import 'package:reqres_app/widget/DialogHelper.dart';
import 'package:reqres_app/widget/appNetworkImage.dart';
import 'package:reqres_app/widget/appText.dart';

class SelectedTodoScreen extends StatefulWidget {
  const SelectedTodoScreen({Key? key}) : super(key: key);

  @override
  State<SelectedTodoScreen> createState() => _SelectedTodoScreenState();
}

class _SelectedTodoScreenState extends State<SelectedTodoScreen> {
  final UserTodoController userTodoController = Get.find();

  Future<void> deleteTodo() async {
    final action =
        await Dialogs.yesAbortDialog(context, 'Log Out?', 'Are you sure?');
    if (action == DialogAction.yes) {
      userTodoController.deleteTodo(
        (item) {
          if (item.success == true) {
            Helper().goBack();
          }
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    userTodoController.getSelctedTodoInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Obx((() {
      return Scaffold(
        appBar: AppBar(
          title: Text(userTodoController.selectedTodo.value?.title ?? ""),
          actions: [
            PopupMenuButton<String>(
              onSelected: (val) {
                if (val == "delete") {
                  deleteTodo();
                  return;
                } else {
                  Helper().goToPage(
                      context: context,
                      child: const CreateTodoScreen(isUpdate: true));
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  AppMenuItem(
                      "delete",
                      const ListTile(
                        title: Text("Delete"),
                        leading: Icon(Icons.delete),
                      )),
                  AppMenuItem(
                      "edit",
                      const ListTile(
                        title: Text("Edit"),
                        leading: Icon(Icons.edit),
                      )),
                ].map((AppMenuItem choice) {
                  return PopupMenuItem<String>(
                      value: choice.id, child: choice.widget);
                }).toList();
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(
                  left: 14, right: 14, bottom: 8, top: 14),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...?userTodoController.selectedTodo.value?.files
                          ?.map((e) {
                        return SizedBox(
                          height: 180,
                          child: AppNetWorkIamge(
                              imageUrl: "${SERVER_URL}/${e?.fileName ?? ""}"),
                        );
                      }),
                      AppTextH2(
                        text:
                            userTodoController.selectedTodo.value?.title ?? "",
                        fontWeight: FontWeight.bold,
                      ),
                      AppTextP1(
                        text: userTodoController.selectedTodo.value?.body ?? "",
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }));
  }
}
