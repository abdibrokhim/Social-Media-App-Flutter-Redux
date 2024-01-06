import 'dart:async';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:socialmediaapp/screens/post/post_service.dart';
import 'package:socialmediaapp/screens/post/create_post_reducer.dart';
import 'package:socialmediaapp/screens/post/update_post_reducer.dart';
import 'package:socialmediaapp/screens/post/post_reducer.dart';
import 'package:rxdart/rxdart.dart';


Stream<dynamic> createPostEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is CreatePostRequestAction)
      .asyncMap((action) => PostService.createPost(action.post))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            CreatePostSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

Stream<dynamic> updatePostEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is UpdatePostAction)
      .asyncMap((action) => PostService.updatePost(action.postId, action.updatedPost))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            HandleSuccessPostAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

Stream<dynamic> deletePostEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is DeletePostAction)
      .asyncMap((action) => PostService.deletePost(action.postId))
      .flatMap<dynamic>((value) => Stream.fromIterable([]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
          HandleGenericErrorAction(),
        ]));
}

Stream<dynamic> gptVisionPostEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is Gpt4AutocompleteRequestAction)
      .asyncMap((action) => PostService.gptVisionPost(action.imageUrl))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            Gpt4AutocompleteResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

Stream<dynamic> geminiVisionPostEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GeminiAutocompleteRequestAction)
      .asyncMap((action) => PostService.geminiVisionPost(action.imageUrl))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GeminiAutocompleteResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}

Stream<dynamic> gptVisionSimulatePostEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is AIAutocompleteSimulateRequestAction)
      .asyncMap((action) => PostService.gptVisionSimulatePost())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            AIAutocompleteSimulateResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction(),
          ]));
}


List<Stream<dynamic> Function(Stream<dynamic>, EpicStore<GlobalState>)> postEffects = [
  createPostEpic,
  updatePostEpic,
  deletePostEpic,
  gptVisionPostEpic,
  gptVisionSimulatePostEpic,
  geminiVisionPostEpic,
];

