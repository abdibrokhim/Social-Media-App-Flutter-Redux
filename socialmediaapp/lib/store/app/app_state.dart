import 'package:socialmediaapp/screens/category/category_reducer.dart';
import 'package:socialmediaapp/screens/filters/post_filters/post_filters_reducer.dart';
import 'package:socialmediaapp/screens/filters/user_filters/user_filters_reducer.dart';
import 'package:socialmediaapp/screens/mainlayout/components/notification_reducer.dart';
import 'package:socialmediaapp/screens/settings/settings_reducer.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/screens/home/home_screen_reducer.dart';
import 'package:socialmediaapp/screens/post/update_post_reducer.dart';
import 'package:socialmediaapp/screens/post/create_post_reducer.dart';
import 'package:socialmediaapp/screens/post/post_reducer.dart';
import 'package:socialmediaapp/screens/explore/explore_screen_reducer.dart';
import 'package:socialmediaapp/screens/explore/single_post/single_post_reducer.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';

class AppState {
  final UserState userState;
  final HomeScreenState homeScreenState;
  final PostState postState;
  final ExploreScreenState exploreScreenState;
  final SinglePostScreenState singlePostScreenState;
  final CreatePostState createPostState;
  final UpdatePostState updatePostState;
  final PostFiltersState postFiltersState;
  final UserFiltersState userFiltersState;
  final ProfileScreenState profileScreenState;
  final AwesomeNotificationState awesomeNotificationState;
  final CategoryState categoryState;
  final SettingsState settingsState;
  

  AppState({
    required this.userState,
    required this.homeScreenState,
    required this.postState,
    required this.exploreScreenState,
    required this.singlePostScreenState,
    required this.createPostState,
    required this.updatePostState,
    required this.postFiltersState,
    required this.userFiltersState,
    required this.profileScreenState,
    required this.awesomeNotificationState,
    required this.categoryState,
    required this.settingsState,
  });
}