import 'package:flutter/material.dart';
import 'package:masbar/core/ui/widgets/app_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/features/user/promo_code/domain/entities/promo_code_entity.dart';

class PromoCodeItem extends StatelessWidget {
  final PromoCodeEntity promoCodeEntity;
  const PromoCodeItem({required this.promoCodeEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).scaffoldBackgroundColor),
      child: Row(
        children: [
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                '${AppLocalizations.of(context)?.promoCodeLabel ?? ""} : ${promoCodeEntity.promocode!.promoCode!}',
                fontSize: 12,
              ),
              const SizedBox(
                height: 5,
              ),
              AppText(
                '${AppLocalizations.of(context)!.statusLabel} : ${promoCodeEntity.promocode!.status!}',
                fontSize: 12,
              ),
              const SizedBox(
                height: 5,
              ),
              AppText(
                '${AppLocalizations.of(context)!.expirationLabel} : ${promoCodeEntity.promocode!.expiration!}',
                fontSize: 12,
              ),
            ],
          )),
        ],
      ),
    );
  }
}
