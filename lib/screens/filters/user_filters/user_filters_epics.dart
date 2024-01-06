import 'dart:async';
import 'package:socialmediaapp/screens/filters/user_filters/user_filters_service.dart';
import 'package:socialmediaapp/screens/filters/user_filters/user_filters_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';


Stream<dynamic> filterUsersEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is FilterUsersRequestAction)
      .asyncMap((action) => UserFiltersService.filterUsers(action.filterText))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            FilterUsersSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}


Stream<dynamic> autoCompleteUsersEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is AutoCompleteUserRequestAction)
      .asyncMap((action) => UserFiltersService.autoCompleteUsers(action.filterText))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            AutoCompleteUserSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}


List<Stream<dynamic> Function(Stream<dynamic>, EpicStore<GlobalState>)> filterUsersEffects = [
  filterUsersEpic,
  autoCompleteUsersEpic,
];