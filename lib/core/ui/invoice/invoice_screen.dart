// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/app_text.dart';
import 'invoice_item.dart';

class InvoiceScreen extends StatelessWidget {
  static const routeName = 'invoice_screen';
  final String bookingId;
  final dynamic baseFare;
  final dynamic hourlyRate;
  final dynamic consumedTime;
  final dynamic discount;
  final String? promocode;
  final dynamic tax;
  final dynamic amountToBePaid;
  final dynamic paymentMode;
  final bool isFree;
  final bool showMessage;
  const InvoiceScreen({
    Key? key,
    required this.bookingId,
    required this.baseFare,
    required this.hourlyRate,
    required this.consumedTime,
    required this.discount,
    this.promocode,
    required this.tax,
    required this.amountToBePaid,
    required this.paymentMode,
    required this.isFree,
    required this.showMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _buildBareFare(context),
                  _buildHourlyRate(context),
                  _buildConsumedTime(context),
                  _buildDiscount(context),
                  if (promocode != null &&promocode!='null') _buildPromo(context),
                  _buildTax(context),
                  _buildAmountToBePaid(context),
                 if(!isFree) _buildPaymentMode(context),
                  const SizedBox(
                    height: 20,
                  ),
                  if (showMessage) _buildMessage(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      title: Text(
          '${AppLocalizations.of(context)?.invoiceLabel ?? ""} #$bookingId'),
    );
  }

  AppText _buildMessage(BuildContext context) {
    return AppText(
      isFree
          ? AppLocalizations.of(context)!.serviceInvoiceMessageFree
          : AppLocalizations.of(context)!.serviceInvoiceMessage,
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Theme.of(context).primaryColor,
    );
  }

  InvoiceItem _buildPaymentMode(BuildContext context) {
    return InvoiceItem(
        title: AppLocalizations.of(context)?.paymentMode ?? "",
        subTitle: paymentMode ?? "",
        isLast: true);
  }

  InvoiceItem _buildAmountToBePaid(BuildContext context) {
    return InvoiceItem(
      title: AppLocalizations.of(context)?.amountToBePaid ?? "",
      subTitle:
          "${AppLocalizations.of(context)?.uadLabel ?? ""} ${amountToBePaid ?? ""}",
    );
  }

  InvoiceItem _buildTax(BuildContext context) {
    return InvoiceItem(
      title: AppLocalizations.of(context)?.taxLAbel ?? "",
      subTitle: "${AppLocalizations.of(context)?.uadLabel ?? ""} ${tax ?? ""}",
      colorSubTitle: Theme.of(context).primaryColor,
    );
  }

  Text _buildPromo(BuildContext context) {
    return Text(
      AppLocalizations.of(context)?.promoCodeAppliedLabel ?? "",
      style: TextStyle( color: Colors.red,),

      textAlign: TextAlign.right,
    );
  }

  InvoiceItem _buildDiscount(BuildContext context) {
    return InvoiceItem(
      title: AppLocalizations.of(context)?.discountLabel ?? "",
      subTitle:
          "${AppLocalizations.of(context)?.uadLabel ?? ""} ${discount ?? ""}",
    );
  }

  InvoiceItem _buildConsumedTime(BuildContext context) {
    return InvoiceItem(
      title: AppLocalizations.of(context)?.consumedTimeLabel ?? "",
      subTitle: consumedTime ?? '',
      colorSubTitle: Theme.of(context).primaryColor,
    );
  }

  InvoiceItem _buildHourlyRate(BuildContext context) {
    return InvoiceItem(
      title: AppLocalizations.of(context)?.hourlyRateBasicLabel ?? "",
      subTitle:
          '${AppLocalizations.of(context)?.uadLabel ?? ""} ${hourlyRate ?? ""}',
      colorSubTitle: Theme.of(context).primaryColor,
    );
  }

  InvoiceItem _buildBareFare(BuildContext context) {
    return InvoiceItem(
      title: AppLocalizations.of(context)!.baseFare,
      subTitle:
          "${baseFare ?? ""}",
    );
  }
}
