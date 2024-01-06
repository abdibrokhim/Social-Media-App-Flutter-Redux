import 'package:redux/redux.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';

class PostState {
  final bool isLoading;
  final List<Post> allPosts;
  final Post? post;

  PostState({
    this.isLoading = false,
    this.allPosts = const [],
    this.post,
  });

  PostState copyWith({
    bool? isLoading,
    List<Post>? allPosts,
    Post? post,
  }) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      allPosts: allPosts ?? this.allPosts,
      post: post ?? this.post,
    );
  }
}


// ========== Get Post List Reducers ========== //

class GetPostListAction {}

PostState getPostListActionReducer(PostState state, GetPostListAction action) {
  return state.copyWith(isLoading: true);
}

class GetPostListResponseAction {
  final List<Post> post;

  GetPostListResponseAction(this.post);
}

PostState getAllUsersResponseReducer(PostState state, GetPostListResponseAction action) {
  return state.copyWith(
    allPosts: action.post,
    isLoading: false,
  );
}


// ========== Handle Succes Post Create/Update reducer ========== //

class HandleSuccessPostAction {
  final Post post;

  HandleSuccessPostAction(this.post);
}

PostState handleSuccessPostReducer(PostState state, HandleSuccessPostAction action) {
  return state.copyWith(
    post: action.post,
    isLoading: false,
  );
}




// ========== Handle Generic Error ========== //

class HandleGenericErrorAction {}

PostState handleGenericErrorReducer(
    PostState state, HandleGenericErrorAction action) {
  return state.copyWith(isLoading: false);
}




// ========== Delete Post Reducers ========== //

class DeletePostAction {
  final int postId;

  DeletePostAction(this.postId);
}

PostState deletePostActionReducer(PostState state, DeletePostAction action) {
  return state.copyWith(isLoading: true);
}

// class DeletePostResponseAction {
//   final int postId;

//   DeletePostResponseAction(this.postId);
// }

// PostState deleteUserResponseReducer(PostState state, DeletePostResponseAction action) {
//   return state.copyWith(
//     post: _deletePost(state.post, action.postId),
//     isLoading: false,
//   );
// }

// Post? _deletePost(Post? currentPost, int postId) {
//   if (currentPost == null) return null;

//   return currentPost.copyWith(
//     isDeleted: true,
//   );
// }




// ========== Combine all reducers ========== //

Reducer<PostState> postReducer = combineReducers<PostState>([
  TypedReducer<PostState, GetPostListAction>(getPostListActionReducer),
  TypedReducer<PostState, GetPostListResponseAction>(getAllUsersResponseReducer),
  TypedReducer<PostState, DeletePostAction>(deletePostActionReducer),
]);