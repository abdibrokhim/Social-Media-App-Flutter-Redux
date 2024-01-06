import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/components/shared/error/cuctom_error_widget.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';


class SignUpScreen extends StatefulWidget {
  static const String routeName = "/signUp";

  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _performSignUp() {
        if (_emailController.text.isEmpty) {
      addError(error: 'Email is required');
      return;
    }
        if (_usernameController.text.isEmpty) {
      addError(error: 'Username is required');
      return;
    }
    if (_passwordController.text.isEmpty) {
      addError(error: 'Password is required');
      return;
    }
    StoreProvider.of<GlobalState>(context).dispatch(
      SignUpAction(_usernameController.text, _emailController.text, _passwordController.text),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: StoreConnector<GlobalState, UserState>(
        onDidChange: (prev, next) {
          if (next.isSignedUp) {
            store.dispatch(ShowSignInScreenRequestAction());
          }
        },
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
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Email is required');
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
              onPressed: _performSignUp,
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('I already have an account, lemme '),
                TextButton(
                  onPressed: () {
                    store.dispatch(ShowSignInScreenRequestAction());
                  },
                  child: const Text('Sign in'),
                ),
              ],
            )
          ],
        ),
      );
              },
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
