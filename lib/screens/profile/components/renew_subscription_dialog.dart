import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/components/shared/icon_button.dart';
import 'package:socialmediaapp/components/shared/toast.dart';
import 'package:socialmediaapp/screens/mainlayout/components/notification_reducer.dart';
import 'package:socialmediaapp/screens/profile/components/platform_not_supported_dialog.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';


class SubscriptionDialog extends StatefulWidget {

  const SubscriptionDialog({
    Key? key,
  }) : super(key: key);

  @override
  _SubscriptionDialogState createState() => _SubscriptionDialogState();
}

class _SubscriptionDialogState extends State<SubscriptionDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 400,
        height: 400,
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
                      const Text('Subscribe to use AI'),
                      const Divider(),
                      const SizedBox(height: 16,),
                      const Column(
                        children: [
                          Text(
                            'Plus',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4,),
                          Text(
                            'USD \$2.99/month'
                          )
                        ],
                      ),
                      const SizedBox(height: 16,),
                      const ListTile(
                        leading:  Icon(Icons.check_circle_rounded),
                        title:  Text(
                          'Unlimited Post title and description generation'
                        ),
                      ),
                      const SizedBox(height: 40,),
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
                          buildIconButton(
                            icon: Icons.check_circle_rounded,
                            text: 'Checkout',
                            onPressed: () {
                              if (profileScreenState.user != null) {
                                if (!kIsWeb) {
                                  AppLog.log().i('started subscription action on IO.');
                                  store.dispatch(UpdateUserSubscriptionAction());
                                } else {
                                  showPlatformNotSupportedDialog(context);
                                  showToast(message: "Sorry, this feature is not supported on this platform.", bgColor: getNotificationColor(NotificationColor.blue), webBgColor: "blue");
                                  AppLog.log().i('started subscription action on Web.');
                                  // store.dispatch(SubscribeWebAction());
                                }
                              } else {
                                AppLog.log().i('User is null.');
                                showToast(message: "An error has occured. Please, try again later.", bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      )
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



void renewSubscriptionDialog(BuildContext context) {

  AppLog.log().i('Showing subscribe dialog.');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const SubscriptionDialog();
    }
  );
}
