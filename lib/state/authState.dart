import 'package:get/get.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:reqres_app/network/auth_data_source.dart';
import 'package:reqres_app/network/model/result.dart';
import 'package:reqres_app/network/model/success_mutation.dart';
import 'package:reqres_app/network/model/user_proofile_response.dart';
import 'package:reqres_app/network/util/helper.dart';

class AuthController extends GetxController {
  Rx<UserProofileResponseUsers?> userProfile = UserProofileResponseUsers().obs;
  Rx<RefreshController> settingsController =
      RefreshController(initialRefresh: false).obs;
  final Rx<RefreshController> userAuthController =
      RefreshController(initialRefresh: false).obs;
  AuthDataSource apiResponse = AuthDataSource();

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    settingsController.value.dispose();
    super.onClose();
  }

  void updateProfile(parameter, file) {
    apiResponse.updateProfile(parameter, file).then((response) {
      if (response is SuccessState) {
        var res = response.value as SuccessMutation;
        if (res.success == true) {
          fetchUserProfile();
          Helper().goBack();
        }
      } else {}
    }).catchError((error) {});
    // userTodo.refresh();
  }

  void fetchUserProfile() {
    settingsController.value.footerMode?.value = LoadStatus.loading;
    apiResponse.getProfile().then((response) {
      if (response is SuccessState) {
        var res = response.value as UserProofileResponse;
        userProfile.value = res.users;
        settingsController.value.footerMode?.value = LoadStatus.idle;
      } else {
        settingsController.value.footerMode?.value = LoadStatus.failed;
      }
    }).catchError((error) {
      settingsController.value.footerMode?.value = LoadStatus.failed;
    });
  }
}
