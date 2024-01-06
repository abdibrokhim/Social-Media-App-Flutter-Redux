import 'package:redux/redux.dart';
import 'package:socialmediaapp/screens/user/components/google_signin_model.dart';
import 'package:socialmediaapp/screens/user/user_model.dart';
import 'package:socialmediaapp/components/category/category_model.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';

class UserState {
  final bool isSubscriptionLoading;
  final bool isLoading;
  final bool isInterestsLoading;
  final bool isSocialMediaLinksLoading;
  final bool isPostsLoading;
  final bool isLoggedIn;
  final bool isSignedUp;
  final String? accessToken;
  final String? refreshToken;
  final String message;
  final List<int> favorite;
  final List<String> searchHistory;
  final List<Post> autoCompleteList;
  final List<String?> errors;
  final User? user;
  final int? userId;
  final List<User> allUsers;
  final int? selectedPostId;
  final bool showSinglePostScreen;
  final bool showSignUpScreen;
  final bool showForgotPasswordScreen;
  final bool showSignInScreen;
  final String? username;
  final bool usernameExists;
  final bool googleSignInCompleted;
  final GoogleSignInData? googleSignInData;

  UserState({
    this.isSubscriptionLoading = false,
    this.isLoading = false,
    this.isInterestsLoading = false,
    this.isSocialMediaLinksLoading = false,
    this.isPostsLoading = false,
    this.isLoggedIn = false,
    this.isSignedUp = false,
    this.accessToken = '',
    this.refreshToken = '',
    this.message = '',
    this.favorite = const [],
    this.searchHistory = const [],
    this.autoCompleteList = const [],
    this.errors = const [],
    this.user,
    this.userId,
    this.allUsers = const [],
    this.selectedPostId,
    this.showSinglePostScreen = false,
    this.showSignUpScreen = false,
    this.showForgotPasswordScreen = false,
    this.showSignInScreen = false,
    this.username,
    this.usernameExists = false,
    this.googleSignInCompleted = false,
    this.googleSignInData,

  });

  UserState copyWith({
    bool? isSubscriptionLoading,
    bool? isLoading,
    bool? isInterestsLoading,
    bool? isSocialMediaLinksLoading,
    bool? isPostsLoading,
    bool? isLoggedIn,
    bool? isSignedUp,
    String? accessToken,
    String? refreshToken,
    String? message,
    List<int>? favorite,
    List<String>? searchHistory,
    List<Post>? autoCompleteList,
    User? user,
    int? userId,
    List<User>? allUsers,
    List<String?>? errors,
    int? selectedPostId,
    bool? showSinglePostScreen,
    bool? showSignUpScreen,
    bool? showForgotPasswordScreen,
    bool? showSignInScreen,
    String? username,
    bool? usernameExists,
    bool? googleSignInCompleted,
    GoogleSignInData? googleSignInData,
  }) {
    return UserState(
      isSubscriptionLoading: isSubscriptionLoading ?? this.isSubscriptionLoading,
      isLoading: isLoading ?? this.isLoading,
      isInterestsLoading: isInterestsLoading ?? this.isInterestsLoading,
      isSocialMediaLinksLoading: isSocialMediaLinksLoading ?? this.isSocialMediaLinksLoading,
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isSignedUp: isSignedUp ?? this.isSignedUp,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      message: message ?? this.message,
      favorite: favorite ?? this.favorite,
      searchHistory: searchHistory ?? this.searchHistory,
      autoCompleteList: autoCompleteList ?? this.autoCompleteList,
      errors: errors ?? this.errors,
      user: user ?? this.user,
      userId: userId ?? this.userId,
      allUsers: allUsers ?? this.allUsers,
      selectedPostId: selectedPostId ?? this.selectedPostId,
      showSinglePostScreen: showSinglePostScreen ?? this.showSinglePostScreen,
      showSignUpScreen: showSignUpScreen ?? this.showSignUpScreen,
      showForgotPasswordScreen: showForgotPasswordScreen ?? this.showForgotPasswordScreen,
      showSignInScreen: showSignInScreen ?? this.showSignInScreen,
      username: username ?? this.username,
      usernameExists: usernameExists ?? this.usernameExists,
      googleSignInCompleted: googleSignInCompleted ?? this.googleSignInCompleted,
      googleSignInData: googleSignInData ?? this.googleSignInData,
    );
  }
}


