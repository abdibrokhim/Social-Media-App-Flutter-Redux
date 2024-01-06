import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/components/shared/error/cuctom_error_widget.dart';
import 'package:socialmediaapp/components/shared/icon_button.dart';
import 'package:socialmediaapp/screens/mainlayout/components/notification_reducer.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/screens/user/user_model.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:socialmediaapp/utils/constants.dart';

import '../../../components/shared/toast.dart';


class AddSocialMediaLinksDialog extends StatefulWidget {

  const AddSocialMediaLinksDialog({
    Key? key,
  }) : super(key: key);

  @override
  _AddSocialMediaLinksDialogState createState() => _AddSocialMediaLinksDialogState();
}

class _AddSocialMediaLinksDialogState extends State<AddSocialMediaLinksDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  String? selectedIconUrl;

  @override
  void initState() {
    super.initState();

    initErrors();
  }

  List<String> errors = [];

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void initErrors() {
    setState(() {
      errors = [];
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<GlobalState>(context).state.appState.profileScreenState;

    return Dialog(
      child: SizedBox(
        width: 500,
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StoreConnector<GlobalState, List<SocialMediaLink>?>(
            converter: (store) => store.state.appState.profileScreenState.user!.socialMediaLinks,
            builder: (context, socialMediaLinks) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Edit Social Media Link'),
                    const Divider(),
                    if (errors.isNotEmpty)
                      CustomErrorWidget(
                        errors: errors
                      ),
                    const SizedBox(height: 20),
                    DropdownButton<String>(
                      value: selectedIconUrl,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedIconUrl = newValue;
                          if (newValue!.isNotEmpty) {
                            removeError(error: 'Please select an icon.');
                          }
                        });
                        AppLog.log().i('Selected icon url: $selectedIconUrl');
                        AppLog.log().i('Selected icon id: ${socialMediaIcons.indexOf(selectedIconUrl!)}');
                      },
                      items: socialMediaIcons.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Image.network(value, width: 20, height: 20), // Display icon in dropdown
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'name'),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(error: 'Please enter a name.');
                        }
                      },
                    ),
                    TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(labelText: 'url'),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(error: 'Please enter a valid url.');
                        }
                      },
                    ),
                    Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        buildIconButton(
                          icon: Icons.delete,
                          text: 'Cancel',
                          onPressed: () {
                            _nameController.clear();
                            _urlController.clear();
                            Navigator.pop(context);
                          },
                        ),
                        buildIconButton(
                          icon: Icons.save,
                          text: 'Save',
                          onPressed: () {
                            if (selectedIconUrl == null) {
                              addError(error: 'Please select an icon.');
                              return;
                            }
                            if (_nameController.text.isEmpty) {
                              addError(error: 'Please enter a name.');
                              return;
                            }
                            if (_urlController.text.isEmpty || !_urlController.text.contains('https://')) {
                              addError(error: 'Please enter a valid url.');
                              return;
                            }

                            AddSocialMediaLink updatedLink = AddSocialMediaLink(
                              icon: selectedIconUrl!,
                              name: _nameController.text,
                              url: _urlController.text,
                            );

                            store.dispatch(AddUserSocialMediaLinksAction(updatedLink));
                            if (state.errors.isNotEmpty) {
                              showToast(message: state.errors.first!, bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
                            } else {
                              showToast(message: "Social Media Link was added successfully. Please, refresh window if don't see changes.", bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
                            }
                            initErrors();
                            AppLog.log().i('Fetching user social media links');
                            store.dispatch(GetUserSocialMediaLinksAction(state.selectedUserId!));
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
                  ]
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}


void addSocialMediaLinkDialog(BuildContext context) {

  AppLog.log().i('Showing user profile add SocialMediaLink dialog.');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AddSocialMediaLinksDialog();
    }
  );
}