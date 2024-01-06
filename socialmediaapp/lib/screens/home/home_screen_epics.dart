import 'dart:async';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socialmediaapp/screens/home/home_screen_reducer.dart';
import 'package:socialmediaapp/screens/home/home_screen_service.dart';

Stream<dynamic> getMadeForYouPostListEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetMadeForYouPostListRequestAction)
      .asyncMap((action) => HomeScreenService.getMadeForYouPostList(action.limit, action.offset))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetMadeForYouPostListSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

Stream<dynamic> getViralPostListEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetViralPostListRequestAction)
      .asyncMap((action) => HomeScreenService.getViralList(action.limit, action.offset))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetViralPostListSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

List<Stream<dynamic> Function(Stream<dynamic>, EpicStore<GlobalState>)> homeScreenEffects = [
  getMadeForYouPostListEpic,
  getViralPostListEpic
];