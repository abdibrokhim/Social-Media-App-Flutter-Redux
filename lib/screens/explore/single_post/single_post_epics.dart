import 'dart:async';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socialmediaapp/screens/explore/single_post/single_post_service.dart';
import 'package:socialmediaapp/screens/explore/single_post/single_post_reducer.dart';


Stream<dynamic> getPostByIdEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetSinglePostRequestAction) 
      .asyncMap((action) => SinglePostService.getPostById(action.postId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetSinglePostSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

Stream<dynamic> getPostLikedUserListEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetPostLikedUserListRequestAction)
      .asyncMap((action) => SinglePostService.getPostLikedUserList(action.postId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetPostLikedUserListSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

Stream<dynamic> getPostLikesEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetPostLikesRequestAction)
      .asyncMap((action) => SinglePostService.getPostLikes(action.postId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetPostLikesSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

Stream<dynamic> getPostOwnerEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetPostOwnerRequestAction)
      .asyncMap((action) => SinglePostService.getPostOwner(action.postId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetPostOwnerSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

Stream<dynamic> isPostLikedEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GetIsPostLikedRequestAction)
      .asyncMap((action) => SinglePostService.isPostLiked(action.postId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GetIsPostLikedSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

Stream<dynamic> likePostEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is LikePostRequestAction)
      .asyncMap((action) => SinglePostService.likePost(action.postId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            LikePostSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

Stream<dynamic> unlikePostEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is UnlikePostRequestAction)
      .asyncMap((action) => SinglePostService.unlikePost(action.postId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            UnlikePostSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}


List<Stream<dynamic> Function(Stream<dynamic>, EpicStore<GlobalState>)> singlePostEffects = [
  getPostByIdEpic,
  getPostLikedUserListEpic,
  getPostLikesEpic,
  getPostOwnerEpic,
  isPostLikedEpic,
  likePostEpic,
  unlikePostEpic,
];

