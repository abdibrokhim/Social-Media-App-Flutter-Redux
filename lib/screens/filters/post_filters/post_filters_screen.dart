import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/screens/explore/components/posts_wrapper_section.dart';
import 'package:socialmediaapp/screens/filters/post_filters/post_filters_reducer.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';

class PostFilterWidget extends StatelessWidget {
  
  const PostFilterWidget({
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return StoreConnector<GlobalState, PostFiltersState>(
      converter: (store) => store.state.appState.postFiltersState,
      builder: (context, postFiltersState) {
        if (postFiltersState.posts == null) {
          return const Center(child: Text('Enter a search word'));
        } else if (postFiltersState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: PostsWrapperSection(
              posts: postFiltersState.posts!,
              onTap:(postId) {
                AppLog.log().i('Tapped on post with postId: $postId');
                store.dispatch(SinglePostRequestAction(postId));
              },
            ),
          );
        }
      },
    );
  }
}
