import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/screens/user/components/user_bubble_card.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/screens/filters/user_filters/user_filters_reducer.dart';


class UserFilterWidget extends StatelessWidget {
  
  const UserFilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<GlobalState, UserFiltersState>(
      converter: (store) => store.state.appState.userFiltersState,
      builder: (context, state) {
        if (state.users == null) {
          return const Center(child: Text('Enter a search word'));
        } else if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: state.users!.length,
            itemBuilder: (context, index) {
              final user = state.users![index];
              return UserBubbleCard(
                user: user,
                onTap: () {
                  store.dispatch(ShowUserProfileRequestAction(user.userId));
                }
              );
            },
          );
        }
      },
    );
  }
}