// ========== Reset Auth Screens Request reducers ========== //

class ResetAuthScreensRequestAction {
  ResetAuthScreensRequestAction();
}

UserState resetAuthScreensRequestReducer(
  UserState state,
  ResetAuthScreensRequestAction action,
) {
  return state.copyWith(
    showSignInScreen: false,
    showSignUpScreen: false,
    showForgotPasswordScreen: false,
  );
}


// ========== Show Sign In Screen Request reducers ========== //

class ShowSignInScreenRequestAction {
  ShowSignInScreenRequestAction();
}

UserState showSignInScreenRequestReducer(
  UserState state,
  ShowSignInScreenRequestAction action,
) {
  return state.copyWith(
    showSignInScreen: true,
    showSignUpScreen: false,
    showForgotPasswordScreen: false
  );
}



// ========== Show Sign Up Screen Request reducers ========== //

class ShowSignUpScreenRequestAction {
  ShowSignUpScreenRequestAction();
}

UserState showSignUpScreenRequestReducer(
  UserState state,
  ShowSignUpScreenRequestAction action,
) {
  return state.copyWith(
    showSignUpScreen: true,
    showForgotPasswordScreen: false,
    showSignInScreen: false,
  );
}


// ========== Hide Sign Up Screen Request reducers ========== //

class HideSignUpScreenRequestAction {
  HideSignUpScreenRequestAction();
}

UserState hideSignUpScreenRequestReducer(
  UserState state,
  HideSignUpScreenRequestAction action,
) {
  return state.copyWith(
    showSignUpScreen: false,
  );
}


// ========== Show Forgot Password Screen Request reducers ========== //

class ShowForgotPasswordScreenRequestAction {
  ShowForgotPasswordScreenRequestAction();
}

UserState showForgotPasswordScreenRequestReducer(
  UserState state,
  ShowForgotPasswordScreenRequestAction action,
) {
  return state.copyWith(
    showForgotPasswordScreen: true,
    showSignUpScreen: false,
    showSignInScreen: false,
  );
}


// ========== Hide Forgot Password Screen Request reducers ========== //

class HideForgotPasswordScreenRequestAction {
  HideForgotPasswordScreenRequestAction();
}

UserState hideForgotPasswordScreenRequestReducer(
  UserState state,
  HideForgotPasswordScreenRequestAction action,
) {
  return state.copyWith(
    showForgotPasswordScreen: false,
  );
}


// ========== SinglePost Request reducers ========== //

class SinglePostRequestAction {
  final int postId;

  SinglePostRequestAction(
    this.postId,
  );
}

UserState singlePostRequestReducer(
  UserState state,
  SinglePostRequestAction action,
) {
  return state.copyWith(
    isLoading: true,
    showSinglePostScreen: true,
    selectedPostId: action.postId,
  );
}


// ========== SinglePost Back reducers ========== //

class SinglePostBackAction {}

UserState singlePostBackReducer(
  UserState state,
  SinglePostBackAction action,
) {
  return state.copyWith(
    showSinglePostScreen: false,
    selectedPostId: null,
  );
}



// ========== Add to favourites reducers ========== //

class AddToFavouritesAction {
  final int postId;

  AddToFavouritesAction(this.postId);
}

UserState saveToFavouritesReducer(UserState state, AddToFavouritesAction action) {
  return state.copyWith(
    favorite: [...state.favorite, action.postId],
  );
}


// ========== Remove from favourites reducers ========== //

class RemoveFromFavouritesAction {
  final int postId;

  RemoveFromFavouritesAction(this.postId);
}

UserState removeFromFavouritesReducer(UserState state, RemoveFromFavouritesAction action) {
  return state.copyWith(
    favorite: state.favorite.where((element) => element != action.postId).toList(),
  );
}


// ========== Save to search history reducers ========== //


class SaveToUserHistoryAction {
  final String searchQuery;

  SaveToUserHistoryAction(this.searchQuery);

}

UserState saveToUserHistoryReducer(UserState state, SaveToUserHistoryAction action) {
  return state.copyWith(
    searchHistory: [...state.searchHistory, action.searchQuery],
  );
}


