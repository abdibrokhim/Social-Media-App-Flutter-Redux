import 'package:redux/redux.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';


class UpdatePostState {
  final bool isLoading;
  final UpdatePost? post;

  UpdatePostState({
    this.isLoading = false,
    this.post,
  });

  UpdatePostState copyWith({
    bool? isLoading,
    UpdatePost? post,
  }) {
    return UpdatePostState(
      isLoading: isLoading ?? this.isLoading,
      post: post ?? this.post,
    );
  }
}


// ========== Post Update Reducers ========== //

class UpdatePostAction {
  final int postId;
  final UpdatePost updatedPost;

  UpdatePostAction(this.postId, this.updatedPost);
}

UpdatePostState updatePostActionReducer(UpdatePostState state, UpdatePostAction action) {
  return state.copyWith(isLoading: true);
}


// class UpdatePostResponseAction {
//   final UpdatePost post;

//   UpdatePostResponseAction(this.post);
// }

// UpdatePostState updateUserResponseReducer(UpdatePostState state, UpdatePostResponseAction action) {
//   return state.copyWith(
//     post: _updatePostDetails(state.post, action.post),
//     isLoading: false,
//   );
// }

// UpdatePost? _updatePostDetails(UpdatePost? currentPost, UpdatePost updatedPost) {
//   if (currentPost == null) return null;

//   return currentPost.copyWith(
//     description: updatedPost.description,
//     image: updatedPost.image,
//     title: updatedPost.title,
//   );
// }


// ========== Combine all reducers ========== //

Reducer<UpdatePostState> updatePostReducer = combineReducers<UpdatePostState>([
  TypedReducer<UpdatePostState, UpdatePostAction>(updatePostActionReducer),
  // TypedReducer<UpdatePostState, UpdatePostResponseAction>(updateUserResponseReducer),
]);