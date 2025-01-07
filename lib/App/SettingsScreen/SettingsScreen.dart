import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reqres_app/App/auth/login/loginScreen.dart';
import 'package:reqres_app/state/settingsState.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reqres_app/widget/DialogHelper.dart';
import 'package:reqres_app/widget/appNetworkImage.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingController settingController =
      GetInstance().put<SettingController>(SettingController());

  void onLangChange(LocaleWidgetPair i) {
    settingController.changeLang(i);
  }

  Future<void> userLogout() async {
    final action =
        await Dialogs.yesAbortDialog(context, 'Log Out?', 'Are you sure?');
    if (action == DialogAction.yes) {
      final box = GetStorage();
      box.remove('token');
      Get.offAll(LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    var localData = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localData.settingsscreen),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: userLogout,
          )
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 14,
          ),
          const Align(
            child: SizedBox(
              height: 140,
              width: 140,
              child: AppNetWorkIamge(
                  radius: 99,
                  imageUrl:
                      "https://imagecdn.jeevansathi.com/55571/10/1111430917-1735456703236.jpeg"),
            ),
          ),
          ListTile(
              title: Text(localData.them),
              subtitle: Text(localData.changeappthem),
              trailing: Obx((() => Switch(
                    value: settingController.isDark.value,
                    onChanged: (bool _) => settingController.toggleThem(),
                  )))),
          ...settingController.mixedList.map((e) {
            return ListTile(
                onTap: () {
                  onLangChange(e);
                },
                leading:
                    settingController.selectedLocal.value.locale == e.locale
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : const Icon(Icons.language),
                title: e.widget);
          }),
          ListTile(
            title: const Text("Logout"),
            subtitle: const Text("Logout form app"),
            onTap: userLogout,
          )
        ],
      ),
    );
  }
}
