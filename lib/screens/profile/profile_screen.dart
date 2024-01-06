import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:socialmediaapp/components/shared/build_cached_image.dart';
import 'package:socialmediaapp/components/shared/icon_button.dart';
import 'package:socialmediaapp/components/shared/refreshable.dart';
import 'package:socialmediaapp/screens/explore/components/posts_wrapper_section.dart';
import 'package:socialmediaapp/screens/profile/components/add_social_media_dialog.dart';
import 'package:socialmediaapp/screens/profile/components/create_post_dialog.dart';
import 'package:socialmediaapp/screens/profile/components/edit_interests_dialog.dart';
import 'package:socialmediaapp/screens/profile/components/edit_social_media_dialog.dart';
import 'package:socialmediaapp/screens/profile/components/edit_user_info_dialog.dart';
import 'package:socialmediaapp/screens/profile/components/follow_widget.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/screens/user/user_model.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/components/category/category_model.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';
import 'package:socialmediaapp/utils/constants.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';



class ProfileScreen extends StatefulWidget {
  static const String routeName = "/profile";
  final int? userId;

  const ProfileScreen({
    Key? key,
    this.userId,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  late int pUserId;
  bool isOwner = false;

  @override
  void initState() {
    super.initState();

    if (widget.userId != null) {
      pUserId = widget.userId!;
    } else {
      if (store.state.appState.profileScreenState.selectedUserId != null) {
        pUserId = store.state.appState.profileScreenState.selectedUserId!;
      }
      AppLog.log().i('profile screen, user id: $pUserId');
    }
    
  }

  void reFetchData()  {
    var state = StoreProvider.of<GlobalState>(context);

    AppLog.log().i('fetching user in reFetchData');
    state.dispatch(GetUserAction(pUserId));
    AppLog.log().i('fetching user meta info');
    state.dispatch(GetUserMetaInfoAction(pUserId));
    AppLog.log().i('fetching user interests');
    state.dispatch(GetUserInterestsAction(pUserId));
    AppLog.log().i('fetching user social media links');
    state.dispatch(GetUserSocialMediaLinksAction(pUserId));
    AppLog.log().i('fetching user posts');
    state.dispatch(GetUserPostsAction(pUserId));
    AppLog.log().i('fetching user subscription');
    state.dispatch(GetUserSubscriptionAction());
    AppLog.log().i('fetching user followers');
    state.dispatch(GetFollowersListRequestAction(pUserId));
    AppLog.log().i('fetching user followings');
    state.dispatch(GetFollowingsListRequestAction(pUserId));
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
    return StoreConnector<GlobalState, ProfileScreenState>(
      onDidChange: (prev, next) {
        setState(() {
          isOwner = store.state.appState.userState.userId == next.selectedUserId && store.state.appState.userState.isLoggedIn; 
        });
      },
      onInit: (store) {
        AppLog.log().i('fetching user in onInit');
        store.dispatch(GetUserAction(pUserId));
        AppLog.log().i('fetching user meta info');
        store.dispatch(GetUserMetaInfoAction(pUserId));
        AppLog.log().i('fetching user interests');
        store.dispatch(GetUserInterestsAction(pUserId));
        AppLog.log().i('fetching user social media links');
        store.dispatch(GetUserSocialMediaLinksAction(pUserId));
        AppLog.log().i('fetching user posts');
        store.dispatch(GetUserPostsAction(pUserId));
        AppLog.log().i('fetching user subscription');
        store.dispatch(GetUserSubscriptionAction());
        AppLog.log().i('fetching user followers');
        store.dispatch(GetFollowersListRequestAction(pUserId));
        AppLog.log().i('fetching user followings');
        store.dispatch(GetFollowingsListRequestAction(pUserId));
      },
      converter: (store) => store.state.appState.profileScreenState,
      builder: (context, profileScreenState) {
        var state = StoreProvider.of<GlobalState>(context);
        
        AppLog.log().i('is profile owner: $isOwner');

        return Scaffold(
          appBar: AppBar(
            leading: !isOwner ?
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                AppLog.log().i('Tapped on back button on profile screen.');
                store.dispatch(HideUserProfileRequestAction());
              },
            ) : null,
            title: const Text('Profile'),
          ),
          body: 
          Refreshable(
            refreshController: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: 
          profileScreenState.user == null
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
              child:
              Column(
                children: [
                  !profileScreenState.isLoading
                    ? _buildHeaderSection(
                      profileScreenState.user!)
                    : const Center(child: CircularProgressIndicator()),
                  const Divider(),
                  !profileScreenState.isInterestsLoading && profileScreenState.user!.interests != null
                    ? _buildInterestsSection(
                      profileScreenState.user!.interests)
                    : const Center(child: CircularProgressIndicator()),
                  const Divider(),
                  !profileScreenState.isSocialMediaLinksLoading && profileScreenState.user!.socialMediaLinks != null
                    ? _buildSocialMediaLinksSection(
                      profileScreenState.user!.socialMediaLinks)
                    : const Center(child: CircularProgressIndicator()),
                  const Divider(),
                  if (isOwner)
                    buildIconButton(
                      icon: Icons.post_add_rounded,
                      text: 'Create Post',
                      onPressed: () => showCreatePostDialog(context),
                    ),
                  const Divider(),
                  !profileScreenState.isPostsLoading && profileScreenState.user!.posts != null
                    ? _buildPostsGrid()
                    : const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildHeaderSection(User user) {
    var state = StoreProvider.of<GlobalState>(context);

    return  StoreConnector<GlobalState, ProfileScreenState>(
    converter: (store) => store.state.appState.profileScreenState,
    builder: (context, profileScreenState) {
      return
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: MediaQuery.of(context).size.width > 600 
      ?
      Row(
        children: [
          CircleAvatar(
            backgroundImage: buildImageProviderPlaceHolder(user.profileImage, context),
            radius: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          '${user.firstName ?? ""} ${user.lastName ?? ""}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ]
                    ),
                    const SizedBox(height: 16),
                    if (isOwner)
                      buildIconButton(
                        icon: Icons.edit,
                        text: 'Edit',
                        onPressed: () => showEditUserInfoDialog(context),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                !state.state.appState.profileScreenState.isMetaInfoLoading && state.state.appState.profileScreenState.user!.metaInfo != null
                  ? _buildUserMetaInfoSection(
                    user,
                    gState: state
                    )
                  : const Center(child: CircularProgressIndicator()),
const SizedBox(height: 20),
              if (!isOwner && profileScreenState.selectedUserId != null)
                builFollowWidget(
                  context: context, 
                  gState: state, 
                  userId: profileScreenState.selectedUserId!,
                ),
              ],
            ),
          ),
        ],
      )
      :
      Column(
        children: [
          CircleAvatar(
            backgroundImage: buildImageProviderPlaceHolder(user.profileImage, context),
            radius: 40,
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        '${user.firstName ?? ""} ${user.lastName ?? ""}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ]
                  ),
                  const SizedBox(height: 16),
                  if (isOwner)
                    buildIconButton(
                      icon: Icons.edit,
                      text: 'Edit',
                      onPressed: () => showEditUserInfoDialog(context),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              !state.state.appState.profileScreenState.isMetaInfoLoading && state.state.appState.profileScreenState.user!.metaInfo != null
                ? _buildUserMetaInfoSection(
                  user, 
                  gState: state
                  )
                : const Center(child: CircularProgressIndicator()),
              
              const SizedBox(height: 20),
              if (!isOwner && profileScreenState.selectedUserId != null)
                builFollowWidget(
                  context: context, 
                  gState: state, 
                  userId: profileScreenState.selectedUserId!,
                ),
            ],
          ),
        ],
      ),
    );
    });
  }

  Widget _buildUserMetaInfoSection(User user, {required Store<GlobalState> gState,}) {

    return StoreConnector<GlobalState, ProfileScreenState>(
    converter: (store) => store.state.appState.profileScreenState,
    builder: (context, profileScreenState) {
    
    int? followersCount = profileScreenState.followersList != null ? profileScreenState.followersList!.length : 0;

      return
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMetaInfoItem(
          followersCount > 1 ? 'Followers' : 'Follower',
          followersCount.toString(),
          mKey: 'followers',
        ),
        _buildMetaInfoItem(
          'Following',
          user.metaInfo!.following.toString(),
          mKey: 'following',
        ),
        _buildMetaInfoItem(
          user.metaInfo!.likes > 1 ? 'Likes' : 'Like',
          user.metaInfo!.likes.toString()
        ),
      ],
    );
    },);
  }

  Widget _buildMetaInfoItem(String label, String value, {String? mKey}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        InkWell(
        onTap: () {
          print('not implemented yet');

          // TODO: implement this
          // if (mKey == "followers") {
          //   showSearchableFollowersDialog(context);
          // }
          // if (mKey == "following") {
          //   showSearchableFollowingsDialog(context);
          // }
        },
        child: 
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
      ],
    );
  }


