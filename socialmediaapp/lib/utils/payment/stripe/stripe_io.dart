import 'package:socialmediaapp/utils/env.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
  
  
class StripeInterface {
  StripeInterface._();

  static Future<void> initStripe() async {
    Stripe.publishableKey = Environments.stripePublishableKey;
    Stripe.instance.applySettings();
  }

  static Future<void> initPaymentSheet(jsonResponse) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: jsonResponse['paymentIntent'],
        merchantDisplayName: 'WeShot',
        customerId: jsonResponse['customer'],
        customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
      )
    );
    await Stripe.instance.presentPaymentSheet();
  }
}