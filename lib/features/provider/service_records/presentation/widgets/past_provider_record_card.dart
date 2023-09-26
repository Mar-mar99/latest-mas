import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/profile/mini_avatar.dart';
import '../../domain/entities/request_past_provider_entity.dart';
import '../screens/past_request_details_provider_screen.dart';

class PastProviderRecordCard extends StatelessWidget {
  final RequestPastProviderEntity past;
  const PastProviderRecordCard({super.key, required this.past});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(
            width: 0.2,
            color: Colors.grey,
          ),
        ),
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildName(),
                      const SizedBox(
                        height: 4,
                      ),
                      if (past.status == "COMPLETED") _buildFinishedAt(),
                    ],
                  ),
                  const Spacer(),
                  _buildStatus(),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _buildAvatar(),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        ('${past.user!.firstName ?? ''} ${past.user!.lastName ?? ''}'),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          AppText(
                            past.user!.rating ?? '',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 15,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if ((past.status!) == 'COMPLETED')
                    Column(
                      children: [
                        if ((past.paymentMode ?? '') != 'FREE')
                          AppText(
                            '${AppLocalizations.of(context)?.uadLabel ?? ""} ${past.payment?.total ?? ''}',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                      ],
                    ),
                  Spacer(),
                  AppButton(
                    onTap: () {
                      Navigator.pushNamed(
                          context, PastRequestDetailsProviderScreen.routeName,
                          arguments: {
                            'data': past,
                          });
                    },
                    isSmall: true,
                    buttonColor: ButtonColor.green,
                    title: AppLocalizations.of(context)?.viewDetails ?? "",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  MiniAvatar _buildAvatar() {
    return MiniAvatar(
      url: past.user!.picture ?? '',
      name: past.user!.firstName ?? '',
      disableProfileView: true,
    );
  }

  Row _buildStatus() {
    return Row(
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
              color: (past.status! ?? '') == 'CANCELLED'
                  ? Colors.red
                  : Colors.green,
              borderRadius: BorderRadius.circular(12)),
        ),
        const SizedBox(
          width: 8,
        ),
        AppText(
          past.status! ?? '',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        )
      ],
    );
  }

  AppText _buildFinishedAt() {
    return AppText(
      past.finishedAt.toString(),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
  }

  AppText _buildName() {
    return AppText(
      past.serviceType?.name ?? '',
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
  }
}
