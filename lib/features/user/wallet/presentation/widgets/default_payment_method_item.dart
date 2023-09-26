import 'package:flutter/material.dart';
import 'package:masbar/features/user/payment_methods/domain/entities/payment_method_entity.dart';

import '../../../../../core/ui/widgets/app_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/utils/helpers/credit_card_icon.dart';

class DefaultPaymentMethodItem extends StatelessWidget {
  final PaymentsMethodEntity defaultPayment;
  const DefaultPaymentMethodItem({required this.defaultPayment});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            5.0,
          ),
        ),
        border: Border.all(
          color: Colors.grey,
          width: 0.4,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            _buildCardIcon(defaultPayment),
            const SizedBox(width: 12.0),
            _buildNumberStars(),
            _buildLastFour(defaultPayment),
          ]),
          const SizedBox(
            height: 16,
          ),
          _buildDefaultText(context)
        ],
      ),
    );
  }

  AppText _buildDefaultText(BuildContext context) {
    return AppText(
      AppLocalizations.of(context)?.defaultCard ?? "",
    );
  }

  AppText _buildLastFour(PaymentsMethodEntity payment) {
    return AppText(
      '${payment.lastFour}',
      type: TextType.bold,
    );
  }

  AppText _buildNumberStars() {
    return const AppText(
      "  **** ",
      type: TextType.bold,
    );
  }

  SizedBox _buildCardIcon(PaymentsMethodEntity payment) {
    return SizedBox(
      width: 30.0,
      child: AspectRatio(
        aspectRatio: 1.618,
        child: Container(
          width: 32,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            image: DecorationImage(
                image: AssetImage(
                  getBrandIcon(
                    card: payment,
                  ),
                ),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(
              2.0,
            ),
          ),
        ),
      ),
    );
  }
}