  Widget _buildSocialMediaLinksSection(List<SocialMediaLink>? links) {

    var state = StoreProvider.of<GlobalState>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Social Media Links',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (isOwner && links!.length < socialMediaIcons.length)
                buildIconButton(
                  icon: Icons.add,
                  text: 'Add',
                  onPressed: () => addSocialMediaLinkDialog(context),
                ),
            ],
          ),
          ...links!.map((link) => ListTile(
                leading: Image.network(link.icon, width: 20, height: 20),
                title: Text(link.name),
                subtitle: Text(link.url),
                trailing: (isOwner)
                ?
                  buildIconButton(
                    icon: Icons.edit,
                    text: 'Edit',
                    onPressed: () => editSocialMediaLinkDialog(context, link),
                  )
                : const Icon(Icons.launch),
                onTap: () => _launchURL(link.url),
              ))
              .toList(),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppLog.log().i('Could not launch $url');
      
      // Optionally, show an alert dialog or a snackbar to inform the user.
    }
  }


  Widget _buildInterestsSection(List<Category>? interests) {
    var state = StoreProvider.of<GlobalState>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Interests',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (isOwner)
                buildIconButton(
                  icon: Icons.edit,
                  text: 'Edit',
                  onPressed: () => showEditInterestsDialog(context),
                ),
            ],
          ),
          Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: interests!.map((category) => Chip(
              label: Text(category.name),
              avatar: const Icon(Icons.category),
            )).toList(),
          ),
        ],
      ),
    );
  }


  Widget _buildPostsGrid() {

    return StoreConnector<GlobalState, ProfileScreenState>(
      onDidChange: (prev, next) {
        setState(() {
        });
      },
      onInit: (store) {},
      converter: (store) => store.state.appState.profileScreenState,
      builder: (context, profileScreenState) {
        var posts = profileScreenState.user!.posts;

    if (posts == null || posts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: Text(
            'No posts yet.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        )
      );
    }

    posts.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        return
    PostsWrapperSection(
      title: 'All Posts',
      posts: posts,
      onTap:(postId) {
        AppLog.log().i('Tapped on post with postId: $postId');
        store.dispatch(SinglePostRequestAction(postId));
      },
    );
  },
    );
  }

}
