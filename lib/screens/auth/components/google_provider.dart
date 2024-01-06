import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/constants.dart';

class SignInWithGoogleWidget extends StatelessWidget {
  const SignInWithGoogleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        store.dispatch(SignInWithGoogle());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(
            googleIcon,
            height: 30,
          ),
          const Text(
            'Sign in with Google',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          Opacity(
            opacity: 0,
            child: Image.network(
              googleIcon,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}