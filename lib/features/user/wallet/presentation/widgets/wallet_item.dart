import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../domain/entities/wallet_entity.dart';

class WalletItem extends StatelessWidget {
  final WalletEntity walletEntity;
  const WalletItem({super.key, required this.walletEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).scaffoldBackgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildLabel(context, AppLocalizations.of(context)!.typeLabel),
              _buildValue(walletEntity.type!),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildLabel(context, AppLocalizations.of(context)!.amount),
              _buildValue(walletEntity.amount!),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildLabel(
                  context, AppLocalizations.of(context)!.descriptionLabel),
              _buildValue(walletEntity.description!),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildLabel(context, AppLocalizations.of(context)!.createdAt),
              _buildValue(
                AppLocalizations.of(context)!.custom_date_time(
                  DateTime.parse(
                    walletEntity.createdAt!,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValue(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      '$text: ',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
