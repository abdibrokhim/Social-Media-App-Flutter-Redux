import 'package:redux/redux.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';
import 'package:socialmediaapp/screens/post/components/likes_model.dart';


class SinglePostScreenState {
  final bool isLoading;
  final bool isPostLikedUsersLoading;
  final bool isPostLikesLoading;
  final bool isPostOwnerLoading;
  final bool isPostLikedLoading;
  final bool isPostLiked;
  final List<PostLikedUser>? postLikedUsers;
  final int likes;
  final Post? post;
  final PostLikedUser? postOwner;  // reusing PostLikedUser model for post owner, since it has the same fields.

  SinglePostScreenState({
    this.isLoading = false,
    this.isPostLikedUsersLoading = false,
    this.isPostLikesLoading = false,
    this.isPostOwnerLoading = false,
    this.isPostLikedLoading = false,
    this.isPostLiked = false,
    this.postLikedUsers,
    this.likes = 0,
    this.post,
    this.postOwner,
  });

  SinglePostScreenState copyWith({
    bool? isLoading,
    bool? isPostLikedUsersLoading,
    bool? isPostLikesLoading,
    bool? isPostOwnerLoading,
    bool? isPostLikedLoading,
    bool? isPostLiked,
    List<PostLikedUser>? postLikedUsers,
    int? likes,
    Post? post,
    PostLikedUser? postOwner,
  }) {
    return SinglePostScreenState(
      isLoading: isLoading ?? this.isLoading,
      isPostLikedUsersLoading: isPostLikedUsersLoading ?? this.isPostLikedUsersLoading,
      isPostLikesLoading: isPostLikesLoading ?? this.isPostLikesLoading,
      isPostOwnerLoading: isPostOwnerLoading ?? this.isPostOwnerLoading,
      isPostLikedLoading: isPostLikedLoading ?? this.isPostLikedLoading,
      isPostLiked: isPostLiked ?? this.isPostLiked,
      postLikedUsers: postLikedUsers ?? this.postLikedUsers,
      likes: likes ?? this.likes,
      post: post ?? this.post,
      postOwner: postOwner ?? this.postOwner,
    );
  }
} 


// ========== Handle Generic Error ========== //

class HandleGenericErrorAction {}

SinglePostScreenState handleGenericErrorReducer(
    SinglePostScreenState state, HandleGenericErrorAction action) {
  return state.copyWith(isLoading: false);
}


// ========== GET Single Post Reducer ========== //

class GetSinglePostRequestAction {
  int postId;

  GetSinglePostRequestAction(
    this.postId,
  );
}

SinglePostScreenState getSinglePostRequestReducer(
  SinglePostScreenState state,
  GetSinglePostRequestAction action,
) {
  return state.copyWith(
    isLoading: true,
  );
}

class GetSinglePostSuccessAction {
  Post post;

  GetSinglePostSuccessAction(
    this.post,
  );
}


SinglePostScreenState getSinglePostSuccessReducer(
  SinglePostScreenState state,
  GetSinglePostSuccessAction action,
) {
  return state.copyWith(
    isLoading: false,
    post: action.post,
  );
}


// ========== GET post liked user list reducers ========== //

class GetPostLikedUserListRequestAction {
  int postId;

  GetPostLikedUserListRequestAction(
    this.postId,
  );
}

SinglePostScreenState getPostLikedUserListRequestReducer(
  SinglePostScreenState state,
  GetPostLikedUserListRequestAction action,
) {
  return state.copyWith(
    isPostLikedUsersLoading: true,
  );
}

class GetPostLikedUserListSuccessAction {
  List<PostLikedUser> postLikedUsers;

  GetPostLikedUserListSuccessAction(
    this.postLikedUsers,
  );
}

SinglePostScreenState getPostLikedUserListSuccessReducer(
  SinglePostScreenState state,
  GetPostLikedUserListSuccessAction action,
) {
  return state.copyWith(
    isPostLikedUsersLoading: false,
    postLikedUsers: action.postLikedUsers,
  );
}


// ========== GET post likes count reducers ========== //

class GetPostLikesRequestAction {
  int postId;

  GetPostLikesRequestAction(
    this.postId,
  );
}

SinglePostScreenState getPostLikesRequestReducer(
  SinglePostScreenState state,
  GetPostLikesRequestAction action,
) {
  return state.copyWith(
    isPostLikesLoading: true,
  );
}

class GetPostLikesSuccessAction {
  int likes;

  GetPostLikesSuccessAction(
    this.likes,
  );
}

SinglePostScreenState getPostLikesSuccessReducer(
  SinglePostScreenState state,
  GetPostLikesSuccessAction action,
) {
  return state.copyWith(
    isPostLikesLoading: false,
    likes: action.likes,
  );
}


// ========== Check post liked or not reducers ========== //

class GetIsPostLikedRequestAction {
  int postId;

  GetIsPostLikedRequestAction(
    this.postId,
  );
}


