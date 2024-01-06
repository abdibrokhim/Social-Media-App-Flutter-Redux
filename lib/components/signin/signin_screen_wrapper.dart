import 'package:flutter/material.dart';

class SignInScreenWrapper extends StatelessWidget {
  final Widget child;

  const SignInScreenWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 67, 67, 67),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const FlutterLogo(size: 100.0),
      ),
      body: child,
    );
  }
}