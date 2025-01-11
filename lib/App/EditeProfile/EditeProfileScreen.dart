import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:reqres_app/App/FileHelper/imagePicker.dart';
import 'package:reqres_app/AppConst/AppConst.dart';
import 'package:reqres_app/state/authState.dart';
import 'package:reqres_app/state/settingsState.dart';
import 'package:reqres_app/widget/appInputText.dart';
import 'package:reqres_app/widget/appNetworkImage.dart';
import 'package:reqres_app/widget/appText.dart';
import 'package:reqres_app/widget/buttons.dart';
import 'package:rules/rules.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<EditProfileScreen> {
  final SettingController settingController =
      GetInstance().put<SettingController>(SettingController());

  final AuthController authController =
      GetInstance().put<AuthController>(AuthController());

  final firstName = TextEditingController();
  final lastNmae = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? localFile;

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
    firstName.text = authController.userProfile.value?.firstName ?? "";
    lastNmae.text = authController.userProfile.value?.lastName ?? "";
    super.initState();
  }

  @override
  void dispose() {
    firstName.dispose();
    lastNmae.dispose();
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
                          title: FadeInRight(
                              duration: const Duration(milliseconds: 500),
                              child: const Text("Edit Profile"))),
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
                                  Obx(() {
                                    return Align(
                                      child: SizedBox(
                                        height: 140,
                                        width: 140,
                                        child: Stack(children: [
                                          ...?authController
                                              .userProfile.value?.files
                                              ?.map(
                                            (e) {
                                              return SizedBox(
                                                height: 140,
                                                width: 140,
                                                child: localFile != null
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(99),
                                                        image: DecorationImage(
                                                          image: FileImage(
                                                              localFile!),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ))
                                                    : AppNetWorkIamge(
                                                        radius: 99,
                                                        imageUrl:
                                                            "${SERVER_URL}/${e?.fileName ?? ""}"),
                                              );
                                            },
                                          ),
                                          Positioned(
                                              right: 1,
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            99),
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    color: Colors.white,
                                                  ),
                                                  child: IconButton(
                                                      onPressed: pickImage,
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.pink,
                                                      )))),
                                        ]),
                                      ),
                                    );
                                  }),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  const SmallText(
                                    text: "Edit your profile",
                                  ),
                                  InputText(
                                      textInputType: TextInputType.name,
                                      textEditingController: firstName,
                                      password: false,
                                      hint: "First Name",
                                      validator: (password) {
                                        final passWordRule = Rule(
                                          password,
                                          name: "First Name",
                                          isRequired: true,
                                        );
                                        if (passWordRule.hasError) {
                                          return passWordRule.error;
                                        } else {
                                          return null;
                                        }
                                      }),
                                  InputText(
                                      textEditingController: lastNmae,
                                      password: false,
                                      hint: "Last Name",
                                      validator: (password) {
                                        final passWordRule = Rule(
                                          password,
                                          name: "Last Name",
                                          isRequired: true,
                                        );
                                        if (passWordRule.hasError) {
                                          return passWordRule.error;
                                        } else {
                                          return null;
                                        }
                                      }),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  AppButton(
                                    function: () {
                                      if (_formKey.currentState!.validate()) {
                                        var parameter = {
                                          "firstName": firstName.text,
                                          "lastName": lastNmae.text,
                                        };
                                        authController.updateProfile(
                                            parameter, localFile);
                                      }
                                    },
                                    child: const Center(
                                      child: Text(
                                        "Update",
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
