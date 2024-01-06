import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/components/category/category_model.dart';
import 'package:socialmediaapp/components/shared/icon_button.dart';
import 'package:socialmediaapp/components/shared/toast.dart';
import 'package:socialmediaapp/screens/category/category_reducer.dart';
import 'package:socialmediaapp/screens/mainlayout/components/notification_reducer.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/screens/user/user_model.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';


class EditInterestsDialog extends StatefulWidget {

  const EditInterestsDialog({Key? key}) : super(key: key);

  @override
  _EditInterestsDialogState createState() => _EditInterestsDialogState();
}

class _EditInterestsDialogState extends State<EditInterestsDialog> {
  bool isAddingInterest = false;
  int? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<GlobalState>(context).state.appState.profileScreenState;
      return Dialog(
        child: SizedBox(
          width: 300,
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StoreConnector<GlobalState, List<Category>?>(
              converter: (store) => store.state.appState.profileScreenState.user!.interests,
              builder: (context, interests) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Edit Interests'),
                    const Divider(),
                    Wrap(
                      spacing: 8.0, // gap between adjacent chips
                      runSpacing: 4.0, // gap between lines
                      children: interests!.map((category) => Chip(
                        label: Text(category.name),
                        avatar: const Icon(Icons.category),
                        deleteIcon: const Icon(Icons.cancel),
                        onDeleted: () {
                          AppLog.log().i('Tapped on delete interest: ${category.name}');
                          store.dispatch(DeleteUserInterestsAction(category.id));
                          AppLog.log().i('fetching user interests');
                          store.dispatch(GetUserInterestsAction(state.selectedUserId!));
                          showToast(message: "You have deleted interest", bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
                        },
                      )).toList(),
                    ),
                    const Divider(),
                    isAddingInterest ? StoreConnector<GlobalState, CategoryState>(
                      converter: (store) => store.state.appState.categoryState,
                      builder: (context, categoryState) {
                        return
                        categoryState.isLoading 
                          ? const Center(child: CircularProgressIndicator())
                          :
                            DropdownButton<int>(
                              hint: const Text("Select Interest"),
                              value: selectedCategoryId,
                              onChanged: (int? newValue) {
                                setState(() {
                                  selectedCategoryId = newValue;
                                });
                                if (selectedCategoryId != null) {
                                  UserInterest userInterest = UserInterest(
                                    categoryId: selectedCategoryId!,
                                  );
                                  store.dispatch(AddUserInterestsAction(userInterest));
                                  AppLog.log().i('fetching user interests');
                                  store.dispatch(GetUserInterestsAction(state.selectedUserId!));
                                }
                                setState(() {
                                  isAddingInterest = false;
                                });
                              },
                              items: categoryState.categories!.map((category) {
                                return DropdownMenuItem<int>(
                                  value: category.id,
                                  child: Text(category.name),
                                );
                              }).toList(),
                            );
                        },
                    ) : buildIconButton(
                      icon: Icons.add,
                      text: 'Add',
                      onPressed: () {
                        AppLog.log().i('Tapped on add interest');
                        AppLog.log().i('Fetching category list');
                        store.dispatch(GetCategoryListAction());
                        setState(() {
                          isAddingInterest = true;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
  }
}



void showEditInterestsDialog(BuildContext context) {

  AppLog.log().i('Showing user profile edit interests dialog.');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const EditInterestsDialog();
    }
  );
}

