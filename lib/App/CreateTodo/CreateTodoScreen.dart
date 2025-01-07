import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:reqres_app/state/userTodoState.dart';
import 'package:reqres_app/widget/appInputText.dart';
import 'package:reqres_app/widget/appText.dart';
import 'package:reqres_app/widget/buttons.dart';
import 'package:rules/rules.dart';

enum Calendar { pending, completed, inprogress }

class CreateTodoScreen extends StatefulWidget {
  const CreateTodoScreen({Key? key}) : super(key: key);

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
  Calendar calendarView = Calendar.pending;

  Future<void> attachFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      cropImage(result);
      setState(() {});
    } else {
      // User canceled the picker
    }
  }

  Future<void> cropImage(FilePickerResult? file) async {
    croppedFile = await ImageCropper().cropImage(
      sourcePath: file?.files.single.path ?? '',
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            // CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            // CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          ],
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    localFile = File(croppedFile!.path);
    setState(() {});
  }

  void createNewTodo() {
    if (_formKey.currentState!.validate()) {
      var parameter = {
        "title": titleController.text,
        "body": bodyController.text,
        "state": "pending"
      };
      userTodoController.createTodo(parameter, localFile);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                onPressed: attachFile,
                                icon: const Icon(Icons.attach_file_sharp))
                          ],
                          title: FadeInRight(
                              duration: const Duration(milliseconds: 500),
                              child: const Text("Create Todo"))),
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
                                  SegmentedButton<Calendar>(
                                    segments: const <ButtonSegment<Calendar>>[
                                      ButtonSegment<Calendar>(
                                          value: Calendar.pending,
                                          label: Text('Day'),
                                          icon: Icon(Icons.calendar_view_day)),
                                      ButtonSegment<Calendar>(
                                          value: Calendar.inprogress,
                                          label: Text('Month'),
                                          icon:
                                              Icon(Icons.calendar_view_month)),
                                      ButtonSegment<Calendar>(
                                          value: Calendar.completed,
                                          label: Text('Year'),
                                          icon: Icon(Icons.calendar_today)),
                                    ],
                                    selected: <Calendar>{calendarView},
                                    onSelectionChanged:
                                        (Set<Calendar> newSelection) {
                                      setState(() {
                                        calendarView = newSelection.first;
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
                                    child: const Center(
                                      child: Text(
                                        "Create",
                                        style: TextStyle(
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
