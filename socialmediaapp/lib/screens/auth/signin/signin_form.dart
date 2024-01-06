// import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:socialmediaapp/components/signin/custom_input_decoration.dart';
// import 'package:socialmediaapp/screens/user/user_reducer.dart';
// import 'package:socialmediaapp/store/app/app_store.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socialmediaapp/utils/logs.dart';


// class SignInForm extends StatefulWidget {
//   const SignInForm({super.key});

//   @override
//   _SignInFormState createState() => _SignInFormState();
// }

// class _SignInFormState extends State<SignInForm> {
//   static final _formKey = GlobalKey<FormState>();
//   String? email;
//   String? password;
//   bool? remember = false;
//   final List<String?> errors = [];
//   bool obscurePassword = true;

//   @override
//   Widget build(BuildContext context) {
//     var state = StoreProvider.of<GlobalState>(context);

//     return StoreConnector<GlobalState, UserState>(
//         converter: (appState) => appState.state.appState.userState,
//         builder: (context, userState) {
//           return Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                       buildEmailFormField(state.state.appState.userState.user!.email),
//                       SizedBox(height: 20),
//                       buildPasswordFormField(context),
//                       SizedBox(height: 20),
//                       Row(
//                         children: [
//                           SizedBox(
//                             width: 30,
//                             height: 30,
//                             child: Checkbox(
//                               fillColor: MaterialStateProperty.all(
//                                   Colors.white),
//                               value: remember,
//                               checkColor:
//                                   Theme.of(context).colorScheme.primary,
//                               activeColor: Colors.white,
//                               onChanged: (value) {
//                                 setState(() {
//                                   remember = value!;
//                                 });
//                               },
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(100.0),
//                               ),
//                               side: const BorderSide(color: Colors.black),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () => setState(() {
//                               remember = !remember!;
//                             },),
//                             child: Text(
//                               "Remember me",
//                               style: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                           GestureDetector(
//                             onTap: () {
//                               AppLog.log().i('Forgot password');
//                               // Navigator.pushNamed(
//                               //     context, ForgotPasswordScreen.routeName);
//                             },
//                             child: Text(
//                               "Forgot Password",
//                               style: TextStyle(
//                                   color: Theme.of(context).colorScheme.primary,
//                                   fontSize: 16,
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//               ],
//             ),
//           );
//         },
//         // onDidChange: (store, state) async {
//         //   if (!s.loginRequired) {

//         //     if (remember!) {
//         //       await saveUserIdToStorage(s.userId);
//         //     }
//         //     Navigator.maybePop(context);
//         //   }
//         // },
//         onDispose: (store) {});
//   }

//   // Function to save the userId in app storage
//   Future<void> saveUserIdToStorage(String? userId) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('userId', userId ?? '');
//   }

//   TextFormField buildPasswordFormField(BuildContext context) {
//     var state = StoreProvider.of<GlobalState>(context);
//     return TextFormField(
//         obscureText: obscurePassword,
//         onSaved: (newValue) => password = newValue,
//         onChanged: (value) {
//           if (value.isNotEmpty && value.length >= 8) {
//             state.dispatch(ClearGenericErrorAction());
//           }
//           password = value;
//         },
//         validator: (value) {
//           if (value!.isEmpty) {
//             state.dispatch(HandleGenericErrorAction('Password is required'));
//             return "";
//           } else if (value.length < 8) {
//             state.dispatch(HandleGenericErrorAction('Password is too short'));
//             return "";
//           }
//           return null;
//         },
//         decoration: inputDecorationWitIcon(
//           hintText: 'Password',
//           onTap: () {
//             setState(() {
//               obscurePassword = !obscurePassword;
//             });
//           },
//           icon: obscurePassword ? Icons.visibility : Icons.visibility_off,
//           context: context
//         )
//     );
//   }

//   TextFormField buildEmailFormField(String? userEmail) {
//     var state = StoreProvider.of<GlobalState>(context);
//     userEmail = userEmail != "" ? userEmail : null;
    
//     final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

//     return TextFormField(
//       initialValue: email,
//       keyboardType: TextInputType.emailAddress,
//       onSaved: (newValue) => email = newValue,
//       onChanged: (value) {
//         if (value.isNotEmpty && emailValidatorRegExp.hasMatch(value)) {
//           state.dispatch(ClearGenericErrorAction());
//         }
//         return;
//       },
//       validator: (value) {
//         if (value!.isEmpty) {
//           state.dispatch(HandleGenericErrorAction('Email is required'));
//           return "";
//         } else if (!emailValidatorRegExp.hasMatch(value)) {
//           state.dispatch(HandleGenericErrorAction('Please enter a valid email address'));
//           return "";
//         }
//         return null;
//       },
//       decoration: inputDecoration(
//         hintText: 'Email', 
//         context: context
//       ));
//   }
// }