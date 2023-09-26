

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../../core/utils/enums/enums.dart';
import '../../bloc/request_offer_bloc.dart';

class SelectPaymentMethodOffer extends StatefulWidget {
  const SelectPaymentMethodOffer({super.key});

  @override
  State<SelectPaymentMethodOffer> createState() => _SelectPaymentMethodOfferState();
}

class _SelectPaymentMethodOfferState extends State<SelectPaymentMethodOffer> {
  PaymentMethod? selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  AppLocalizations.of(context)?.selectPaymentMethod ?? "",
                  fontSize: 16,
                  color: const Color(0xff343135),
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ...PaymentMethod.values.map((e) => _buildItem(e, context)).toList(),
            const SizedBox(
              height: 20,
            ),
            AppButton(
              title: AppLocalizations.of(context)!.select,
              isDisabled: selected == null,
              onTap: () {
                BlocProvider.of<RequestOfferBloc>(context).add(
                  PaymentTypeChangedEvent(
                    paymentMethod: selected!,
                  ),
                );
                Navigator.pop(context);
              },
              buttonColor: ButtonColor.primary,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItem(PaymentMethod e, BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          selected = e;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: selected == e
                  ? Theme.of(context).primaryColor
                  : Colors.transparent),
          borderRadius: BorderRadius.circular(
            4,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _getText(context, e),
              if (selected == e)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                )
            ],
          ),
        ),
      ),
    );
  }

  AppText _getText(BuildContext context, PaymentMethod type) {
    switch (type) {
      case PaymentMethod.cash:
        return AppText(AppLocalizations.of(context)!.cashLabel);
      case PaymentMethod.wallet:
        return AppText(AppLocalizations.of(context)!.walletLabel);
    }
  }
}
