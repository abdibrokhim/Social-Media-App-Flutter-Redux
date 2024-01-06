import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/components/shared/error/cuctom_error_widget.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/logs.dart';


class ForgotPasswordScreen extends StatefulWidget {
  static String routeName = "/forgotPassword";
  
  const ForgotPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _performForgotPassword() {
    AppLog.log().i('Performing forgot password.');
    AppLog.log().i('Not implemented yet.');
    AppLog.log().i('You may back to sign in screen.');
            if (_emailController.text.isEmpty) {
      addError(error: 'Email is required');
      return;
    }
    // StoreProvider.of<GlobalState>(context).dispatch(
      // ForgotPasswordAction(_emailController.text),
    // );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: StoreConnector<GlobalState, UserState>(
        converter: (store) => store.state.appState.userState,
        builder: (context, state) {
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
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(error: 'Email is required');
                    }
                  },
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: _performForgotPassword,
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Back to '),
                    TextButton(
                    onPressed: () {
                      store.dispatch(ShowSignInScreenRequestAction());
                    },
                      child: const Text('Sign in'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
