// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:masbar/core/api_service/network_service_http.dart';

import '../../../../../core/ui/invoice/invoice_screen.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../core/ui/widgets/detail_request_item.dart';
import '../../../../../core/ui/widgets/gallery.dart';
import '../../../../../core/ui/widgets/profile/mini_avatar.dart';
import '../../../../../core/ui/widgets/small_button.dart';
import '../../data/data_source/user_service_record_data_source.dart';
import '../../data/repositories/user_service_record_repo_impl.dart';
import '../../domain/entities/history_request_user_entity.dart';
import '../../domain/use_cases/rate_request_use_case.dart';
import '../bloc/rate_request_bloc.dart';

import '../widgets/user_rating_widget.dart';
import 'user_invoice_screen.dart';

class PastRequestDetailsScreen extends StatelessWidget {
  static const routeName = 'past_request_details_screen';
  final HistoryRequestUserEntity past;
  PastRequestDetailsScreen({
    Key? key,
    required this.past,
  }) : super(key: key);
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _buildRateBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.details),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if ((past.status!) == 'COMPLETED') ...[
                    _buildProviderDetails(context),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                  _buildCardDetails(context)
                ],
              ),
            ),
          ),
          bottomSheet: (past.status!) != 'COMPLETED'
              ? null
              : _buildViewInvoiceBtn(context),
        );
      }),
    );
  }

  RateRequestBloc _buildRateBloc() {
    return RateRequestBloc(
      rateRequestUseCase: RateRequestUseCase(
        userServiceRecordRepo: UserServiceRecordRepoImpl(
          userServiceRecordsSource: UserServiceRecordeDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  Widget _buildCardDetails(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if ((past.status!) == 'COMPLETED') ...[
              _buildTotal(context),
              const SizedBox(
                height: 12,
              ),
              const Divider(),
            ],
            const SizedBox(
              height: 10,
            ),
            _buildStatus(context),
            _buildServiceTypeName(context),
            if ((past.status!) == 'COMPLETED') _buildPaymentMethod(context),
            if ((past.status!) == 'COMPLETED') _buildServiceDate(context),
            if ((past.status!) != 'COMPLETED') _buildCancelBy(context),
            if ((past.status!) != 'COMPLETED') _buildCancelReason(context),
            if ((past.afterComment ?? '').isNotEmpty)
             _buildCommentProvider(context),
            _buildServiceLocation(context),
            const SizedBox(
              height: 10,
            ),
            if (past.images!.isNotEmpty) _buildImagesBefore(context),
            const SizedBox(
              height: 10,
            ),
            if (past.imagesAfter!.isNotEmpty) _buildImagesAfter(context),
            const SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }

  SmallButton _buildImagesAfter(BuildContext context) {
    return SmallButton(
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      textColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.pushNamed(context, Gallery.routeName,
            arguments: {'images': past.imagesAfter});
      },
      title: AppLocalizations.of(context)?.viewImageAfter ?? "",
    );
  }

  SmallButton _buildImagesBefore(BuildContext context) {
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

  DetailRequestItem _buildStatus(BuildContext context) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.statusLabel ?? "",
      subTitle: past.status ?? '',
    );
  }

  DetailRequestItem _buildServiceTypeName(BuildContext context) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.typeOfService ?? "",
      subTitle: past.serviceType?.name ?? '',
    );
  }

  DetailRequestItem _buildPaymentMethod(BuildContext context) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.paymentMethod ?? "",
      subTitle: past.payment_mode ?? '',
    );
  }

  DetailRequestItem _buildServiceDate(BuildContext context) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.serviceDate ?? "",
      subTitle: past.startedAt ?? '',
    );
  }

  DetailRequestItem _buildCancelBy(BuildContext context) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.cancelledByLabel ?? "",
      subTitle: past.cancelledBy ?? '',
    );
  }

  DetailRequestItem _buildCancelReason(BuildContext context) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.cancelReason ?? "",
      subTitle: past.cancelReason ?? '',
    );
  }

  DetailRequestItem _buildCommentProvider(BuildContext context) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)!.commentProvider,
      subTitle: past.afterComment ?? '',
    );
  }

  DetailRequestItem _buildServiceLocation(BuildContext context) {
    return DetailRequestItem(
        title: AppLocalizations.of(context)?.serviceLocation ?? "",
        subTitle: past.s_address ?? '',
        isLast: true);
  }

  Row _buildTotal(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          AppLocalizations.of(context)?.priceLabel ?? "",
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        const Spacer(),
        AppText(
          '${past.payment?.total ?? ''} ${AppLocalizations.of(context)?.uadLabel ?? ""}',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  Container _buildProviderDetails(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                MiniAvatar(
                  url: past.provider!.avatar ?? '',
                  name: past.provider!.name ?? '',
                  disableProfileView: true,
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      past.provider!.name ?? '',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ],
                ),
                const Spacer(),

              UserRatingWidget(rating: past.rating,id: past.id ,)
              ],
            ),
          ],
        ),
      ),
    );
  }


Widget _buildViewInvoiceBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppButton(
          onTap: () {
          //    Navigator.push(context, MaterialPageRoute(
          //   builder: (context) {
          //     return InvoiceScreen(
          //       bookingId: past.bookingId!,
          //       baseFare: past.payment!.fixed!,
          //       hourlyRate:past.payment!. hourlyRate!,
          //       consumedTime: past.totalServiceTime,
          //       discount:past.payment!. discount!,
          //       tax: past.payment!.tax!,
          //       amountToBePaid:past.payment!. total!,
          //       paymentMode:past. payment_mode,
          //       promocode: past.payment!.promocodeId!,
          //       isFree: past.serviceType!.paymentStatus! !='paid',
          //       showMessage: true,
          //     );
          //   },
          // ));
            Navigator.pushNamed(
              context,
              UserInvoiceScreen.routeName,
              arguments: {
                'past': past,
              },
            );
          },
          title: AppLocalizations.of(context)!.view_invoice),
    );
  }
}
