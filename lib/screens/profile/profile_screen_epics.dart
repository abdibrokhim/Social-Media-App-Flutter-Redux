import 'dart:async';
import 'package:socialmediaapp/screens/profile/profile_screen_service.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:socialmediaapp/screens/user/user_service.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:rxdart/rxdart.dart';


Stream<dynamic> getUserEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetUserAction)
      .asyncMap((action) => UserService.getUserByIdSmall(action.userId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetUserResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while getting user'),
          ]));
}

Stream<dynamic> getUpdatedUserEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetUpdatedUserAction)
      .asyncMap((action) => UserService.getUpdatedUserByIdSmall())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetUpdatedUserResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while getting user'),
          ]));
}

Stream<dynamic> getUserMetaInfoEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetUserMetaInfoAction)
      .asyncMap((action) => UserService.getUserMetaInfo(action.userId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetUserMetaInfoResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while getting user meta info'),
          ]));
}

Stream<dynamic> getUserSocialMediaLinksEpics(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetUserSocialMediaLinksAction)
      .asyncMap((action) => UserService.getUserSocialMediaLinks(action.userId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetUserSocialMediaLinksResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while getting user social media links'),
          ]));
}

Stream<dynamic> getUserInterestsEpics(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetUserInterestsAction)
      .asyncMap((action) => UserService.getUserInterests(action.userId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetUserInterestsResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while getting user interests'),
          ]));
}

Stream<dynamic> getUserPostsEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetUserPostsAction)
      .asyncMap((action) => UserService.getUserPosts(action.userId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetUserPostsResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while getting user posts'),
          ]));
}

Stream<dynamic> getUserSubscriptionEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetUserSubscriptionAction)
      .asyncMap((action) => UserService.getUserSubscription())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetUserSubscriptionResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while getting user subscription'),
          ]));
}

Stream<dynamic> getFollowersListEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetFollowersListRequestAction)
      .asyncMap((action) => ProfileScreenService.getFollowersList(action.userId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetFollowersListRequestSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while getting followers list'),
          ]));
}

Stream<dynamic> getFollowingListEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetFollowingsListRequestAction)
      .asyncMap((action) => ProfileScreenService.getFollowingsList(action.userId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetFollowingsListSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while getting following list'),
          ]));
}

Stream<dynamic> followUserEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is FollowUserRequestAction)
      .asyncMap((action) => ProfileScreenService.followUser(action.userId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            FollowUserSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while following user'),
          ]));
}

Stream<dynamic> unfollowUserEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is UnfollowUserRequestAction)
      .asyncMap((action) => ProfileScreenService.unfollowUser(action.userId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            UnfollowUserSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while unfollowing user'),
          ]));
}


List<Stream<dynamic> Function(Stream<dynamic>, EpicStore<GlobalState>)> profileScreenEffects = [
  getUserEpic,
  getUpdatedUserEpic,
  getUserMetaInfoEpic,
  getUserSocialMediaLinksEpics,
  getUserInterestsEpics,
  getUserPostsEpic,
  getUserSubscriptionEpic,
  getFollowersListEpic,
  getFollowingListEpic,
  followUserEpic,
  unfollowUserEpic,
];