// ========== Delete from search history reducers ========== //

class DeleteFromUserHistoryAction {
  final int index;

  DeleteFromUserHistoryAction(this.index);
}

UserState deleteFromUserHistoryReducer(UserState state, DeleteFromUserHistoryAction action) {
  return state.copyWith(
    searchHistory: state.searchHistory.where((element) => element != state.searchHistory[action.index]).toList(),
  );
}


// ========== Delete all from search history reducers ========== //

class DeleteAllFromUserHistoryAction {
  DeleteAllFromUserHistoryAction();
}

UserState deleteAllFromUserHistoryReducer(UserState state, DeleteAllFromUserHistoryAction action) {
  return state.copyWith(
    searchHistory: [],
  );
}



// ========== Get user access token reducers ========== //

class GetUserAccessTokenAction {
  GetUserAccessTokenAction();
}

UserState getUserAccessTokenActionReducer(UserState state, GetUserAccessTokenAction action) {
  return state.copyWith(isLoading: true);
}

class GetUserAccessTokenSuccessAction {
  Map<String, dynamic> tokens;

  GetUserAccessTokenSuccessAction(this.tokens);
}

UserState getUserAccessTokenSuccessReducer(UserState state, GetUserAccessTokenSuccessAction action) {
  if (action.tokens["accessToken"] != null && action.tokens['refreshToken'] != null && action.tokens['userId'] != null) {
    return state.copyWith(
      isLoading: false,
      isLoggedIn: true,
      accessToken: action.tokens['accessToken'],
      refreshToken: action.tokens['refreshToken'],
      userId: int.parse(action.tokens['userId']),
    );
  }
  return state.copyWith(
    isLoading: false,
    isLoggedIn: true,
  );
}

// ========== SignUp reducers ========== //

class SignUpAction {
  final String username;
  final String email;
  final String password;

  SignUpAction(
    this.username,
    this.email,
    this.password,
  );
}

UserState getPostOwnerRequestReducer(
  UserState state,
  SignUpAction action,
) {
  return state.copyWith(
    isLoading: true,
  );
}

class SignUpResponseAction {
  final bool success;

  SignUpResponseAction(this.success);
}

UserState signUpSuccessReducer(
  UserState state,
  SignUpResponseAction action,
) {
  return state.copyWith(
    isLoading: false,
    isSignedUp: action.success,
  );
}

// ========== Login reducers ========== //

class LoginAction {
  String username;
  String password;

  LoginAction(
    this.username,
    this.password,
  );
}

UserState loginReducer(UserState state, LoginAction action) {
  return state.copyWith(isLoading: true);
}

class LoginSuccessAction {
  final Map<String, dynamic> data;

  LoginSuccessAction(
    this.data,
  );
}

UserState loginSuccessReducer(UserState state, LoginSuccessAction action) {
  String accessToken = action.data['accessToken'];
  String refreshToken = action.data['refreshToken'];
  User user = action.data['user'];
  int userId = user.id;
  print('loginSuccessReducer: user logged in');
  print('access token: $accessToken');
  print('refresh token: $refreshToken');
  print('user id: $userId');
  return state.copyWith(
    isLoggedIn: true, 
    isLoading: false,
    accessToken: accessToken,
    refreshToken: refreshToken,
    user: user,
    userId: userId
  );
}


// ========== check username exists reducers ========== //
class CheckUsernameExistsAction {
  final String username;

  CheckUsernameExistsAction(
    this.username,
  );
}

UserState checkUsernameExistsRequestReducer(
  UserState state,
  CheckUsernameExistsAction action,
) {
  return state.copyWith(
    isLoading: true,
  );
}

class CheckUsernameExistsResponseAction {
  final bool exists;

  CheckUsernameExistsResponseAction(
    this.exists,
  );
}

UserState checkUsernameExistsSuccessReducer(
  UserState state,
  CheckUsernameExistsResponseAction action,
) {
  return state.copyWith(
    isLoading: false,
    usernameExists: action.exists,
  );
}


// ========== SignInWithGoogle reducers ========== //


class SignInWithGoogle {
  SignInWithGoogle();
}

UserState signInWithGoogleReducer(UserState state, SignInWithGoogle action) {
  return state.copyWith(isLoading: true);
}

