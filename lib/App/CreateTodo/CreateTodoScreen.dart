import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:reqres_app/App/FileHelper/imagePicker.dart';
import 'package:reqres_app/state/userTodoState.dart';
import 'package:reqres_app/widget/appInputText.dart';
import 'package:reqres_app/widget/appText.dart';
import 'package:reqres_app/widget/buttons.dart';
import 'package:rules/rules.dart';

enum TodoStateEnum {
  pending,
  inProgress,
  completed,
}

extension TodoStatExtension on TodoStateEnum {
  String get name {
    switch (this) {
      case TodoStateEnum.pending:
        return 'pending';
      case TodoStateEnum.completed:
        return 'completed';
      case TodoStateEnum.inProgress:
        return 'in-progress';
      default:
        return "";
    }
  }
}

class CreateTodoScreen extends StatefulWidget {
  final bool isUpdate;
  const CreateTodoScreen({Key? key, required this.isUpdate}) : super(key: key);

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserTodoController userTodoController = Get.find();
  CroppedFile? croppedFile;
  File? localFile;
  TodoStateEnum todoStateEnum = TodoStateEnum.pending;

  void updateTodo() {
    if (_formKey.currentState!.validate()) {
      var parameter = {
        "toDoId": userTodoController.selectedTodo.value?.toDoId ?? 0,
        "title": titleController.text,
        "body": bodyController.text,
        "state": todoStateEnum.name
      };
      userTodoController.updateSelectedTodo(parameter);
    }
  }

  void createNewTodo() {
    if (widget.isUpdate) {
      updateTodo();
      return;
    }
    if (_formKey.currentState!.validate()) {
      var parameter = {
        "title": titleController.text,
        "body": bodyController.text,
        "state": todoStateEnum.name
      };
      userTodoController.createTodo(parameter, localFile);
    }
  }

  void autoFill() {
    if (widget.isUpdate == true) {
      titleController.text = userTodoController.selectedTodo.value?.title ?? "";
      bodyController.text = userTodoController.selectedTodo.value?.body ?? "";
      todoStateEnum = TodoStateEnum.values.firstWhere(
        (item) => item.name == userTodoController.selectedTodo.value?.state,
      );
    }
  }

  Future<void> pickImage() async {
    var file = await Imagepicker().imagePicker();
    if (file != null) {
      setState(() {
        localFile = file;
      });
    }
  }

  @override
  void initState() {
    autoFill();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isUpdate = widget.isUpdate;
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                          actions: [
                            IconButton(
                                onPressed: pickImage,
                                icon: const Icon(Icons.attach_file_sharp))
                          ],
                          title: FadeInRight(
                              duration: const Duration(milliseconds: 500),
                              child: Text(
                                  isUpdate ? "Edit Todo" : "Create Todo"))),
                      Column(
                        children: [
                          FadeInRight(
                            duration: const Duration(milliseconds: 500),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  const AppTextH2(
                                    fontWeight: FontWeight.bold,
                                    text: "Create Todo",
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const SmallText(
                                    text: "Create your todo here",
                                  ),
                                  InputText(
                                      textInputType: TextInputType.name,
                                      textEditingController: titleController,
                                      password: false,
                                      hint: "Title",
                                      validator: (password) {
                                        final passWordRule = Rule(
                                          password,
                                          name: "Title",
                                          isRequired: true,
                                        );
                                        if (passWordRule.hasError) {
                                          return passWordRule.error;
                                        } else {
                                          return null;
                                        }
                                      }),
                                  InputText(
                                      textEditingController: bodyController,
                                      password: false,
                                      hint: "Body",
                                      validator: (password) {
                                        final passWordRule = Rule(
                                          password,
                                          name: "Body",
                                          isRequired: true,
                                        );
                                        if (passWordRule.hasError) {
                                          return passWordRule.error;
                                        } else {
                                          return null;
                                        }
                                      }),
                                  localFile != null
                                      ? Image.file(localFile!)
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SegmentedButton<TodoStateEnum>(
                                    segments: const <ButtonSegment<
                                        TodoStateEnum>>[
                                      ButtonSegment<TodoStateEnum>(
                                        value: TodoStateEnum.pending,
                                        label: Text("Pending"),
                                      ),
                                      ButtonSegment<TodoStateEnum>(
                                        value: TodoStateEnum.inProgress,
                                        label: Text('in Progress'),
                                      ),
                                      ButtonSegment<TodoStateEnum>(
                                        value: TodoStateEnum.completed,
                                        label: Text('Completed'),
                                      ),
                                    ],
                                    selected: <TodoStateEnum>{todoStateEnum},
                                    onSelectionChanged:
                                        (Set<TodoStateEnum> newSelection) {
                                      setState(() {
                                        todoStateEnum = newSelection.first;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  AppButton(
                                    function: () {
                                      createNewTodo();
                                    },
                                    child: Center(
                                      child: Text(
                                        isUpdate ? "Edit Todo" : "Create",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Text(""),
                      const Text("")
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }
}
