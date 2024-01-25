import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/components/promo/app_promo_dialog.dart';
import 'package:socialmediaapp/screens/settings/app/app_settings_dialog.dart';
import 'package:socialmediaapp/screens/settings/settings_reducer.dart';
import 'package:socialmediaapp/screens/settings/subscription/my_subscription_dialog.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = "/settings";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<GlobalState, SettingsState>(
      converter: (store) => store.state.appState.settingsState,
      builder: (context, settingsState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: Column(
            children: [
              Expanded(
                child: 
          ListView(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('App Settings'),
                onTap: () => showAppSettingsDialog(context),
              ),
              ListTile(
                leading: const Icon(Icons.subscriptions),
                title: const Text('My Subscription'),
                onTap: () => showMySubscriptionDialog(context),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () {
                  print('Sign Out');
                  store.dispatch(LogOutAction());
                  print('redirect to sign in screen');
                  // store.dispatch(ShowSignInScreenRequestAction());
                }
              ),
            ],
          ),
          ),
          if (kIsWeb)

              const AppPromoWidget()
        ],)
        );
      },
      onDispose: (store) {},
    );
  }
}