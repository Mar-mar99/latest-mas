import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/ui/invoice/invoice_screen.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../domain/entities/history_request_user_entity.dart';
import '../widgets/invoice_item.dart';

class UserInvoiceScreen extends StatelessWidget {
  static const routeName = 'user_invoice_screen';
  final HistoryRequestUserEntity past;
  const UserInvoiceScreen({super.key, required this.past});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${AppLocalizations.of(context)?.invoiceLabel ?? ""} #${past.bookingId ?? ''}',
          ),
        ),
        body: InvoiceScreen(
          bookingId: past.bookingId!,
          baseFare: past.payment!.fixed!,
          hourlyRate: past.payment!.hourlyRate!,
          consumedTime: past.totalServiceTime,
          discount: past.payment!.discount!,
          tax: past.payment!.tax!,
          amountToBePaid: past.payment!.total!,
          paymentMode: past.payment_mode,
          promocode: past.payment!.promocodeId!,
          isFree: past.serviceType!.paymentStatus! != 'paid',
          showMessage: true,
        ));
  }
}
