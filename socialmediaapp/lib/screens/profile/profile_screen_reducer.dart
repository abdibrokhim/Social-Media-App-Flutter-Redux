import 'package:redux/redux.dart';
import 'package:socialmediaapp/screens/post/components/likes_model.dart';
import 'package:socialmediaapp/screens/user/user_model.dart';
import 'package:socialmediaapp/components/category/category_model.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';

class ProfileScreenState {
  final bool isLoading;
  final bool isInterestsLoading;
  final bool isMetaInfoLoading;
  final bool isSocialMediaLinksLoading;
  final bool isPostsLoading;
  final bool isFollowersListLoading;
  final bool isFollowingsListLoading;
  final bool isFollowLoading;
  final List<String?> errors;
  final User? user;
  final int? selectedUserId;
  final bool showUserProfileScreen;
  final List<PostLikedUser>? followersList;
  final List<PostLikedUser>? followingsList;
  final int? followersCount;
  

  ProfileScreenState({
    this.isLoading = false,
    this.isInterestsLoading = false,
    this.isMetaInfoLoading = false,
    this.isSocialMediaLinksLoading = false,
    this.isPostsLoading = false,
    this.isFollowersListLoading = false,
    this.isFollowingsListLoading = false,
    this.isFollowLoading = false,
    this.errors = const [],
    this.user,
    this.selectedUserId,
    this.showUserProfileScreen = false,
    this.followersList,
    this.followingsList,
    this.followersCount,
  });

  ProfileScreenState copyWith({
    bool? isLoading,
    bool? isInterestsLoading,
    bool? isMetaInfoLoading,
    bool? isSocialMediaLinksLoading,
    bool? isPostsLoading,
    bool? isFollowersListLoading,
    bool? isFollowingsListLoading,
    bool? isFollowLoading,
    String? errorMessage,
    User? user,
    List<String?>? errors,
    int? selectedUserId,
    bool? showUserProfileScreen,
    List<PostLikedUser>? followersList,
    List<PostLikedUser>? followingsList,
    int? followersCount,

  }) {
    return ProfileScreenState(
      isLoading: isLoading ?? this.isLoading,
      isInterestsLoading: isInterestsLoading ?? this.isInterestsLoading,
      isMetaInfoLoading: isMetaInfoLoading ?? this.isMetaInfoLoading,
      isSocialMediaLinksLoading: isSocialMediaLinksLoading ?? this.isSocialMediaLinksLoading,
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
      isFollowersListLoading: isFollowersListLoading ?? this.isFollowersListLoading,
      isFollowingsListLoading: isFollowingsListLoading ?? this.isFollowingsListLoading,
      isFollowLoading: isFollowLoading ?? this.isFollowLoading,
      errors: errors ?? this.errors,
      user: user ?? this.user,
      selectedUserId: selectedUserId ?? this.selectedUserId,
      showUserProfileScreen: showUserProfileScreen ?? this.showUserProfileScreen,
      followersList: followersList ?? this.followersList,
      followingsList: followingsList ?? this.followingsList,
      followersCount: followersCount ?? this.followersCount,

    );
  }
}

// ==========  GetFollowersListRequestAction reducers ========== //

class GetFollowersListRequestAction {
  int userId;

  GetFollowersListRequestAction(
    this.userId,
  );
}

ProfileScreenState getFollowersListRequestActionReducer(
  ProfileScreenState state,
  GetFollowersListRequestAction action,
) {
  return state.copyWith(
    isFollowersListLoading: true,
  );
}

class GetFollowersListRequestSuccessAction {
  List<PostLikedUser> followersList;

  GetFollowersListRequestSuccessAction(
    this.followersList,
  );
}

ProfileScreenState getFollowersListActionSuccessReducer(
  ProfileScreenState state,
  GetFollowersListRequestSuccessAction action,
) {
  return state.copyWith(
    isFollowersListLoading: false,
    followersList: action.followersList,
  );
}


// ==========  GetFollowingsListRequestAction reducers ========== //

class GetFollowingsListRequestAction {
  int userId;

