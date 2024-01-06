import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/screens/post/components/likes_model.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/screens/user/components/user_bubble_card.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';


void showSearchableFollowersDialog(BuildContext context) {
  var state = StoreProvider.of<GlobalState>(context).state.appState.profileScreenState;
  TextEditingController searchController = TextEditingController();
  List<PostLikedUser> filteredUsers = state.followersList ?? [];

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
                    filteredUsers = (state.followersList ?? []).where((user) {
                      return user.username.toLowerCase().contains(value.toLowerCase());
                    }).toList();
                    // Update the UI
                    (context as Element).markNeedsBuild();
                  },
                ),
              ),
              state.isFollowersListLoading
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
                            store.dispatch(HideUserProfileRequestAction());
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


void showSearchableFollowingsDialog(BuildContext context) {
  var state = StoreProvider.of<GlobalState>(context).state.appState.profileScreenState;
  TextEditingController searchController = TextEditingController();
  List<PostLikedUser> filteredUsers = state.followingsList ?? [];

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
                    filteredUsers = (state.followingsList ?? []).where((user) {
                      return user.username.toLowerCase().contains(value.toLowerCase());
                    }).toList();
                    // Update the UI
                    (context as Element).markNeedsBuild();
                  },
                ),
              ),
              state.isFollowingsListLoading
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
                            store.dispatch(HideUserProfileRequestAction());
                            Navigator.of(context).pop();
                            store.dispatch(ShowUserProfileRequestAction(user.userId));
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