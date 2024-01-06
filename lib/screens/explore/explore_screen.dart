import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:socialmediaapp/components/shared/refreshable.dart';
import 'package:socialmediaapp/screens/explore/components/posts_wrapper_section.dart';
import 'package:socialmediaapp/screens/explore/explore_screen_reducer.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';


class ExploreScreen extends StatefulWidget {
  static const String routeName = "/explore";

  const ExploreScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final int trendingLimit = 10;
  final int newLimit = 10;
  final int diverseLimit = 10;

  void reFetchData()  {
            store.dispatch(GetTrendingPostListRequestAction(trendingLimit));
        store.dispatch(GetDiversePostListRequestAction(diverseLimit));
        store.dispatch(GetNewPostListRequestAction(newLimit));
   
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
    return StoreConnector<GlobalState, ExploreScreenState>(
      onInit: (store) {
        store.dispatch(GetTrendingPostListRequestAction(trendingLimit));
        store.dispatch(GetDiversePostListRequestAction(diverseLimit));
        store.dispatch(GetNewPostListRequestAction(newLimit));
      },
      converter: (store) => store.state.appState.exploreScreenState,
      builder: (context, exploreScreenState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Explore'),
          ),
          body: Refreshable(
            refreshController: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: 
          exploreScreenState.isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: [
                      exploreScreenState.isTrendingPostListLoading
                      ? const CircularProgressIndicator()
                      :
                        PostsWrapperSection(
                          title: 'Trending',
                          posts: exploreScreenState.trendingPostList,
                          onTap:(postId) {
                            AppLog.log().i('Tapped on post with postId: $postId');
                            store.dispatch(SinglePostRequestAction(postId));
                          },
                        ),
                      const Divider(),
                      exploreScreenState.isDiversePostListLoading
                      ? const CircularProgressIndicator()
                      :
                        PostsWrapperSection(
                          title: 'Diverse',
                          posts: exploreScreenState.diversePostList,
                          onTap:(postId) {
                            AppLog.log().i('Tapped on post with postId: $postId');
                            store.dispatch(SinglePostRequestAction(postId));
                          },
                        ),
                      const Divider(),
                      exploreScreenState.isNewPostListLoading
                      ? const CircularProgressIndicator()
                      :
                        PostsWrapperSection(
                          title: 'New',
                          posts: exploreScreenState.newPostList,
                          onTap:(postId) {
                            AppLog.log().i('Tapped on post with postId: $postId');
                            store.dispatch(SinglePostRequestAction(postId));
                          },
                        ),
                  ],
                ),
              ),
            ),
        );
      },
    );
  }
}