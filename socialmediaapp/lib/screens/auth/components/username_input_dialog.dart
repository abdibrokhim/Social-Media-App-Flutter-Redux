import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/components/shared/error/cuctom_error_widget.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';


class ShowUserNameInputDialog extends StatefulWidget {

  const ShowUserNameInputDialog({
    Key? key,
  }) : super(key: key);

  @override
  _ShowUserNameInputDialogState createState() => _ShowUserNameInputDialogState();
}

class _ShowUserNameInputDialogState extends State<ShowUserNameInputDialog> {
  final TextEditingController _usernameController = TextEditingController();

  void _performSignUp() {
        if (_usernameController.text.isEmpty) {
      addError(error: 'Username is required');
      return;
    }
   var state = StoreProvider.of<GlobalState>(context);

    StoreProvider.of<GlobalState>(context).dispatch(
      SignUpAction(_usernameController.text, state.state.appState.userState.googleSignInData!.email!, state.state.appState.userState.googleSignInData!.idToken!),
    );
  }

    List<String> errors = [];

  @override
  void initState() {
    super.initState();

    initErrors();
  }


  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void initErrors() {
    setState(() {
      errors = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<GlobalState>(context);

  return Dialog(
      child: SizedBox(
        width: 400,
        height: 400,
        child:
          Padding(
            padding: const EdgeInsets.all(20.0),
            child:
            StoreConnector<GlobalState, UserState>(
        // onDidChange: (prev, next) {
        //   if (!next.isSignedUp) {
        //     store.dispatch(LoginAction(_usernameController.text, next.googleSignInData!.idToken!));
        //   }
        // },
              onInit: (store) {
              },
              converter: (store) => store.state.appState.userState,
              builder: (context, userState) {
                return
      SingleChildScrollView(
        child: Column(
          children: [
                                  const SizedBox(height: 20,),
                                  if (errors.isNotEmpty)
                      CustomErrorWidget(
                        errors: errors
                      ),
                      const SizedBox(height: 20,),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              onChanged: (value) {
                store.dispatch(CheckUsernameExistsAction(value));
                if (value.isNotEmpty) {
                  removeError(error: 'Username is required');
                }
              },
            ),
            if (userState.usernameExists)
              const Text('Username already in use.'),
            const SizedBox(height: 20,),
            Row(
              children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 20,),
            ElevatedButton(
              onPressed: _performSignUp,
              child: const Text('Proceed'),
            ),
              ],
            ),
          ],
        ),
      );
              },
      ),
      ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}


void showUsernameInputDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const ShowUserNameInputDialog();
    }
  );
}