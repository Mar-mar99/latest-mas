// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/ui/dialogs/cancel_reason_dialog.dart';
import '../../../services/presentation/service_details.dart/bloc/cancel_user_request_bloc.dart';
import '../../../services/presentation/service_details.dart/screen/service_details_screen.dart';
import '../../domain/entities/upcoming_request_user_entity.dart';
import 'package:masbar/core/ui/widgets/profile/mini_avatar.dart';

import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../core/utils/helpers/helpers.dart';
import '../../domain/entities/history_request_user_entity.dart';
import '../../domain/entities/upcoming_request_user_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpcomingServiceRecordCard extends StatelessWidget {
  final UpcomingRequestUserEntity upcoming;
  UpcomingServiceRecordCard({
    Key? key,
    required this.upcoming,
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

                      //not past show(schedule at)

                      _buildScheduleAt(),
                    ],
                  ),
                  const Spacer(),

                  //show status for both
                  _buildStatus(),
                ],
              ),
            ),

            //not cancelled and not seaching (both)
            if ((upcoming.status ?? '') != 'CANCELLED' &&
                (upcoming.status ?? '') != 'SEARCHING') ...[
              const Divider(),
              _buildProviderInfo(),
            ],
            const Divider(),

            //total -- view details
            //past

            //upcoming and not cancelled
            if (upcoming.status != 'CANCELLED')
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailsBtn(context),
                    _buildCancelBtn(context),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  AppButton _buildCancelBtn(BuildContext context) {
    return AppButton(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return _buildDialog(context);
          },
        );
      },
      isSmall: true,
      buttonColor: ButtonColor.green,
      title: AppLocalizations.of(context)?.cancel ?? "",
    );
  }

  Widget _buildDialog(BuildContext context) {
    return CancelReasonDialog(
      handler: (value) {
        BlocProvider.of<CancelUserRequestBloc>(context).add(
          CancelUserRequest(
            id: upcoming.id,
            reason: value
          ),
        );
      },
    );
  }

  AppButton _buildDetailsBtn(BuildContext context) {
    return AppButton(
      onTap: () {
         Navigator.pushNamed(context, ServiceDetailsScreen.routeName,
                    arguments: {
                      "id": upcoming.id,
                    });
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ServicesDetailsPage(
        //       serviceId:
        //       widget.upcoming!.id!,
        //     ),
        //   ),
        // );
      },
      isSmall: true,
      buttonColor: ButtonColor.transparentBorderPrimary,
      title: AppLocalizations.of(context)?.viewDetails ?? "",
    );
  }

  Padding _buildProviderInfo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          MiniAvatar(
            url: Helpers.getImage(
              upcoming.provider?.avatar ?? '',
            ),
            name: Helpers.getImage(
              upcoming.provider?.name ?? '',
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
                upcoming.provider?.name ?? '',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  AppText(
                    upcoming.provider?.rating ?? '',
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

  Row _buildStatus() {
    return Row(
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: (upcoming.status ?? '') == 'CANCELLED'
                ? Colors.red
                : Colors.green,
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        AppText(
          upcoming.status ?? '',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        )
      ],
    );
  }

  AppText _buildScheduleAt() {
    return AppText(
      upcoming.scheduleAt.toString(),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
  }

  AppText _buildServiceTypeName() {
    return AppText(
      upcoming.serviceType?.name ?? '',
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
  }
}