class SignInWithGoogleSuccessAction {
  final GoogleSignInData data;

  SignInWithGoogleSuccessAction(
    this.data,
  );
}

UserState signInWithGoogleSuccessReducer(UserState state, SignInWithGoogleSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    googleSignInCompleted: true,
    googleSignInData: action.data,
  );
}


// ========== LogOut reducers ========== //

class LogOutAction {
  LogOutAction();
}

UserState logOutActionReducer(UserState state, LogOutAction action) {
  return state.copyWith(isLoading: true);
}

class LogOutSuccessAction {
  LogOutSuccessAction();
}

UserState logOutSuccessReducer(
    UserState state, LogOutSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    isLoggedIn: false,
    showSignInScreen: true,
  );
}



// ========== Get User By Id Reducers ========== //

class GetUserByIdAction {
  int userId;

  GetUserByIdAction(this.userId);
}

UserState getUserByIdActionReducer(UserState state, GetUserByIdAction action) {
  return state.copyWith(isLoading: true);
}

class GetUserByIdResponseAction {
  User user;

  GetUserByIdResponseAction(this.user);
}

UserState getUserByIdresponseReducer(UserState state, GetUserByIdResponseAction action) {
  return state.copyWith(
    user: action.user,
    isLoading: false,
  );
}

class HandleErrorGetUserByIdAction {
  HandleErrorGetUserByIdAction();
}

UserState handleErrorGetUserByIdReducer(
    UserState state, HandleErrorGetUserByIdAction action) {
  return state.copyWith(isLoading: false);
}


// ========== Get User By Username Reducers ========== //

class GetUserByUsernameAction {
  String username;

  GetUserByUsernameAction(this.username);
}

UserState getUserByUsernameActionReducer(UserState state, GetUserByUsernameAction action) {
  return state.copyWith(isLoading: true);
}


// ========== Get All Users Reducers ========== //

class GetAllUsersAction {}

UserState getAllUsersActionReducer(UserState state, GetAllUsersAction action) {
  return state.copyWith(isLoading: true);
}

class GetAllUsersResponseAction {
  final List<User> users;
  GetAllUsersResponseAction(this.users);
}

UserState getAllUsersResponseReducer(UserState state, GetAllUsersResponseAction action) {
  return state.copyWith(
    allUsers: action.users,
    isLoading: false,
  );
}

class HandleErrorAllUsersAction {}

UserState handleErrorAllUsersReducer(
    UserState state, HandleErrorAllUsersAction action) {
  return state.copyWith(isLoading: false);
}


// // ========== Handle Generic Error ========== //

// class HandleGenericErrorAction {
//   final String errorMessage;
  
//   HandleGenericErrorAction(this.errorMessage);
// }

// UserState handleGenericErrorReducer(
//     UserState state, HandleGenericErrorAction action) {
//   return state.copyWith(
//     isLoading: false,
//     errors: [...state.errors, action.errorMessage],
//   );
// }


// // ========== Clear Generic Error ========== //

// class ClearGenericErrorAction {
//   ClearGenericErrorAction();
// }

// UserState clearGenericErrorReducer(
//     UserState state, ClearGenericErrorAction action) {
//   return state.copyWith(
//     errors: [],
//   );
// }


// ========== User Update Reducers ========== //

class UpdateUserAction {
  final UpdateUser updatedUser;

  UpdateUserAction(this.updatedUser);
}

UserState updateUserActionReducer(UserState state, UpdateUserAction action) {
  return state.copyWith(isLoading: true);
}

class UpdateUserResponseAction {
  final UpdateUser user;

  UpdateUserResponseAction(this.user);
}

UserState updateUserResponseReducer(UserState state, UpdateUserResponseAction action) {
  return state.copyWith(
    user: _updateUserDetails(state.user, action.user),
    isLoading: false,
  );
}

User? _updateUserDetails(User? currentUser, UpdateUser updatedUser) {
  if (currentUser == null) return null;

  return currentUser.copyWith(
    firstName: updatedUser.firstName ?? currentUser.firstName,
    lastName: updatedUser.lastName ?? currentUser.lastName,
    profileImage: updatedUser.profileImage ?? currentUser.profileImage,
    updatedAt: updatedUser.updatedAt ?? currentUser.updatedAt,
  );
}


