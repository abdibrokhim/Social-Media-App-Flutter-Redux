import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:socialmediaapp/components/shared/refreshable.dart';
import 'package:socialmediaapp/screens/explore/components/posts_wrapper_section.dart';
import 'package:socialmediaapp/screens/home/home_screen_reducer.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int limit = 10;
  final int offset = 1;
  
  @override
  void initState() {
    super.initState();
  }

  void reFetchData()  {
            store.dispatch(GetMadeForYouPostListRequestAction(limit, offset));
        store.dispatch(GetViralPostListRequestAction(limit, offset));
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    reFetchData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }



  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<GlobalState>(context);

    return StoreConnector<GlobalState, HomeScreenState>(
      onInit: (store) {
        store.dispatch(GetMadeForYouPostListRequestAction(limit, offset));
        store.dispatch(GetViralPostListRequestAction(limit, offset));
      },
      converter: (store) => store.state.appState.homeScreenState,
      builder: (context, homeScreenState) {

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
          ),
          body: Refreshable(
            refreshController: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: 
          homeScreenState.isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      state.state.appState.userState.isLoggedIn
                      ?
                        homeScreenState.isMadeForYouLoading
                          ? const CircularProgressIndicator()
                          :
                            PostsWrapperSection(
                              title: 'Made for ${state.state.appState.userState.user!.username}',
                              posts: homeScreenState.madeForYouPostList,
                              onTap: (postId) {
                                AppLog.log().i('Tapped on post with postId: $postId');
                                store.dispatch(SinglePostRequestAction(postId));
                              },
                            )
                      : const SizedBox(),
                      const Divider(),
                      homeScreenState.isViralLoading
                        ? const CircularProgressIndicator()
                        :
                          PostsWrapperSection(
                            title: "Today's viral posts",
                            posts: homeScreenState.viralPostList,
                            onTap: (postId) {
                              AppLog.log().i('Tapped on post with postId: $postId');
                              store.dispatch(SinglePostRequestAction(postId));
                            },
                          ),
                    ],
                  ),
                ),
              ),
            ),
        );
      },
    );
  }
}
