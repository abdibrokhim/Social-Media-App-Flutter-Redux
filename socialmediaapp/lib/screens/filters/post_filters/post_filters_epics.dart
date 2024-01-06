import 'dart:async';
import 'package:socialmediaapp/screens/filters/post_filters/post_filters_service.dart';
import 'package:socialmediaapp/screens/filters/post_filters/post_filters_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';


Stream<dynamic> filterPostsEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is FilterPostsRequestAction)
      .asyncMap((action) => PostFiltersService.filterPosts(action.filterText))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            FilterPostsSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

Stream<dynamic> autoCompletePostsEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is AutoCompletePostRequestAction)
      .asyncMap((action) => PostFiltersService.autoCompletePosts(action.filterText))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            AutoCompletePostSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

List<Stream<dynamic> Function(Stream<dynamic>, EpicStore<GlobalState>)> filterPostsEffects = [
  filterPostsEpic,
  autoCompletePostsEpic,
];