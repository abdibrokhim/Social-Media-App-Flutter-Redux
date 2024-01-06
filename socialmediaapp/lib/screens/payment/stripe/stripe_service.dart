import 'dart:io';

import 'package:socialmediaapp/components/shared/toast.dart';
import 'package:socialmediaapp/screens/mainlayout/components/notification_reducer.dart';
import 'package:socialmediaapp/screens/post/components/likes_model.dart';
import 'package:socialmediaapp/screens/user/user_model.dart';
import 'package:socialmediaapp/screens/user/user_service.dart';
import 'package:socialmediaapp/utils/constants.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socialmediaapp/utils/env.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:socialmediaapp/utils/payment/stripe/stripe_platform.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeService {

  static Future<List<UserSubscription>> subscription(String email) async {
    try {
      final response = await http.post(
        Uri.parse(Environments.firebaseStripeFunctionUrl),
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: jsonEncode({'email': email, 'amount': subscriptionPrice.toString()}),
      );

      final jsonResponse = jsonDecode(response.body);
      print('jsonResponse: $jsonResponse');

      if (!kIsWeb) {
        print('processing request on io');
        await StripeInterface.initPaymentSheet(jsonResponse);
      } else {
        print('processing request on web');
        await StripeInterface.initPaymentSheet(jsonResponse);
      }
      showToast(message: "You are subscribed.", bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
      List<UserSubscription> userSubscription = await UserService.subscribeUser();
      AppLog.log().i('User subscription: $userSubscription');
      return userSubscription;
    } on HttpException catch (e) {
      print('HTTP Exception: ${e.message}');
      showToast(message: "An error has occured.", bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
      return Future.error('An error has occured on StripeException.');
    } catch (e) {
      if (e is StripeException) {
        showToast(message: "An error has occured.", bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
        AppLog.log().e("error while subscribing on StripeException: $e");
        return Future.error('An error has occured on StripeException.');
      } else {
        showToast(message: "An error has occured.", bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
        AppLog.log().e("error while subscribing: $e");
        return Future.error('An error has occured.');
      }
    }
  }


  static Future<List<UserSubscription>> subscriptionWeb() async {
    try {
      print('processing request on web');
      print('starting checkout');
      // await _startCheckout();
      // print('checkout completed');

      showToast(message: "You are subscribed.", bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
      List<UserSubscription> userSubscription = await UserService.subscribeUser();
      AppLog.log().i('User subscription: $userSubscription');
      return userSubscription;
    } on HttpException catch (e) {
      print('HTTP Exception: ${e.message}');
      showToast(message: "An error has occured.", bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
      return Future.error('An error has occured on StripeException.');
    } catch (e) {
      if (e is StripeException) {
        showToast(message: "An error has occured.", bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
        AppLog.log().e("error while subscribing on StripeException: $e");
        return Future.error('An error has occured on StripeException.');
      } else {
        showToast(message: "An error has occured.", bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
        AppLog.log().e("error while subscribing: $e");
        return Future.error('An error has occured.');
      }
    }
  }

  static Future<void> _startCheckout() async {
    await _launchURL('http://127.0.0.1:4242');
  }


  static Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppLog.log().i('Could not launch $url');
    }
  }

  static Future<void> checkPaymentStatus() async {
    while (true) {
      final statusResponse = await http.get(
        Uri.parse('https://us-central1-socialmedia-flutter-app.cloudfunctions.net/stripePaymentIntentRequest')
      );

      final status = jsonDecode(statusResponse.body)['status'];

      if (status == 'success') {
        print('Success');
        break;
      } else if (status == 'failed') {
        print('Failed');
        break;
      }

      await Future.delayed(Duration(seconds: 5));
    }
  }



}