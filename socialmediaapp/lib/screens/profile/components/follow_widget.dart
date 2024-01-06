import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:socialmediaapp/components/shared/toast.dart';
import 'package:socialmediaapp/screens/mainlayout/components/notification_reducer.dart';
import 'package:socialmediaapp/screens/post/components/likes_model.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';


Widget builFollowWidget({
  required BuildContext context, 
  required Store<GlobalState> gState,
  required int userId,
}) {
  return StoreConnector<GlobalState, List<PostLikedUser>?>(
    converter: (store) => store.state.appState.profileScreenState.followersList,
    builder: (context, followersList) {
                                  bool isFollowed = false;
                                  var userState = gState.state.appState.userState;

      if (gState.state.appState.profileScreenState.followersList != null) {
        isFollowed = gState.state.appState.profileScreenState.followersList!.where((element) => element.userId == userState.userId).isNotEmpty;
      }

    return
  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                                  ElevatedButton(
                    onPressed: () {
                      if (!gState.state.appState.userState.isLoggedIn) {
                        AppLog.log().i('User is not logged in.');
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          showToast(message: "You are not logged in!", bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
                        });
                        return;
                      }
                      if (userState.userId != null && store.state.appState.profileScreenState.followersList!.where((element) => element.userId == userState.userId).isNotEmpty) {
                        AppLog.log().i('UnFollowing user.');
                        store.dispatch(UnfollowUserRequestAction(userId));
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          showToast(message: "You have unfollowed the user!", bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
                        });
                        return;
                      } else {
                        AppLog.log().i('Following user.');
                        store.dispatch(FollowUserRequestAction(userId));
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          showToast(message: "You have followed the user!", bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
                        });
                        return;
                      }
                    },
                    child: Text(
                     !isFollowed ? 'Follow' : 'Unfollow',
                    ),
                  ),
                ],);
    }

  );
}
