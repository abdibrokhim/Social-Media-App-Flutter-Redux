import 'dart:async';
import 'package:socialmediaapp/screens/auth/auth_service.dart';
import 'package:socialmediaapp/screens/auth/firebase_auth_service.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socialmediaapp/utils/error_reducer.dart';


// ========== Login Epics ========== //

Stream<dynamic> loginEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is LoginAction) 
      .asyncMap((action) => AuthService.login(action.username, action.password))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            LoginSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while logging in'),
          ]));
}


// ========== SignUp Epics ========== //

Stream<dynamic> signUpEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SignUpAction) 
      .asyncMap((action) => AuthService.register(action.email, action.password, action.username))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            SignUpResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while signing up'),
          ]));
}


// ========== LogOut Epics ========== //


Stream<dynamic> logOutEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is LogOutAction) 
      .asyncMap((action) => AuthService.logout())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            LogOutSuccessAction(),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while logging out'),
          ]));
}


Stream<dynamic> googleAuthEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SignInWithGoogle) 
      .asyncMap((action) => FirebaseAuthService.signInWithGoogle())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            SignInWithGoogleSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while signing in with google'),
          ]));
}



List<Stream<dynamic> Function(Stream<dynamic>, EpicStore<GlobalState>)> authEffects = [
  loginEpic,
  signUpEpic,
  logOutEpic,
  googleAuthEpic
];
