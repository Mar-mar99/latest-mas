// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/ui/invoice/invoice_screen.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../domain/entities/request_past_provider_entity.dart';

class ProviderInvoiceScreen extends StatelessWidget {
  static const routeName = 'provider_invoice_screen';
  final RequestPastProviderEntity past;
  const ProviderInvoiceScreen({
    Key? key,
    required this.past,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${AppLocalizations.of(context)?.invoice ?? ''}${past.bookingId ?? ''}'),
      ),
      body: InvoiceScreen(
        bookingId: past.bookingId!,
        baseFare: past.payment!.fixed,
        hourlyRate: past.payment!.hourlyRate,
        consumedTime: past.totalServiceTime,
        discount: past.payment!.discount,
        tax: past.payment!.tax,
        amountToBePaid: past.payment!.total,
        paymentMode: past.paymentMode,
        promocode: past.payment!.promocodeId,
        isFree: past.serviceType!.paymentStatus != 'paid',
        showMessage: false,
      ),
    );
  }
}
