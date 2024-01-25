import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/components/shared/confirmation_dialog.dart';
import 'package:socialmediaapp/components/shared/icon_button.dart';
import 'package:socialmediaapp/screens/explore/single_post/components/edit_post_dialog.dart';
import 'package:socialmediaapp/screens/post/post_reducer.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';


void showSinglePostMoreOptionsDialog(BuildContext context) {
  var state = StoreProvider.of<GlobalState>(context).state.appState.singlePostScreenState;

  AppLog.log().i('Showing more options for this post.');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SizedBox(
          width: 300,
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('More options'),
                const Divider(),
                buildIconButton(
                  icon: Icons.edit,
                  text: 'Edit post',
                  onPressed: () {
                    AppLog.log().i('Tapped on edit post.');
                    showEditPostDialog(context);
                  },
                ),
                buildIconButton(
                  icon: Icons.delete,
                  text: 'Delete post',
                  onPressed: () => showConfirmationDialog(
                    context: context,
                    confirmationText: 'Are you sure you want to delete this post?',
                    rightButtonName: 'Delete',
                    rightButtonAction: () {
                      AppLog.log().i('Confirmed delete post.');
                      store.dispatch(DeletePostAction(state.post!.id));
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      store.dispatch(SinglePostBackAction());
                    },
                    leftButtonName: 'Cancel',
                    leftButtonAction: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
