import 'dart:async';
import 'package:socialmediaapp/screens/explore/explore_screen_service.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socialmediaapp/screens/explore/explore_screen_reducer.dart';


Stream<dynamic> getExplorePostListEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetExplorePostListRequestAction)
      .asyncMap((action) => ExploreScreenService.getExplorePostList(action.trending_limit, action.new_limit, action.diverse_limit))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetExplorePostListSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

Stream<dynamic> getTrendingPostListEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetTrendingPostListRequestAction)
      .asyncMap((action) => ExploreScreenService.getTrendingPostList(action.limit))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetTrendingPostListSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

Stream<dynamic> getNewPostListEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetNewPostListRequestAction)
      .asyncMap((action) => ExploreScreenService.getNewPostList(action.limit))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetNewPostListSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

Stream<dynamic> getDiversePostListEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetDiversePostListRequestAction)
      .asyncMap((action) => ExploreScreenService.getDiversePostList(action.limit))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetDiversePostListSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}


List<Stream<dynamic> Function(Stream<dynamic>, EpicStore<GlobalState>)> exploreScreenEffects = [
  getExplorePostListEpic,
  getTrendingPostListEpic,
  getNewPostListEpic,
  getDiversePostListEpic,
];