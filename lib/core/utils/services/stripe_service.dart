
import '../../constants/api_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stripe_api_2/stripe_api.dart';


class StripeService {
  static getStripeToken(StripeCard card) async {
    Stripe.init(dotenv.env['stripeKey']!);
    Stripe? instanceStripe = Stripe.instance;
    final data = await instanceStripe?.createCardToken(card);
    return data!.id;
  }
}