// ========== Delete User Reducers ========== //

class DeleteUserAction {
  DeleteUserAction();
}

UserState deleteUserActionReducer(UserState state, DeleteUserAction action) {
  return state.copyWith(isLoading: true);
}




// ========== Update User Social Media Links Reducers ========== //

class UpdateUserSocialMediaLinksAction {
  final int smlId;
  final SocialMediaLink updatedLink;

  UpdateUserSocialMediaLinksAction(this.smlId, this.updatedLink);
}

UserState updateUserSocialMediaLinksActionReducer(UserState state, UpdateUserSocialMediaLinksAction action) {
  return state.copyWith(isSocialMediaLinksLoading: true);
}

class UpdateUserSocialMediaLinksResponseAction {
  final List<SocialMediaLink> updatedSocialMediaLink;

  UpdateUserSocialMediaLinksResponseAction(this.updatedSocialMediaLink);
}

UserState updateUserSocialMediaLinksResponseReducer(UserState state, UpdateUserSocialMediaLinksResponseAction action) {
  return state.copyWith(
    user: _updateUserSocialMediaLink(state.user, action.updatedSocialMediaLink),
    isSocialMediaLinksLoading: false,
  );
}

User? _updateUserSocialMediaLink(User? currentUser, List<SocialMediaLink> updatedSocialMediaLink) {
  if (currentUser == null) return null;

  return currentUser.copyWith(
    socialMediaLinks: updatedSocialMediaLink,
  );
}


// ========== Add User Social Media Links Reducers ========== //

class AddUserSocialMediaLinksAction {
  final AddSocialMediaLink updatedLink;

  AddUserSocialMediaLinksAction(this.updatedLink);
}

UserState addUserSocialMediaLinksActionReducer(UserState state, AddUserSocialMediaLinksAction action) {
  return state.copyWith(isSocialMediaLinksLoading: true);
}


// ========== Delete User Social Media Links Reducers ========== //

class DeleteUserSocialMediaLinksAction {
  final int smlId;

  DeleteUserSocialMediaLinksAction(this.smlId);
}

UserState deleteUserSocialMediaLinksActionReducer(UserState state, DeleteUserSocialMediaLinksAction action) {
  return state.copyWith(isSocialMediaLinksLoading: true);
}


// ========== Add User Interests Reducers ========== //

class AddUserInterestsAction {
  final UserInterest interestsList;

  AddUserInterestsAction(this.interestsList);
}

UserState addUserInterestsActionReducer(UserState state, AddUserInterestsAction action) {
  return state.copyWith(isInterestsLoading: true);
}

class UpdateUserInterestsResponseAction {
  final List<Category> interestsList;

  UpdateUserInterestsResponseAction(this.interestsList);
}

