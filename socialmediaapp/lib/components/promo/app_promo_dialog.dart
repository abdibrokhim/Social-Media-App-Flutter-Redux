import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socialmediaapp/components/shared/icon_button.dart';
import 'package:socialmediaapp/components/shared/toast.dart';
import 'package:socialmediaapp/screens/mainlayout/components/notification_reducer.dart';
import 'package:socialmediaapp/screens/profile/components/platform_not_supported_dialog.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';


class AppPromoDialog extends StatefulWidget {

  const AppPromoDialog({
    Key? key,
  }) : super(key: key);

  @override
  _AppPromoDialogState createState() => _AppPromoDialogState();
}

class _AppPromoDialogState extends State<AppPromoDialog> {

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
                      const Text('Download the app'),
                      const Divider(),
                      const SizedBox(height: 16,),
                      const ListTile(
                        leading:  Icon(Icons.check_circle_rounded),
                        title:  Text(
                          'Download the app for best experience',
                        ),
                      ),
                      const SizedBox(height: 40,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              print('tapped on download app form play store');
                            },
                            child:
                          Image.network(
                            'https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png',
                            height: 50,
                          ),
                          ),
                          const SizedBox(width: 16,),
                          InkWell(
                            onTap: () {
                              print('tapped on download app form app store');
                            },
                            child:
                          Image.network(
                            'https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg',
                            height: 50,
                          ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          buildIconButton(
                            icon: Icons.cancel_rounded,
                            text: 'Dismiss',
                            onPressed: () {
                              Navigator.pop(context);
                            }
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



void showAppPromoDialog(BuildContext context) {

  AppLog.log().i('Showing AppPromoDialog .');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AppPromoDialog();
    }
  );
}


class AppPromoWidget extends StatelessWidget {

  const AppPromoWidget({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                     Text(
                          'Download the app for best experience',
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              print('tapped on download app form play store');
                            },
                            child:
                          Image.asset(
                            '/en_badge_web_generic.png',
                            height: 50,
                            semanticLabel: 'Play Store Logo',
                          ),
                          ),
                          const SizedBox(width: 8,),
                          InkWell(
                            onTap: () {
                              print('tapped on download app form app store');
                            },
                            child:
                            SvgPicture.network(
                            'https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg',
                              semanticsLabel: 'App Store Logo'
                            ),
                            ),
                        ],
                      ),
                    const SizedBox(height: 32,),
                    ],
                  );
  }
}
