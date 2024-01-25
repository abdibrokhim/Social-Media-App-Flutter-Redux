import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/components/shared/icon_button.dart';
import 'package:socialmediaapp/main.dart';
import 'package:socialmediaapp/screens/settings/settings_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';


class ChangeAppThemeWidget extends StatefulWidget {

  const ChangeAppThemeWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ChangeAppThemeWidgetState createState() => _ChangeAppThemeWidgetState();
}

class _ChangeAppThemeWidgetState extends State<ChangeAppThemeWidget> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return buildIconButton(
      icon: Icons.color_lens,
      text: 'Change App Theme',
      onPressed: () {
        print('Change App Theme');
        showThemeOptions(context);
      },
    );
  }


  void showThemeOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StoreConnector<GlobalState, SettingsState>(
      onDidChange: (prev, next) {
        setState(() {
        });
      },
      onInit: (store) {
            if (store.state.appState.settingsState.theme != null) {
    }
      },
      converter: (store) => store.state.appState.settingsState,
      builder: (context, settingsState) {
        var state = StoreProvider.of<GlobalState>(context);

        return
        Dialog(
          child: SizedBox(
            width: 400,
            height: 300,
            child:
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: 
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Change App Theme'),
                      const Divider(),
                      const SizedBox(height: 16,),
                      Row(
                        children: [
                          const Text('Light'),
                          const Spacer(),
                          Radio(
                            value: ThemeMode.light.index,
                            groupValue: settingsState.theme!.index,
                            onChanged: (value) {
                              print('settingsState.theme!.index: ${settingsState.theme!.index}');
                              store.dispatch(ChangeAppThemeAction(ThemeMode.light));
                              print('selected them => Light');
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Dark'),
                          const Spacer(),
                          Radio(
                            value: ThemeMode.dark.index,
                            groupValue: settingsState.theme!.index,
                            onChanged: (value) {
                              print('settingsState.theme!.index: ${settingsState.theme!.index}');
                              store.dispatch(ChangeAppThemeAction(ThemeMode.dark));
                              print('selected them => Dark');
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('System'),
                          const Spacer(),
                          Radio(
                            value: ThemeMode.system.index,
                            groupValue: settingsState.theme!.index,
                            onChanged: (value) {
                              print('settingsState.theme!.index: ${settingsState.theme!.index}');
                              store.dispatch(ChangeAppThemeAction(ThemeMode.system));
                              print('selected them => System');
                            },
                          ),
                        ],
                      ),
                    ]
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      buildIconButton(
                        icon: Icons.cancel_rounded,
                        text: 'Back',
                        onPressed: () {
                          Navigator.pop(context);
                        }
                      ),
                    ],
                  )
                    ],
                  )
              ),
          ),
        );
      }
    );
      }
    );
  }
}

