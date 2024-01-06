import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/components/shared/icon_button.dart';
import 'package:socialmediaapp/screens/profile/components/platform_not_supported_dialog.dart';
import 'package:socialmediaapp/screens/profile/components/subscription_dialog.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:intl/intl.dart';


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
            child: StoreConnector<GlobalState, UserState>(
              onInit: (app) {
                store.dispatch(GetUserSubscriptionAction());
              },
              converter: (store) => store.state.appState.userState,
              builder: (context, userState) {
                return SingleChildScrollView(
                  child: 
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Your current plan'),
                      const Divider(),
                      const SizedBox(height: 16,),
                      userState.isSubscriptionLoading ? const LinearProgressIndicator() :
                      Column(
                        children: [
                          Text(
                            userState.user!.subscription!.isNotEmpty ? 'Plus' : 'Free',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4,),
                          Text(
                            userState.user!.subscription!.isNotEmpty ? 'USD \$2.99/month' : 'USD \$0/month',
                          )
                        ],
                      ),
                      const SizedBox(height: 16,),
                      ListTile(
                        leading: const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green,
                        ),
                        title: Text(
                          'Unlimited Post title and description generation',
                          style: userState.user!.subscription!.isEmpty ? const TextStyle(decoration: TextDecoration.lineThrough) : null,
                        ),
                      ),
                      if (userState.user!.subscription!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          const Divider(),
Text('Subscribed: ${DateFormat('dd MMMM yyyy').format(userState.user!.subscription![0].subscribedDate)}'),
Text('Expiries: ${DateFormat('dd MMMM yyyy').format(userState.user!.subscription![0].expirationDate)}'),

                          const Divider(),
                        ],),
                      const SizedBox(height: 40,),
                      Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          buildIconButton(
                            icon: Icons.arrow_back_rounded,
                            text: 'Back',
                            onPressed: () {
                              Navigator.pop(context);
                            }
                          ),
                          buildIconButton(
                            icon: Icons.check_circle_rounded,
                            text: 
                              userState.user!.subscription!.isNotEmpty
                              ? 'Cancel'
                              : 'Subscribe',
                            onPressed: () {
                              if (userState.user!.subscription!.isNotEmpty) {
                                store.dispatch(DeleteUserSubscriptionAction());
                              } else {
                                // Navigator.pop(context);
                                showSubscriptionDialog(context);
                              }
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



void showMySubscriptionDialog(BuildContext context) {

  AppLog.log().i('Showing subscription dialog.');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const SubscriptionDialog();
    }
  );
}
