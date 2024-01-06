import 'dart:async';
import 'package:socialmediaapp/screens/auth/auth_service.dart';
import 'package:socialmediaapp/screens/payment/stripe/stripe_service.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:socialmediaapp/screens/user/user_service.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socialmediaapp/utils/error_reducer.dart';


Stream<dynamic> getUserAccessToken(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetUserAccessTokenAction)
      .asyncMap((action) => UserService.getUserAccessToken())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetUserAccessTokenSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleErrorGetUserByIdAction(),
          ]));
}


Stream<dynamic> getUserEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetUserByIdAction)
      .asyncMap((action) => UserService.getUserByIdSmall(action.userId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetUserByIdResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleErrorGetUserByIdAction(),
          ]));
}

Stream<dynamic> getUserByUsernameEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetUserByUsernameAction)
      .asyncMap((action) => UserService.getUserByUsername(action.username))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetUserByIdResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleErrorGetUserByIdAction(),
          ]));
}

Stream<dynamic> updateUserEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is UpdateUserAction)
      .asyncMap((action) => UserService.updateUser(action.updatedUser))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            UpdateUserResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while updating user'),
          ]));
}

Stream<dynamic> deleteUserEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is DeleteUserAction)
      .asyncMap((action) => UserService.deleteUser())
      .flatMap<dynamic>((value) => Stream.fromIterable([]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
          HandleGenericErrorAction('Error while deleting user'),
        ]));
}


Stream<dynamic> updateUserSocialMediaLinksEpics(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is UpdateUserSocialMediaLinksAction)
      .asyncMap((action) => UserService.updateUserSocialMediaLink(action.smlId, action.updatedLink))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            UpdateUserSocialMediaLinksResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while updating user social media link'),
          ]));
}

Stream<dynamic> addUserSocialMediaLinksEpics(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is AddUserSocialMediaLinksAction)
      .asyncMap((action) => UserService.addUserSocialMediaLink(action.updatedLink))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            UpdateUserSocialMediaLinksResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while adding user social media link'),
          ]));
}

Stream<dynamic> deleteUserSocialMediaLinksEpics(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is DeleteUserSocialMediaLinksAction)
      .asyncMap((action) => UserService.deleteUserSocialMediaLink(action.smlId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            UpdateUserSocialMediaLinksResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while deleting user social media link'),
          ]));
}

Stream<dynamic> addUserInterestsEpics(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is AddUserInterestsAction)
      .asyncMap((action) => UserService.addUserInterests(action.interestsList))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            UpdateUserInterestsResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while adding user interests'),
          ]));
}

Stream<dynamic> deleteUserInterestsEpics(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is DeleteUserInterestsAction)
      .asyncMap((action) => UserService.deleteUserInterests(action.cId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            UpdateUserInterestsResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while deleting user interests'),
          ]));
}


Stream<dynamic> updateUserSubscriptionEpics(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is UpdateUserSubscriptionAction)
      .asyncMap((action) => UserService.updateSubscription())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            UpdateUserSubscriptionResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while updating user subscription'),
          ]));
}


Stream<dynamic> deleteUserSubscriptionEpics(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is DeleteUserSubscriptionAction)
      .asyncMap((action) => UserService.unsubscribeUser())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            DeleteUserSubscriptionResponseAction(),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while deleting user subscription'),
          ]));
}

Stream<dynamic> subscribeEpics(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SubscribeAction)
      .asyncMap((action) => StripeService.subscription(action.email))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            SubscribeResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while subscribing user'),
          ]));
}

Stream<dynamic> subscribeWebEpics(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SubscribeWebAction)
      .asyncMap((action) => StripeService.subscriptionWeb())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            SubscribeWebResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while subscribing user'),
          ]));
}

Stream<dynamic> usernameExistsEpics(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is CheckUsernameExistsAction)
      .asyncMap((action) => AuthService.usernameExists(action.username))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            CheckUsernameExistsResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while subscribing user'),
          ]));
}



List<Stream<dynamic> Function(Stream<dynamic>, EpicStore<GlobalState>)> userEffects = [
  getUserAccessToken,
  getUserEpic,
  getUserByUsernameEpic,
  updateUserEpic,
  deleteUserEpic,
  updateUserSocialMediaLinksEpics,
  addUserSocialMediaLinksEpics,
  deleteUserSocialMediaLinksEpics,
  addUserInterestsEpics,
  deleteUserInterestsEpics,
  updateUserSubscriptionEpics,
  deleteUserSubscriptionEpics,
  subscribeEpics,
  usernameExistsEpics,
  subscribeWebEpics,
];