  GetFollowingsListRequestAction(
    this.userId,
  );
}

ProfileScreenState getFollowingsListRequestActionReducer(
  ProfileScreenState state,
  GetFollowingsListRequestAction action,
) {
  return state.copyWith(
    isFollowingsListLoading: true,
  );
}

class GetFollowingsListSuccessAction {
  List<PostLikedUser> followingsList;

  GetFollowingsListSuccessAction(
    this.followingsList,
  );
}

ProfileScreenState getFollowingsListSuccessReducer(
  ProfileScreenState state,
  GetFollowingsListSuccessAction action,
) {
  return state.copyWith(
    isFollowingsListLoading: false,
    followingsList: action.followingsList,
  );
}


// ==========  FollowUserRequestAction reducers ========== //

class FollowUserRequestAction {
  int userId;

  FollowUserRequestAction(
    this.userId,
  );
}

ProfileScreenState followUserRequestActionReducer(
  ProfileScreenState state,
  FollowUserRequestAction action,
) {
  return state.copyWith(
    isFollowLoading: true,
  );
}

class FollowUserSuccessAction {
  Map<String, dynamic> followers_count_and_list;

  FollowUserSuccessAction(
    this.followers_count_and_list,
  );
}

ProfileScreenState followUserSuccessReducer(
  ProfileScreenState state,
  FollowUserSuccessAction action,
) {
  return state.copyWith(
    isFollowLoading: false,
    followersCount: action.followers_count_and_list['followers_count'],
    followersList: action.followers_count_and_list['followers_list'],
  );
}


// ==========  UnfollowUserRequestAction reducers ========== //

class UnfollowUserRequestAction {
  int userId;

  UnfollowUserRequestAction(
    this.userId,
  );
}

ProfileScreenState unfollowUserRequestActionReducer(
  ProfileScreenState state,
  UnfollowUserRequestAction action,
) {
  return state.copyWith(
    isFollowLoading: true,
  );
}

class UnfollowUserSuccessAction {
  Map<String, dynamic> followers_count_and_list;

  UnfollowUserSuccessAction(
    this.followers_count_and_list,
  );
}

ProfileScreenState unfollowUserSuccessReducer(
  ProfileScreenState state,
  UnfollowUserSuccessAction action,
) {
  return state.copyWith(
    isFollowLoading: false,
    followersCount: action.followers_count_and_list['followers_count'],
    followersList: action.followers_count_and_list['followers_list'],
  );
}



// ========== Show Profile User Request reducers ========== //

class ShowUserProfileRequestAction {
  final int userId;

  ShowUserProfileRequestAction(
    this.userId,
  );
}

ProfileScreenState userProfileRequestReducer(
  ProfileScreenState state,
  ShowUserProfileRequestAction action,
) {
  return state.copyWith(
    isLoading: true,
    showUserProfileScreen: true,
    selectedUserId: action.userId,
  );
}


// ========== Hide Profile User Request reducers ========== //

class HideUserProfileRequestAction {}


ProfileScreenState hideUserProfileRequestReducer(
  ProfileScreenState state,
  HideUserProfileRequestAction action,
) {
  return state.copyWith(
    showUserProfileScreen: false,
    selectedUserId: null,
  );
}


// ========== Handle Generic Error ========== //

class HandleGenericErrorAction {
  final String errorMessage;
  
  HandleGenericErrorAction(this.errorMessage);
}

ProfileScreenState handleGenericErrorReducer(
    ProfileScreenState state, HandleGenericErrorAction action) {
  return state.copyWith(
    isLoading: false,
    errors: [...state.errors, action.errorMessage],
  );
}


// ========== Clear Generic Error ========== //

class ClearGenericErrorAction {
  ClearGenericErrorAction();
}

ProfileScreenState clearGenericErrorReducer(
    ProfileScreenState state, ClearGenericErrorAction action) {
  return state.copyWith(
    errors: [],
  );
}


// ========== Get User Reducers ========== //

class GetUserAction {
  int userId;

  GetUserAction(this.userId);
}

ProfileScreenState getUserActionReducer(ProfileScreenState state, GetUserAction action) {
  return state.copyWith(isLoading: true);
}

