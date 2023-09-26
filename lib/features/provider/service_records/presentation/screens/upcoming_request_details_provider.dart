// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/detail_request_item.dart';
import '../../../../../core/ui/widgets/profile/mini_avatar.dart';
import '../../domain/entities/request_upcoming_provider_entity.dart';

class UpcomingRequestDetailsProviderScreen extends StatelessWidget {
  static const routeName = 'upcoming_request_details_provider_screen';
  final RequestUpcomingProviderEntity upcoming;
  const UpcomingRequestDetailsProviderScreen({
    Key? key,
    required this.upcoming,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.details)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  border: Border.all(
                    width: 0.2,
                    color: Colors.grey,
                  ),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          MiniAvatar(
                            url: upcoming.user!.picture ?? '',
                            name: upcoming.user!.firstName ?? '',
                            disableProfileView: true,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                '${upcoming.user!.firstName ?? ''} ${upcoming.user!.lastName ?? ''}',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    border: Border.all(width: 0.2, color: Colors.grey)),
                width: double.infinity,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, left: 20, right: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        DetailRequestItem(
                          title:
                              AppLocalizations.of(context)?.statusLabel ?? '',
                          subTitle: upcoming.status ?? '',
                        ),
                        DetailRequestItem(
                          title:
                              AppLocalizations.of(context)?.typeOfService ?? '',
                          subTitle: upcoming.serviceType?.name ?? '',
                        ),
                        DetailRequestItem(
                          title:
                              AppLocalizations.of(context)?.serviceDate ?? '',
                          subTitle: upcoming.scheduleAt ?? '',
                        ),
                        DetailRequestItem(
                          title:
                              AppLocalizations.of(context)?.paymentMode ?? '',
                          subTitle: upcoming.paymentMode ?? '',
                        ),
                        DetailRequestItem(
                            title:
                                AppLocalizations.of(context)?.serviceLocation ??
                                    '',
                            subTitle: upcoming.sAddress ?? '',
                            isLast: true),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
