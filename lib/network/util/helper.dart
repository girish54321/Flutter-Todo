import 'dart:convert';
import 'dart:io';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:get/get.dart';
import 'package:reqres_app/App/auth/login/loginScreen.dart';
import 'package:reqres_app/network/model/errorModal.dart';
import 'package:reqres_app/widget/DialogHelper.dart';

class Helper {
  goToPage({required BuildContext context, required Widget child}) {
    if (Platform.isAndroid) {
      Navigator.push(context,
          PageTransition(type: PageTransitionType.rightToLeft, child: child));
    }
    if (Platform.isIOS) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => child,
        ),
      );
    }
  }

  createErrorModal(response) {
    var error = ApiError.fromJson(json.decode(response.body));
    if (error.error?.status == 401) {
      final box = GetStorage();
      box.remove('token');
      Get.offAll(LoginScreen());
    }
    DialogHelper.showErrorDialog(
        title: "Error Code: ${error.error!.status}",
        description: error.error?.message ?? "");
  }

  showMessage(String message, BuildContext context) {
    // Fluttertoast.showToast(
    //     msg: message,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.tealAccent,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  dismissKeyBoard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  showLoading([String? message]) {
    DialogHelper.showLoading(message);
  }

  hideLoading() {
    Get.until((route) => !Get.isDialogOpen!);
  }

  goBack() {
    Get.back();
  }
}