UserState updateUserInterestsResponseActionReducer(UserState state, UpdateUserInterestsResponseAction action) {
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


// ========== Delete User Interests Reducers ========== //

class DeleteUserInterestsAction {
  final int cId;

  DeleteUserInterestsAction(this.cId);
}

UserState deleteUserInterestsActionReducer(UserState state, DeleteUserInterestsAction action) {
  return state.copyWith(isInterestsLoading: true);
}


// ========== GetUserSubscriptionAction Reducers ========== //


User? _updateUserSubscription(User? currentUser, List<UserSubscription>? userSubscription) {
  if (currentUser == null) return currentUser;
  return currentUser.copyWith(
    subscription: userSubscription,
  );
}


class GetUserSubscriptionAction {
  GetUserSubscriptionAction();
}

UserState getUserSubscriptionActionReducer(UserState state, GetUserSubscriptionAction action) {
  return state.copyWith(isLoading: true);
}

class GetUserSubscriptionResponseAction {
  final List<UserSubscription>? userSubscription;

  GetUserSubscriptionResponseAction(this.userSubscription);
}

UserState getUserSubscriptionResponseReducer(UserState state, GetUserSubscriptionResponseAction action) {
  return state.copyWith(
    user: _updateUserSubscription(state.user, action.userSubscription),
    isSubscriptionLoading: false,
  );
}

// ========== UpdateUserSubscriptionAction Reducers ========== //

class UpdateUserSubscriptionAction {
  UpdateUserSubscriptionAction();
}

UserState updateUserSubscriptionActionReducer(UserState state, UpdateUserSubscriptionAction action) {
  return state.copyWith(isSubscriptionLoading: true);
}

class UpdateUserSubscriptionResponseAction {
  final List<UserSubscription> userSubscription;

  UpdateUserSubscriptionResponseAction(this.userSubscription);
}

UserState updateUserSubscriptionResponseReducer(UserState state, UpdateUserSubscriptionResponseAction action) {
  return state.copyWith(
    user: _updateUserSubscription(state.user, action.userSubscription),
    isSubscriptionLoading: false,
  );
}


// ========== DeleteUserSubscriptionAction Reducers ========== //

class DeleteUserSubscriptionAction {
  DeleteUserSubscriptionAction();
}

UserState deleteUserSubscriptionActionReducer(UserState state, DeleteUserSubscriptionAction action) {
  return state.copyWith(isSubscriptionLoading: true);
}

class DeleteUserSubscriptionResponseAction {

  DeleteUserSubscriptionResponseAction();
}

UserState deleteUserSubscriptionResponseReducer(UserState state, DeleteUserSubscriptionResponseAction action) {
  return state.copyWith(
    user: _deleteUserSubscription(state.user),
    isSubscriptionLoading: false,
  );
}

User? _deleteUserSubscription(User? currentUser) {
  if (currentUser == null) return currentUser;

  return currentUser.copyWith(
    subscription: [],
  );
}


// ========== SubscribeAction Reducers ========== //

class SubscribeAction {
  final String email;
  SubscribeAction(this.email);
}

UserState subscribeActionReducer(UserState state, SubscribeAction action) {
  return state.copyWith(isSubscriptionLoading: true);
}

class SubscribeResponseAction {
  final List<UserSubscription> userSubscription;

  SubscribeResponseAction(this.userSubscription);
}

UserState subscribeResponseReducer(UserState state, SubscribeResponseAction action) {
  return state.copyWith(
    user: _updateUserSubscription(state.user, action.userSubscription),
    isSubscriptionLoading: false,
  );
}


// ========== SubscribeAction Reducers ========== //

class SubscribeWebAction {
  SubscribeWebAction();
}

UserState subscribeWebActionReducer(UserState state, SubscribeWebAction action) {
  return state.copyWith(isSubscriptionLoading: true);
}

class SubscribeWebResponseAction {
  final List<UserSubscription> userSubscription;

  SubscribeWebResponseAction(this.userSubscription);
}

UserState subscribeWebResponseReducer(UserState state, SubscribeWebResponseAction action) {
  return state.copyWith(
    user: _updateUserSubscription(state.user, action.userSubscription),
    isSubscriptionLoading: false,
  );
}


// ========== Combine all reducers ========== //

Reducer<UserState> userReducer = combineReducers<UserState>([
  TypedReducer<UserState, CheckUsernameExistsAction>(checkUsernameExistsRequestReducer),
  TypedReducer<UserState, CheckUsernameExistsResponseAction>(checkUsernameExistsSuccessReducer),
  TypedReducer<UserState, SignInWithGoogle>(signInWithGoogleReducer),
  TypedReducer<UserState, SignInWithGoogleSuccessAction>(signInWithGoogleSuccessReducer),
  TypedReducer<UserState, SignUpAction>(getPostOwnerRequestReducer),
  TypedReducer<UserState, SignUpResponseAction>(signUpSuccessReducer),
  TypedReducer<UserState, ResetAuthScreensRequestAction>(resetAuthScreensRequestReducer),
  TypedReducer<UserState, ShowSignInScreenRequestAction>(showSignInScreenRequestReducer),
  TypedReducer<UserState, ShowSignUpScreenRequestAction>(showSignUpScreenRequestReducer),
  TypedReducer<UserState, HideSignUpScreenRequestAction>(hideSignUpScreenRequestReducer),
  TypedReducer<UserState, ShowForgotPasswordScreenRequestAction>(showForgotPasswordScreenRequestReducer),
  TypedReducer<UserState, HideForgotPasswordScreenRequestAction>(hideForgotPasswordScreenRequestReducer),
  TypedReducer<UserState, SinglePostRequestAction>(singlePostRequestReducer),
  TypedReducer<UserState, SinglePostBackAction>(singlePostBackReducer),
  TypedReducer<UserState, AddToFavouritesAction>(saveToFavouritesReducer),
  TypedReducer<UserState, RemoveFromFavouritesAction>(removeFromFavouritesReducer),
  TypedReducer<UserState, GetUserAccessTokenAction>(getUserAccessTokenActionReducer),
  TypedReducer<UserState, GetUserAccessTokenSuccessAction>(getUserAccessTokenSuccessReducer),
  TypedReducer<UserState, LogOutAction>(logOutActionReducer),
  TypedReducer<UserState, LogOutSuccessAction>(logOutSuccessReducer),
  TypedReducer<UserState, LoginAction>(loginReducer),
  TypedReducer<UserState, LoginSuccessAction>(loginSuccessReducer),
  TypedReducer<UserState, GetUserByIdAction>(getUserByIdActionReducer),
  TypedReducer<UserState, GetUserByUsernameAction>(getUserByUsernameActionReducer),
  TypedReducer<UserState, HandleErrorGetUserByIdAction>(handleErrorGetUserByIdReducer),
  TypedReducer<UserState, GetUserByIdResponseAction>(getUserByIdresponseReducer),
  TypedReducer<UserState, GetAllUsersResponseAction>(getAllUsersResponseReducer),
  TypedReducer<UserState, HandleErrorAllUsersAction>(handleErrorAllUsersReducer),
  TypedReducer<UserState, GetAllUsersAction>(getAllUsersActionReducer),
  // TypedReducer<UserState, HandleGenericErrorAction>(handleGenericErrorReducer),
  TypedReducer<UserState, UpdateUserAction>(updateUserActionReducer),
  TypedReducer<UserState, UpdateUserResponseAction>(updateUserResponseReducer),
  TypedReducer<UserState, DeleteUserAction>(deleteUserActionReducer),
  TypedReducer<UserState, UpdateUserSocialMediaLinksAction>(updateUserSocialMediaLinksActionReducer),
  TypedReducer<UserState, UpdateUserSocialMediaLinksResponseAction>(updateUserSocialMediaLinksResponseReducer),
  TypedReducer<UserState, AddUserSocialMediaLinksAction>(addUserSocialMediaLinksActionReducer),
  TypedReducer<UserState, DeleteUserSocialMediaLinksAction>(deleteUserSocialMediaLinksActionReducer),
  TypedReducer<UserState, AddUserInterestsAction>(addUserInterestsActionReducer),
  TypedReducer<UserState, DeleteUserInterestsAction>(deleteUserInterestsActionReducer),
  TypedReducer<UserState, UpdateUserInterestsResponseAction>(updateUserInterestsResponseActionReducer),
  TypedReducer<UserState, SaveToUserHistoryAction>(saveToUserHistoryReducer),
  TypedReducer<UserState, DeleteFromUserHistoryAction>(deleteFromUserHistoryReducer),
  TypedReducer<UserState, DeleteAllFromUserHistoryAction>(deleteAllFromUserHistoryReducer),
  // TypedReducer<UserState, ClearGenericErrorAction>(clearGenericErrorReducer),
  TypedReducer<UserState, GetUserSubscriptionAction>(getUserSubscriptionActionReducer),
  TypedReducer<UserState, GetUserSubscriptionResponseAction>(getUserSubscriptionResponseReducer),
  TypedReducer<UserState, UpdateUserSubscriptionAction>(updateUserSubscriptionActionReducer),
  TypedReducer<UserState, UpdateUserSubscriptionResponseAction>(updateUserSubscriptionResponseReducer),
  TypedReducer<UserState, DeleteUserSubscriptionAction>(deleteUserSubscriptionActionReducer),
  TypedReducer<UserState, DeleteUserSubscriptionResponseAction>(deleteUserSubscriptionResponseReducer),
  TypedReducer<UserState, SubscribeAction>(subscribeActionReducer),
  TypedReducer<UserState, SubscribeResponseAction>(subscribeResponseReducer),
  TypedReducer<UserState, SubscribeWebAction>(subscribeWebActionReducer),
  TypedReducer<UserState, SubscribeWebResponseAction>(subscribeWebResponseReducer),
]);