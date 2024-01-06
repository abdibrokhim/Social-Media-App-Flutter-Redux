import 'package:socialmediaapp/components/shared/get_access_token.dart';
import 'package:socialmediaapp/components/shared/toast.dart';
import 'package:socialmediaapp/screens/auth/auth_service.dart';
import 'package:socialmediaapp/screens/mainlayout/components/notification_reducer.dart';
import 'package:socialmediaapp/screens/user/components/google_signin_model.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socialmediaapp/screens/auth/components/secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {

  static Future<GoogleSignInData> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      // final FirebaseAuthService _auth = FirebaseAuthService();
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      
      if(googleSignInAccount != null ) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
      }

      final User? user = _firebaseAuth.currentUser;

      if(user != null) {
        final idToken = await user.getIdToken();
        final accessToken = await user.getIdTokenResult();
        final refreshToken = await user.getIdTokenResult();
        final email = user.email;
        final displayName = user.displayName;
        final photoURL = user.photoURL;
        final phoneNumber = user.phoneNumber;
        final emailVerified = user.emailVerified;
        final refreshToken2 = user.refreshToken;

        AppLog.log().i("FirebaseAuthService user id: ${user.uid}");
        // StorageService.storeAccess(idToken!, refreshToken2!, user.uid);

        print("idToken: $idToken");
        print("accessToken: $accessToken");
        print("refreshToken: $refreshToken");
        print("email: $email");
        print("displayName: $displayName");
        print("photoURL: $photoURL");
        print("phoneNumber: $phoneNumber");
        print("emailVerified: $emailVerified");
        print("refreshToken2: $refreshToken2");

        showToast(message: 'Error while signing in with google. Please try to sign in entering username and password', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");

        Map<String, dynamic> data = {
          'idToken': idToken,
          'email': email,
          'displayName': displayName,
          'photoURL': photoURL,
        };

        GoogleSignInData uD = GoogleSignInData.fromJson(data);

        return uD;

      } else {
        showToast(message: 'Error while signing in with google. Please try to sign in entering username and password', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
        return Future.error('Error while signing in with google');
      }

    } catch (e) {
      AppLog.log().e("error while signing in with google: $e");
      return Future.error('Error while signing in with google');
    }
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {

      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
      } else {
        showToast(message: 'An error occurred: ${e.code}', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
      }
    }
    return null;

  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
      } else {
        showToast(message: 'An error occurred: ${e.code}', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
      }

    }
    return null;

  }

}