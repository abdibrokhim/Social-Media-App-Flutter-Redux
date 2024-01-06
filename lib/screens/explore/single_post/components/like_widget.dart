import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:socialmediaapp/components/shared/toast.dart';
import 'package:socialmediaapp/screens/explore/single_post/single_post_reducer.dart';
import 'package:socialmediaapp/screens/mainlayout/components/notification_reducer.dart';
import 'package:socialmediaapp/screens/post/components/likes_model.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/screens/user/components/user_bubble_card.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';


void _showLikedUsersList(BuildContext context) {
  var state = StoreProvider.of<GlobalState>(context).state.appState.singlePostScreenState;
  TextEditingController searchController = TextEditingController();
  List<PostLikedUser> filteredUsers = state.postLikedUsers ?? [];

  AppLog.log().i('Showing list of users who liked this post.');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SizedBox(
          width: 300,
          height: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search Users',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (String value) {
                    // Filter the list of users based on the search query
                    filteredUsers = (state.postLikedUsers ?? []).where((user) {
                      return user.username.toLowerCase().contains(value.toLowerCase());
                    }).toList();
                    // Update the UI
                    (context as Element).markNeedsBuild();
                  },
                ),
              ),
              state.isPostLikedUsersLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return UserBubbleCard(
                          user: user,
                          onTap: () {
                            AppLog.log().i('Tapped on user id: ${user.userId}');
                            Navigator.of(context).pop();
                            store.dispatch(ShowUserProfileRequestAction(user.userId));
                            store.dispatch(SinglePostBackAction());
                          },
                        );
                      },
                    ),
                  ),
            ],
          ),
        ),
      );
    },
  );
}




Widget buildLikeWidget({
  required BuildContext context, 
  required Store<GlobalState> gState,
  required int postId,
}) {
  return StoreConnector<GlobalState, UserState>(
    converter: (store) => store.state.appState.userState,
    builder: (context, userState) {
      bool isLiked = false;
      bool isLoggedIn = false;

      int likesCount = gState.state.appState.singlePostScreenState.likes;
      if (gState.state.appState.singlePostScreenState.postLikedUsers != null) {
        isLiked = gState.state.appState.singlePostScreenState.postLikedUsers!.where((element) => element.userId == userState.userId).isNotEmpty;
      }
      if (gState.state.appState.userState.isLoggedIn) {
        isLoggedIn = gState.state.appState.userState.isLoggedIn;
      }
    return
  Row(
    children: [
      IconButton(
        onPressed: () {
          if (!gState.state.appState.userState.isLoggedIn) {
            AppLog.log().i('User is not logged in.');
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showToast(message: 'User is not logged in.', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
            });
            return;
          }
          if (userState.userId != null && store.state.appState.singlePostScreenState.postLikedUsers!.where((element) => element.userId == userState.userId).isNotEmpty) {
            AppLog.log().i('Unliking post.');
            store.dispatch(UnlikePostRequestAction(postId));
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showToast(message: 'You have unliked the post!', bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
            });
            return;
          } else {
            AppLog.log().i('Liking post.');
            store.dispatch(LikePostRequestAction(postId));
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showToast(message: 'You have liked the post!', bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
            });
            return;
          }
        },
        icon: isLoggedIn && isLiked ?
        const Icon(
          Icons.favorite,
          color: Colors.red,
        ):
      const Icon(
        Icons.favorite_border,
        color: Colors.black,
      ),
      ),
      InkWell(
        onTap: () => _showLikedUsersList(context),
        child: Text(likesCount > 1 ? "$likesCount like" : "$likesCount likes"),
      ),
    ],
  );
    }

  );
}