class GetUserResponseAction {
  User user;

  GetUserResponseAction(this.user);
}

ProfileScreenState getUserResponseReducer(ProfileScreenState state, GetUserResponseAction action) {
  return state.copyWith(
    user: action.user,
    isLoading: false,
  );
}


// ========== Get Updated User Reducers ========== //

class GetUpdatedUserAction {
  GetUpdatedUserAction();
}

ProfileScreenState getUpdatedUserActionReducer(ProfileScreenState state, GetUpdatedUserAction action) {
  return state.copyWith(isLoading: true);
}

class GetUpdatedUserResponseAction {
  UpdateUser user;

  GetUpdatedUserResponseAction(this.user);
}

ProfileScreenState getUpdatedUserResponseReducer(ProfileScreenState state, GetUpdatedUserResponseAction action) {
  return state.copyWith(
    user: _updateUser(state.user, action.user),
    isLoading: false,
  );
}

User? _updateUser(User? currentUser, UpdateUser updatedUser) {
  if (currentUser == null) return null;

  return currentUser.copyWith(
    firstName: updatedUser.firstName,
    lastName: updatedUser.lastName,
    profileImage: updatedUser.profileImage,
  );
}


// ========== Get User Meta Info Reducers ========== //

class GetUserMetaInfoAction {
  final int userId;

  GetUserMetaInfoAction(this.userId);
}

ProfileScreenState getUserMetaInfoActionReducer(ProfileScreenState state, GetUserMetaInfoAction action) {
  return state.copyWith(isMetaInfoLoading: true);
}

class GetUserMetaInfoResponseAction {
  final MetaInfo userMetaInfo;

  GetUserMetaInfoResponseAction(this.userMetaInfo);
}

ProfileScreenState getUserMetaInfoResponseReducer(ProfileScreenState state, GetUserMetaInfoResponseAction action) {
  return state.copyWith(
    user: _updateUserMetaInfo(state.user, action.userMetaInfo),
    isMetaInfoLoading: false,
  );
}

User? _updateUserMetaInfo(User? currentUser, MetaInfo userMetaInfo) {
  if (currentUser == null) return null;

  return currentUser.copyWith(
    metaInfo: userMetaInfo,
  );
}


// ========== Get User Social Media Links Reducers ========== //

class GetUserSocialMediaLinksAction {
  final int userId;

  GetUserSocialMediaLinksAction(this.userId);
}

ProfileScreenState getUserSocialMediaLinksActionReducer(ProfileScreenState state, GetUserSocialMediaLinksAction action) {
  return state.copyWith(isSocialMediaLinksLoading: true);
}

class GetUserSocialMediaLinksResponseAction {
  final List<SocialMediaLink> userSocialMediaLinks;

  GetUserSocialMediaLinksResponseAction(this.userSocialMediaLinks);
}

ProfileScreenState getUserSocialMediaLinksResponseReducer(ProfileScreenState state, GetUserSocialMediaLinksResponseAction action) {
  return state.copyWith(
    user: _updateUserSocialMediaLinks(state.user, action.userSocialMediaLinks),
    isSocialMediaLinksLoading: false,
  );
}

User? _updateUserSocialMediaLinks(User? currentUser, List<SocialMediaLink> userSocialMediaLinks) {
  if (currentUser == null) return null;

  return currentUser.copyWith(
    socialMediaLinks: userSocialMediaLinks,
  );
}




// ========== GET User Interests Reducers ========== //

class GetUserInterestsAction {
  final int userId;

  GetUserInterestsAction(this.userId);
}

ProfileScreenState getUserInterestsActionReducer(ProfileScreenState state, GetUserInterestsAction action) {
  return state.copyWith(isInterestsLoading: true);
}

class GetUserInterestsResponseAction {
  final List<Category> interestsList;

  GetUserInterestsResponseAction(this.interestsList);
}

ProfileScreenState getUserInterestsResponseActionReducer(ProfileScreenState state, GetUserInterestsResponseAction action) {
  return state.copyWith(
    user: _updateUserInterests(state.user, action.interestsList),
    isInterestsLoading: false,
  );
}

