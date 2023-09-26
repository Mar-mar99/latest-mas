// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../../../core/ui/invoice/invoice_screen.dart';
import '../../../domain/entities/requets_detail_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompanyInvoiceScreen extends StatelessWidget {
  static const routeName = 'company_invoice_screen';
  final RequestDetailEntity data;
  const CompanyInvoiceScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${AppLocalizations.of(context)?.invoiceLabel ?? ""} #${data.bookingId ?? ''}',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InvoiceScreen(
              bookingId: data.bookingId!,
              baseFare: data.payment!.fixed!,
              hourlyRate: data.payment!.hourlyRate!,
              consumedTime: data.totalServiceTime,
              discount: data.payment!.discount!,
              tax: data.payment!.tax!,
              amountToBePaid: data.payment!.total!,
              paymentMode: data.paymentMode,
              promocode: data.payment!.promocodeId!,
              isFree: data.serviceType!.paymentStatus! != 'paid',
              showMessage: true,
            )
          ],
        ),
      ),
    );
  }
}
