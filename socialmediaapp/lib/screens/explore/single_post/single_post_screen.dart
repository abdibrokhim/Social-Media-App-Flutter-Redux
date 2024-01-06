import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/components/shared/build_cached_image.dart';
import 'package:socialmediaapp/screens/explore/single_post/components/datetime_helper.dart';
import 'package:socialmediaapp/screens/explore/single_post/components/like_widget.dart';
import 'package:socialmediaapp/screens/explore/single_post/components/more_options_dialog.dart';
import 'package:socialmediaapp/screens/explore/single_post/single_post_reducer.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/screens/user/components/user_bubble_card.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';


class SinglePostScreen extends StatefulWidget {
  static const String routeName = "/singlePost";

  const SinglePostScreen({
    Key? key, 
  }) : super(key: key);

    @override
  _SinglePostScreenState createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {

  late int postId;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (store.state.appState.userState.selectedPostId != null) {
      postId = store.state.appState.userState.selectedPostId!;
    }
    AppLog.log().i('single post screen, post id: $postId');
  }


  @override
  Widget build(BuildContext context) {
    return StoreConnector<GlobalState, SinglePostScreenState>(
      onInit: (app) {
        AppLog.log().i('onInit single post screen');
        store.dispatch(GetSinglePostRequestAction(postId));
        store.dispatch(GetPostLikedUserListRequestAction(postId));
        store.dispatch(GetPostOwnerRequestAction(postId));
        store.dispatch(GetPostLikesRequestAction(postId));
        store.dispatch(GetIsPostLikedRequestAction(postId));
        AppLog.log().i(store.state.appState.singlePostScreenState.isPostLiked);
      },
      converter: (store) => store.state.appState.singlePostScreenState,
      builder: (context, state) {
        var store = StoreProvider.of<GlobalState>(context);
        return
    Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            store.dispatch(SinglePostBackAction());
          },
        ),
        title: const Text('Post'),
      ),
      body: state.post == null || state.isLoading
      ? const CircularProgressIndicator()
      :
      SingleChildScrollView(
                  child: 
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: buildCachedImagePlaceHolder(
              state.post!.image!,
              context,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(state.post!.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.post!.description!,
                        maxLines: isExpanded ? null : 3,
                        overflow: TextOverflow.fade,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(isExpanded ? 'Read less' : 'Read more'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Since: ${getUploadTime(state.post!.createdAt)}'),
                  const SizedBox(height: 8),
                  if (state.post!.updatedAt != null )
                    const Text('(edited)'),
                  const SizedBox(height: 8),
                  if (state.post!.categories != null && state.post!.categories!.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      children: state.post!.categories!.map((category) => 
                        ActionChip(
                          label: Text(category.name),
                          onPressed: () {
                            // Handle category click
                            AppLog.log().i('Category is clicked: ${category.name}');
                          },
                        ),
                      ).toList(),
                    ),
                  const SizedBox(height: 8),
                  buildLikeWidget(
                    context: context, 
                    gState: store, 
                    postId: postId
                  ),
                  const SizedBox(height: 8),
                  state.postOwner != null
                    ? 
                      UserBubbleCard(
                        user: state.postOwner!, 
                        onTap: () {
                          AppLog.log().i('Loading profile user id: ${state.postOwner!.userId}');
                          store.dispatch(ShowUserProfileRequestAction(state.postOwner!.userId));
                          store.dispatch(SinglePostBackAction());
                        },
                      ) 
                    : const CircularProgressIndicator()
                ],
              ),
            ),
          ),
          if (state.postOwner != null)
            if (state.postOwner!.userId == store.state.appState.userState.userId && store.state.appState.profileScreenState.showUserProfileScreen)
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => showSinglePostMoreOptionsDialog(context),
              ),
        ],
      ),
                    ],
                  )
      )
    );
  }
    );
  }
}



