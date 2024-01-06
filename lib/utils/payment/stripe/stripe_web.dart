import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:socialmediaapp/utils/env.dart';


class StripeInterface {
  StripeInterface._();

  static Future<void> initStripe() async {
    WebStripe.instance.initialise(publishableKey: Environments.stripePublishableKey);
  }
  
  
  static Future<void> initPaymentSheet(jsonResponse) async {
    await WebStripe.instance.initPaymentSheet(
      SetupPaymentSheetParameters(
        paymentIntentClientSecret: jsonResponse['paymentIntent'],
        merchantDisplayName: 'Social Media App',
        customerId: jsonResponse['customer'],
        customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
      )
    );
    await WebStripe.instance.presentPaymentSheet();
  }

  
}