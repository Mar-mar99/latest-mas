// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/utils/helpers/credit_card_icon.dart';
import '../../domain/entities/payment_method_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/delete_card_bloc.dart';
import '../bloc/get_payments_bloc.dart';
import '../bloc/set_default_bloc.dart';
import '../dialogs/delete_card_dialog.dart';

class PaymentCardItem extends StatelessWidget {
  final PaymentsMethodEntity card;
  const PaymentCardItem({
    Key? key,
    required this.card,
  }) : super(key: key);

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: [
                _buildCardIcon(),
                const SizedBox(width: 12.0),
                _buildNumberStars(),
                _buildLastFour(),
              ]),
              _buildDeleteIcon(context),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (card.isDefault == 1)
                _buildDefaultText(context)
              else
                _buildSetDefaultBtn(context),
              // InkWell(
              //   onTap: () async {
              // setState(() {
              //   isLoadingChangePayment = true;
              // });
              // await payments.setDefaultPaymentMethod(
              //     cardId: widget.card.id!);
              // setState(() {
              //   isLoadingChangePayment = false;
              // });
              // DialogPayment.dialogSuccess(context,
              //     AppLocalizations.of(context)?.cardMainPaymentMethodMessage ?? "", false);
              //   },
              //   child: AppText(
              //     AppLocalizations.of(context)?.setDefaultPaymentMethod ??
              //         "",
              //     type: TextType.regular,
              //     color: Colors.green,
              //   ),
              // ),
              // if (isLoadingChangePayment)
              //   const Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 20),
              //     child: CircularProgressIndicator(),
              //   ),
              // const Spacer(),
              // if(widget.change)
              //   InkWell(
              //       onTap: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => const PaymentMethods(),
              //                 settings: const RouteSettings(name: 'PaymentMethods')));
              //       },
              //       child: AppText(
              //         AppLocalizations.of(context)?.change ?? "",
              //         type: TextType.regular,
              //         color: Theme.of(context).primaryColor,
              //         bold: true,
              //       )),
              // if(!widget.change)
              // InkWell(
              //     onTap: () {
              // DialogPayment.dialogDeletePayment(context, widget.card);
              //     },
              //     child: AppText(
              //       AppLocalizations.of(context)?.delete ?? "",
              //       type: TextType.regular,
              //       color: Theme.of(context).primaryColor,
              //     )),
            ],
          ),
        ],
      ),
    );
  }

  OutlinedButton _buildSetDefaultBtn(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
         BlocProvider.of<SetDefaultBloc>(context)
            .add(SetDefaultCardEvent(id: card.id!));
      },
      child: AppText(AppLocalizations.of(context)!.setDefaultPaymentMethod),
    );
  }

  AppText _buildDefaultText(BuildContext context) {
    return AppText(
      AppLocalizations.of(context)?.defaultCard ?? "",
    );
  }

  IconButton _buildDeleteIcon(BuildContext context) {
    return IconButton(
      onPressed: () {
        dialogDeletePayment(context, () {
          BlocProvider.of<DeleteCardBloc>(context)
              .add(DeleteEvent(id: card.cardId??''));
        });
      },
      icon: const Icon(Icons.delete, color: Colors.red),
    );
  }

  AppText _buildLastFour() {
    return AppText(
      '${card.lastFour}',
      type: TextType.bold,
    );
  }

  AppText _buildNumberStars() {
    return const AppText(
      "  **** ",
      type: TextType.bold,
    );
  }

  SizedBox _buildCardIcon() {
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
                    card: card,
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
