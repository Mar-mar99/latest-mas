// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import '../../domain/entities/history_request_user_entity.dart';
import 'package:masbar/core/ui/widgets/profile/mini_avatar.dart';

import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../core/utils/helpers/helpers.dart';
import '../../domain/entities/history_request_user_entity.dart';
import '../../domain/entities/upcoming_request_user_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/past_request_details_screen.dart';

class PastServiceRecordCard extends StatelessWidget {
  final HistoryRequestUserEntity past;
  const PastServiceRecordCard({
    Key? key,
    required this.past,
  }) : super(key: key);

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
                      //show type name both
                      _buildServiceTypeName(),
                      const SizedBox(
                        height: 4,
                      ),

                      //past and completed
                      if (past.status == "COMPLETED") _buildFinishedAt(),
                    ],
                  ),
                  const Spacer(),

                  //show status for both
                  _showStatus(),
                ],
              ),
            ),

            //not cancelled and not seaching (both)
            if ((past.status!) != 'CANCELLED' &&
                (past.status!) != 'SEARCHING') ...[
              const Divider(),
              _buildProviderDetails(),
            ],
            const Divider(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if ((past.status!) == 'COMPLETED') _buildTotal(),
                  Spacer(),
                  _buildViewDetails(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppButton _buildViewDetails(BuildContext context) {
    return AppButton(
      onTap: () {
        Navigator.pushNamed(context, PastRequestDetailsScreen.routeName,arguments: {'past':past});
      },
      isSmall: true,
      buttonColor: ButtonColor.green,
      title: AppLocalizations.of(context)?.viewDetails ?? "",
    );
  }

  AppText _buildTotal() {
    return AppText(
      'AED ${past.payment?.total ?? ''}',
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
  }

  Padding _buildProviderDetails() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          MiniAvatar(
            url: Helpers.getImage(
              past.provider?.avatar ?? '',
            ),
            name: Helpers.getImage(
              past.provider?.name ?? '',
            ),
            disableProfileView: true,
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
               past.provider != null? past.provider?.name??'No provider spcified' : 'No provider spcified',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              const SizedBox(
                height: 4,
              ),
           if (  past.provider!=null && past.provider!.rating !=null)   Row(
                children: [
                  AppText(
                 past.provider!.rating!,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  const SizedBox(
                    width: 4,
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
    );
  }

  Row _showStatus() {
    return Row(
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: (past.status!) == 'CANCELLED' ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        AppText(
          past.status!,
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

  AppText _buildServiceTypeName() {
    return AppText(
      past.serviceType!.name!,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
  }
}
