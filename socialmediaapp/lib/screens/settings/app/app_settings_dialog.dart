import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/components/shared/icon_button.dart';
import 'package:socialmediaapp/components/shared/toast.dart';
import 'package:socialmediaapp/screens/mainlayout/components/notification_reducer.dart';
import 'package:socialmediaapp/screens/profile/components/platform_not_supported_dialog.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/screens/settings/app/components/app_theme.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';


class AppSettingsDialog extends StatefulWidget {

  const AppSettingsDialog({
    Key? key,
  }) : super(key: key);

  @override
  _AppSettingsDialogState createState() => _AppSettingsDialogState();
}

class _AppSettingsDialogState extends State<AppSettingsDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 500,
        height: 500,
        child:
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: StoreConnector<GlobalState, ProfileScreenState>(
              onInit: (store) {
              },
              converter: (store) => store.state.appState.profileScreenState,
              builder: (context, profileScreenState) {
                return SingleChildScrollView(
                  child: 
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('App Settings'),
                      const Divider(),
                      const SizedBox(height: 16,),
                      ChangeAppThemeWidget()
                    ]
                  ),
                );
              },
              onDispose: (store) {},
            ),
          ),
      ),
    );
  }
}


void showAppSettingsDialog(BuildContext context) {

  AppLog.log().i('Showing app settings dialog.');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AppSettingsDialog();
    }
  );
}