User? _updateUserInterests(User? currentUser, List<Category> interestsList) {
  if (currentUser == null) return null;

  return currentUser.copyWith(
    interests: interestsList,
  );
}


// ========== GET User Posts Reducers ========== //

class GetUserPostsAction {
  final int userId;

  GetUserPostsAction(this.userId);
}

ProfileScreenState getUserPostsActionReducer(ProfileScreenState state, GetUserPostsAction action) {
  return state.copyWith(isPostsLoading: true);
}

class GetUserPostsResponseAction {
  final List<PostFilter> posts;

  GetUserPostsResponseAction(this.posts);
}

ProfileScreenState getUserPostsResponseActionReducer(ProfileScreenState state, GetUserPostsResponseAction action) {
  return state.copyWith(
    user: _updateUserPosts(state.user, action.posts),
    isPostsLoading: false,
  );
}

User? _updateUserPosts(User? currentUser, List<PostFilter> posts) {
  if (currentUser == null) return null;

  return currentUser.copyWith(
    posts: posts,
  );
}




// ========== Combine all reducers ========== //

Reducer<ProfileScreenState> profileScreenReducer = combineReducers<ProfileScreenState>([
  TypedReducer<ProfileScreenState, HideUserProfileRequestAction>(hideUserProfileRequestReducer),
  TypedReducer<ProfileScreenState, ShowUserProfileRequestAction>(userProfileRequestReducer),
  TypedReducer<ProfileScreenState, ClearGenericErrorAction>(clearGenericErrorReducer),
  TypedReducer<ProfileScreenState, GetUserAction>(getUserActionReducer),
  TypedReducer<ProfileScreenState, GetUserResponseAction>(getUserResponseReducer),
  TypedReducer<ProfileScreenState, HandleGenericErrorAction>(handleGenericErrorReducer),
  TypedReducer<ProfileScreenState, GetUserMetaInfoAction>(getUserMetaInfoActionReducer),
  TypedReducer<ProfileScreenState, GetUserMetaInfoResponseAction>(getUserMetaInfoResponseReducer),
  TypedReducer<ProfileScreenState, GetUserSocialMediaLinksAction>(getUserSocialMediaLinksActionReducer),
  TypedReducer<ProfileScreenState, GetUserSocialMediaLinksResponseAction>(getUserSocialMediaLinksResponseReducer),
  TypedReducer<ProfileScreenState, GetUserInterestsAction>(getUserInterestsActionReducer),
  TypedReducer<ProfileScreenState, GetUserInterestsResponseAction>(getUserInterestsResponseActionReducer),
  TypedReducer<ProfileScreenState, GetUserPostsAction>(getUserPostsActionReducer),
  TypedReducer<ProfileScreenState, GetUserPostsResponseAction>(getUserPostsResponseActionReducer),
  TypedReducer<ProfileScreenState, GetUpdatedUserAction>(getUpdatedUserActionReducer),
  TypedReducer<ProfileScreenState, GetUpdatedUserResponseAction>(getUpdatedUserResponseReducer),
  TypedReducer<ProfileScreenState, GetFollowersListRequestAction>(getFollowersListRequestActionReducer),
  TypedReducer<ProfileScreenState, GetFollowersListRequestSuccessAction>(getFollowersListActionSuccessReducer),
  TypedReducer<ProfileScreenState, GetFollowingsListRequestAction>(getFollowingsListRequestActionReducer),
  TypedReducer<ProfileScreenState, GetFollowingsListSuccessAction>(getFollowingsListSuccessReducer),
  TypedReducer<ProfileScreenState, FollowUserRequestAction>(followUserRequestActionReducer),
  TypedReducer<ProfileScreenState, FollowUserSuccessAction>(followUserSuccessReducer),
  TypedReducer<ProfileScreenState, UnfollowUserRequestAction>(unfollowUserRequestActionReducer),
  TypedReducer<ProfileScreenState, UnfollowUserSuccessAction>(unfollowUserSuccessReducer),
]);