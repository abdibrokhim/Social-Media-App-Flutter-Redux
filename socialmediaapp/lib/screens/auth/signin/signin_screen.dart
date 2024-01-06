import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/components/shared/error/cuctom_error_widget.dart';
import 'package:socialmediaapp/screens/auth/components/google_provider.dart';
import 'package:socialmediaapp/screens/auth/components/username_input_dialog.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/screens/user/user_model.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';


class SignInScreen extends StatefulWidget {
  static String routeName = "/signIn";
  final VoidCallback? onSignUpRequested;
  final VoidCallback? onForgotPasswordRequested;
  
  const SignInScreen({
    Key? key, 
    this.onSignUpRequested,
    this.onForgotPasswordRequested,
  }) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _performLogin() async {
    if (_usernameController.text.isEmpty) {
      addError(error: 'Username is required');
      return;
    }
    if (_passwordController.text.isEmpty) {
      addError(error: 'Password is required');
      return;
    }
    
    StoreProvider.of<GlobalState>(context).dispatch(
      LoginAction(_usernameController.text, _passwordController.text),
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

  bool showOnce = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: StoreConnector<GlobalState, UserState>(
        converter: (store) => store.state.appState.userState,
        builder: (context, userState) {
          return SingleChildScrollView(
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
                    if (value.isNotEmpty) {
                      removeError(error: 'Username is required');
                    }
                  },
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(error: 'Password is required');
                    }
                  },
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: _performLogin,
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 20,),
                const Text('OR'),
                const SizedBox(height: 20,),
                SizedBox(
                  width: 300,
child:
                const SignInWithGoogleWidget(),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('I don\'t have an account, lemme '),
                    TextButton(
                      onPressed: () {
                        store.dispatch(ShowSignUpScreenRequestAction());
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('I forgot my password, lemme '),
                    TextButton(
                      onPressed: () {
                        store.dispatch(ShowForgotPasswordScreenRequestAction());
                      },
                      child: const Text('Reset Password'),
                    ),
                  ],
                )
              ],
            ),
          );
        },
        onDidChange: (prev, next) {
          if (next.isLoggedIn && next.userId != null) {
            store.dispatch(ShowUserProfileRequestAction(next.userId!));
            AppLog.log().i('User is logging in: ${next.user!.username}');
            if (next.googleSignInCompleted) {
              store.dispatch(UpdateUserAction(UpdateUser(firstName: next.googleSignInData!.displayName!, profileImage: next.googleSignInData!.photoUrl!)));
            }
          }
        },
        onDispose: (store) {},
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
