// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/features/company/manage_providers/domain/entities/provider_entity.dart';

import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import '../widgets/pending_provider_card.dart';

class PendingProviders extends StatelessWidget {
  final List<ProviderEntity> providers;
  const PendingProviders({
    Key? key,
    required this.providers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            if (providers.isNotEmpty)
              ...providers.map((e) => PendingProviderCard(
                    provider: e,
                  )),
            if (providers.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: AppText(
                  AppLocalizations.of(context)?.noPendingProviders ?? "",
                ),
              ),
              const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