SinglePostScreenState getIsPostLikedRequestReducer(
  SinglePostScreenState state,
  GetIsPostLikedRequestAction action,
) {
  return state.copyWith(
    isPostLikedLoading: true,
  );
}

class GetIsPostLikedSuccessAction {
  bool isPostLiked;

  GetIsPostLikedSuccessAction(
    this.isPostLiked,
  );
}

SinglePostScreenState getIsPostLikedSuccessReducer(
  SinglePostScreenState state,
  GetIsPostLikedSuccessAction action,
) {
  return state.copyWith(
    isPostLikedLoading: false,
    isPostLiked: action.isPostLiked,
  );
}


// ========== like post reducers ========== //

class LikePostRequestAction {
  int postId;

  LikePostRequestAction(
    this.postId,
  );
}

SinglePostScreenState likePostRequestReducer(
  SinglePostScreenState state,
  LikePostRequestAction action,
) {
  return state.copyWith(
    isPostLikedLoading: true,
  );
}

class LikePostSuccessAction {
  Map<String, dynamic> likes_and_users;

  LikePostSuccessAction(
    this.likes_and_users,
  );
}

SinglePostScreenState likePostSuccessReducer(
  SinglePostScreenState state,
  LikePostSuccessAction action,
) {
  return state.copyWith(
    isPostLikedLoading: false,
    isPostLiked: true,
    likes: action.likes_and_users['likes'],
    postLikedUsers: action.likes_and_users['likedUsers'],
  );
}


// ========== unlike post reducers ========== //


class UnlikePostRequestAction {
  int postId;

  UnlikePostRequestAction(
    this.postId,
  );
}

SinglePostScreenState unlikePostRequestReducer(
  SinglePostScreenState state,
  UnlikePostRequestAction action,
) {
  return state.copyWith(
    isPostLikedLoading: true,
  );
}

class UnlikePostSuccessAction {
  Map<String, dynamic> likes_and_users;

  UnlikePostSuccessAction(
    this.likes_and_users,
  );
}

SinglePostScreenState unlikePostSuccessReducer(
  SinglePostScreenState state,
  UnlikePostSuccessAction action,
) {
  return state.copyWith(
    isPostLikedLoading: false,
    isPostLiked: false,
    likes: action.likes_and_users['likes'],
    postLikedUsers: action.likes_and_users['likedUsers'],
  );
}

// ========== GET post owner reducers ========== //

class GetPostOwnerRequestAction {
  int postId;

  GetPostOwnerRequestAction(
    this.postId,
  );
}

SinglePostScreenState getPostOwnerRequestReducer(
  SinglePostScreenState state,
  GetPostOwnerRequestAction action,
) {
  return state.copyWith(
    isPostOwnerLoading: true,
  );
}

class GetPostOwnerSuccessAction {
  PostLikedUser postOwner;

  GetPostOwnerSuccessAction(
    this.postOwner,
  );
}

SinglePostScreenState getPostOwnerSuccessReducer(
  SinglePostScreenState state,
  GetPostOwnerSuccessAction action,
) {
  return state.copyWith(
    isPostOwnerLoading: false,
    postOwner: action.postOwner,
  );
}

// ========== Combine all reducers ========== //

Reducer<SinglePostScreenState> singlePostScreenReducer = combineReducers<SinglePostScreenState>([
  TypedReducer<SinglePostScreenState, HandleGenericErrorAction>(handleGenericErrorReducer),
  TypedReducer<SinglePostScreenState, GetSinglePostRequestAction>(getSinglePostRequestReducer),
  TypedReducer<SinglePostScreenState, GetSinglePostSuccessAction>(getSinglePostSuccessReducer),
  TypedReducer<SinglePostScreenState, GetPostLikedUserListRequestAction>(getPostLikedUserListRequestReducer),
  TypedReducer<SinglePostScreenState, GetPostLikedUserListSuccessAction>(getPostLikedUserListSuccessReducer),
  TypedReducer<SinglePostScreenState, GetPostLikesRequestAction>(getPostLikesRequestReducer),
  TypedReducer<SinglePostScreenState, GetPostLikesSuccessAction>(getPostLikesSuccessReducer),
  TypedReducer<SinglePostScreenState, GetIsPostLikedRequestAction>(getIsPostLikedRequestReducer),
  TypedReducer<SinglePostScreenState, GetIsPostLikedSuccessAction>(getIsPostLikedSuccessReducer),
  TypedReducer<SinglePostScreenState, LikePostRequestAction>(likePostRequestReducer),
  TypedReducer<SinglePostScreenState, LikePostSuccessAction>(likePostSuccessReducer),
  TypedReducer<SinglePostScreenState, UnlikePostRequestAction>(unlikePostRequestReducer),
  TypedReducer<SinglePostScreenState, UnlikePostSuccessAction>(unlikePostSuccessReducer),
  TypedReducer<SinglePostScreenState, GetPostOwnerRequestAction>(getPostOwnerRequestReducer),
  TypedReducer<SinglePostScreenState, GetPostOwnerSuccessAction>(getPostOwnerSuccessReducer),
]);