import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/screens/auth/forgotpassword/forgot_password_screen.dart';
import 'package:socialmediaapp/screens/auth/signin/signin_screen.dart';
import 'package:socialmediaapp/screens/auth/signup/signup_screen.dart';
import 'package:socialmediaapp/screens/explore/explore_screen.dart';
import 'package:socialmediaapp/screens/explore/single_post/single_post_screen.dart';
import 'package:socialmediaapp/screens/filters/filter_screen.dart';
import 'package:socialmediaapp/screens/home/home_screen.dart';
import 'package:socialmediaapp/screens/profile/profile_screen.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/screens/settings/settings_screen.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_state.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';


class MainLayout extends StatefulWidget {

  const MainLayout({
    Key? key,
  }) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;


  @override
  void initState() {
    super.initState();
  }


  Widget _getContent(BuildContext context) {
    
    var state = StoreProvider.of<GlobalState>(context);

    AppLog.log().i('Test print from MainLayout');
    if (state.state.appState.userState.showSinglePostScreen && state.state.appState.userState.selectedPostId != null) {
      return const SinglePostScreen();
    }
    if (state.state.appState.profileScreenState.showUserProfileScreen && (state.state.appState.profileScreenState.selectedUserId != null || state.state.appState.userState.userId != null)) {
      return const ProfileScreen();
    }

    if (!state.state.appState.userState.isLoggedIn) {
      if (state.state.appState.userState.showSignUpScreen) {
        return const SignUpScreen();
      } else if (state.state.appState.userState.showForgotPasswordScreen) {
        return const ForgotPasswordScreen();
      }

      switch (_selectedIndex) {
        case 0:
          return const HomeScreen();
        case 1:
          return const FilterScreen();
        case 2:
          return const ExploreScreen();
        default:
          return const SignInScreen();
      }
    } else {
      switch (_selectedIndex) {
        case 0:
          return const HomeScreen();
        case 1:
          return const FilterScreen();
        case 2:
          return const ExploreScreen();
        case 3:
          return ProfileScreen(userId: store.state.appState.userState.userId);
        case 4:
          return const SettingsScreen();
        default:
          return const HomeScreen();
      }
    }
  }

  void _onTabSelected(int index) {
    store.dispatch(SinglePostBackAction());
    store.dispatch(ResetAuthScreensRequestAction());
    store.dispatch(HideUserProfileRequestAction());
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      if (_selectedIndex == 3 && store.state.appState.userState.userId != null && store.state.appState.userState.isLoggedIn) {
        print('user id: ${store.state.appState.userState.userId}');
        store.dispatch(ShowUserProfileRequestAction(store.state.appState.userState.userId!));
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    // var state = StoreProvider.of<GlobalState>(context);

        return
        Scaffold(
          body: 
          Row(
            children: [
              NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onTabSelected,
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_rounded),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.search_outlined),
                    label: Text('Search'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.explore_rounded),
                    label: Text('Explore'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text('Profile'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                ],
              ),
              Expanded(
                child: StoreConnector<GlobalState, AppState>(
                  onDidChange: (prev, next) {
                    if (next.profileScreenState.selectedUserId == prev!.userState.userId && next.profileScreenState.showUserProfileScreen && next.userState.isLoggedIn) {
                      // if (next.profileScreenState.selectedUserId != null) {
                      //   store.dispatch(GetUserAction(next.profileScreenState.selectedUserId!));
                      // }
                      Future.microtask(() => 
                        setState(() {
                          _selectedIndex = 3;
                        })
                      );
                    }
                  },
                  onInit: (app) {
                    print('test print from onInit main layout screen');
                    if (store.state.appState.userState.isLoggedIn && store.state.appState.userState.userId != null && store.state.appState.userState.accessToken != null) {
                      print('getting user access token');
                      store.dispatch(GetUserAccessTokenAction());
                    }
                    if (store.state.appState.userState.userId != null) {
                      AppLog.log().i('onInit');
                      print('getting user small ');
                      store.dispatch(GetUserAction(store.state.appState.userState.userId!));
                      AppLog.log().i('User is logged in: ${store.state.appState.userState.user!.username}');
                      AppLog.log().i('User access token: ${store.state.appState.userState.accessToken}');
                      AppLog.log().i('User refresh token: ${store.state.appState.userState.refreshToken}');
                    }
                  },
                  converter: (store) => store.state.appState,
                  builder: (context, appState) {
                    return
                            _getContent(context);
                  },
                ),
              ),
            ],
          )
        );
  }
}
