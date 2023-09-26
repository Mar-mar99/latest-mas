// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:masbar/features/provider/service_records/presentation/screens/provider_invoice_screen.dart';

import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../core/ui/widgets/detail_request_item.dart';
import '../../../../../core/ui/widgets/gallery.dart';
import '../../../../../core/ui/widgets/profile/mini_avatar.dart';
import '../../../../../core/ui/widgets/small_button.dart';
import '../../data/data_source/service_record_provider_data_source.dart';
import '../../data/repositories/service_record_provider_repo_impl.dart';
import '../../domain/entities/request_past_provider_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/use_cases/rate_provider_use_case.dart';
import '../bloc/rate_provider_bloc.dart';
import '../widgets/provider_rating_widget.dart';

class PastRequestDetailsProviderScreen extends StatelessWidget {
  static const routeName = 'past_request_details_provider_screen';

  final RequestPastProviderEntity past;
  const PastRequestDetailsProviderScreen({
    Key? key,
    required this.past,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getRateBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.details),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  if ((past.status!) == 'COMPLETED') ...[
                    _buildUserInfo(context),
                    const SizedBox(
                      height: 8,
                    )
                  ],
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(width: 0.2, color: Colors.grey)),
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                          left: 20,
                          right: 20,
                          bottom: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if ((past.status!) == 'COMPLETED')
                              _buildPrice(context),
                            if ((past.status!) == 'COMPLETED') ...[
                              const SizedBox(
                                height: 12,
                              ),
                              const Divider(),
                            ],
                            const SizedBox(
                              height: 10,
                            ),
                            _buildStatus(context),
                            _buildName(context),
                            if ((past.status!) == 'COMPLETED')
                              _buildPaymentMode(context),
                            if ((past.status!) == 'COMPLETED')
                              _buildServiceDate(context),
                            if ((past.status!) != 'COMPLETED')
                              _buildCancelledBy(context),
                            if ((past.status!) != 'COMPLETED')
                              _buildCancelReason(context),
                            if ((past.afterComment ?? '').isNotEmpty)
                              _buildAfterComment(context),
                            _buildServiceAddress(context),
                            const SizedBox(
                              height: 10,
                            ),
                            if (past.images!.isNotEmpty)
                              _buildViewImageBefore(context),
                            const SizedBox(
                              height: 10,
                            ),
                            if (past.imagesAfter!.isNotEmpty)
                              _buildImageAfter(context),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                ],
              ),
            ),
          ),
          bottomSheet: (past.status!) != 'COMPLETED'
              ? Container(
                  height: 0,
                )
              : Container(
                  height: 80,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppButton(
                      onTap: () {
                        Navigator.pushNamed(
                            context, ProviderInvoiceScreen.routeName,
                            arguments: {
                              'data': past,
                            });
                      },
                      title:
                          AppLocalizations.of(context)?.viewInvoiceLabel ?? '',
                    ),
                  ),
                ),
        );
      }),
    );
  }

  DetailRequestItem _buildServiceAddress(BuildContext context) {
    return DetailRequestItem(
        title: AppLocalizations.of(context)?.serviceLocation ?? '',
        subTitle: past.s_address ?? '',
        isLast: true);
  }

  DetailRequestItem _buildAfterComment(BuildContext context) {
    return DetailRequestItem(
      title:
          AppLocalizations.of(context)?.commentProvider ?? "Comment Provider",
      subTitle: past.afterComment ?? '',
    );
  }

  RateProviderBloc _getRateBloc() {
    return RateProviderBloc(
      rateProviderUseCase: RateProviderUseCase(
        serviceRecordProviderRepo: ServiceRecordProviderRepoImpl(
          serviceRecordeProviderDataSource:
              ServiceRecordeProviderDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(width: 0.2, color: Colors.grey)),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(children: [
              MiniAvatar(
                url: past.user!.picture ?? '',
                name: past.user!.firstName ?? '',
                disableProfileView: true,
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    '${past.user!.firstName ?? ''} ${past.user!.lastName ?? ''}',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ],
              ),
              const Spacer(),
              ProviderRatingWidget(rating: past.rating, id: past.id),
            ]),
          ],
        ),
      ),
    );
  }

  Row _buildPrice(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          AppLocalizations.of(context)?.priceLabel ?? '',
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        const Spacer(),
        AppText(
          '${past.payment?.total ?? ''}AED',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  DetailRequestItem _buildStatus(BuildContext context) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.statusLabel ?? '',
      subTitle: past.status ?? '',
    );
  }

  DetailRequestItem _buildName(BuildContext context) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.typeOfService ?? '',
      subTitle: past.serviceType?.name ?? '',
    );
  }

  DetailRequestItem _buildPaymentMode(BuildContext context) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.paymentMethod ?? '',
      subTitle: past.paymentMode ?? '',
    );
  }

  DetailRequestItem _buildServiceDate(BuildContext context) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.serviceDate ?? '',
      subTitle: past.startedAt ?? '',
    );
  }

  DetailRequestItem _buildCancelReason(BuildContext context) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.cancelReason ?? '',
      subTitle: past.cancelReason ?? '',
    );
  }

  DetailRequestItem _buildCancelledBy(BuildContext context) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.cancelledByLabel ?? '',
      subTitle: past.cancelledBy ?? '',
    );
  }

  SmallButton _buildImageAfter(BuildContext context) {
    return SmallButton(
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      textColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.pushNamed(context, Gallery.routeName, arguments: {
          'images': past.imagesAfter as List<String>,
        });
      },
      title: AppLocalizations.of(context)?.viewImageAfter ?? "",
    );
  }

  SmallButton _buildViewImageBefore(BuildContext context) {
    return SmallButton(
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      textColor: Theme.of(context).primaryColor,
       onTap: () {
        Navigator.pushNamed(context, Gallery.routeName, arguments: {
          'images': past.images as List<String>,
        });
      },
      title: AppLocalizations.of(context)?.viewImageBefore ?? "",
    );
  }
}
