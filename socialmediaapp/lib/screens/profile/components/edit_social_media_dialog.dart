import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/components/shared/error/cuctom_error_widget.dart';
import 'package:socialmediaapp/components/shared/icon_button.dart';
import 'package:socialmediaapp/components/shared/toast.dart';
import 'package:socialmediaapp/screens/mainlayout/components/notification_reducer.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/screens/user/user_model.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';



class EditSocialMediaLinksDialog extends StatefulWidget {
  final SocialMediaLink link;

  const EditSocialMediaLinksDialog({
    Key? key,
    required this.link,
  }) : super(key: key);

  @override
  _EditSocialMediaLinksDialogState createState() => _EditSocialMediaLinksDialogState();
}

class _EditSocialMediaLinksDialogState extends State<EditSocialMediaLinksDialog> {
  bool isAddingSocialMediaLink = false;
  String? selectedSocialMediaLinkId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  List<String> errors = [];

  @override
  void initState() {
    super.initState();

    initErrors();
  }

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
  Widget build(BuildContext context) {
    var state = StoreProvider.of<GlobalState>(context).state.appState.profileScreenState;

    return Dialog(
      child: SizedBox(
        width: 500,
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StoreConnector<GlobalState, List<SocialMediaLink>?>(
            onInit: (store) {
              _nameController.text = widget.link.name;
              _urlController.text = widget.link.url;
            },
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
                      const SizedBox(height: 20,),
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
                          icon: Icons.cancel,
                          text: 'Cancel',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        buildIconButton(
                          icon: Icons.delete,
                          text: 'Delete',
                          onPressed: () {
                            AppLog.log().i('Deleting social media link with id: ${widget.link.id}');
                            store.dispatch(DeleteUserSocialMediaLinksAction(widget.link.id));
                            AppLog.log().i('fetching user social media links');
                            store.dispatch(GetUserSocialMediaLinksAction(state.selectedUserId!));
                            Navigator.pop(context);
                            showToast(message: "You have deleted social media link", bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
                          },
                        ),
                        buildIconButton(
                          icon: Icons.save,
                          text: 'Save',
                          onPressed: () {
                            if (_nameController.text.isEmpty) {
                              addError(error: 'Please enter a name.');
                              return;
                            }
                            if (_urlController.text.isEmpty || !_urlController.text.contains('https://')) {
                              addError(error: 'Please enter a valid url.');
                              return;
                            }
                            AppLog.log().i('Saving social media link with id: ${widget.link.id}');
                            SocialMediaLink updatedLink = SocialMediaLink(
                              id: widget.link.id,
                              icon: widget.link.icon,
                              name: _nameController.text,
                              url: _urlController.text,
                            );
                            store.dispatch(UpdateUserSocialMediaLinksAction(widget.link.id, updatedLink));
                            if (state.errors.isNotEmpty) {
                              showToast(message: state.errors.first, bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
                            } else {
                              showToast(message: "Social Media Link was updated successfully. Please try to refresh window if don't see changes.", bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
                            }
                            AppLog.log().i('fetching user social media links');
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


void editSocialMediaLinkDialog(BuildContext context, SocialMediaLink link) {

  AppLog.log().i('Showing user profile edit SocialMediaLink dialog.');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditSocialMediaLinksDialog(link: link);
    }
  );
}