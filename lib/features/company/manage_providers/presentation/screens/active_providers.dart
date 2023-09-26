// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:masbar/features/company/manage_providers/domain/entities/provider_entity.dart';
import 'package:masbar/features/company/manage_providers/presentation/screens/search_active_providers_screen.dart';

import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import '../../domain/entities/provider_info_entity.dart';
import '../bloc/enable_disable_bloc.dart';
import '../widgets/active_provider_card.dart';

class ActiveProviders extends StatelessWidget {
  final ProviderInfoEntity providersInfo;
  const ActiveProviders({
    Key? key,
    required this.providersInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchField(context),
            const SizedBox(
              height: 16,
            ),
            if (providersInfo.providers!.isNotEmpty)
              ...providersInfo.providers!.map(
                (e) => Column(
                  children: [
                    ActiveProviderCard(
                      provider: e,
                    ),
                    const Divider(
                      height: 8,
                    )
                  ],
                ),
              ),
            if (providersInfo.providers!.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: AppText(
                  AppLocalizations.of(context)?.noUsersProviders ?? "",
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

  AppTextField _buildSearchField(BuildContext context) {
    return AppTextField(
            controller: TextEditingController(),
            suffixIcon: Icons.search_rounded,
            hintText: AppLocalizations.of(context)?.findTheProviders ?? "",
            readOnly: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: context.read<EnableDisableBloc>(),
                      ),
                    ],
                    child: SearchActiveProvidersScreen(),
                  ),
                ),
              );
            },
          );
  }
}
