// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/ui/dialogs/loading_dialog.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/dialogs/rating_dialog.dart';
import '../../../../../../core/ui/invoice/invoice_screen.dart';
import '../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../core/ui/widgets/app_dialog.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/custom_map.dart';
import '../../../../../../core/utils/helpers/toast_utils.dart';
import '../../../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../../../../../navigation/screens/provider_screen.dart';
import '../../../../service_records/data/data_source/service_record_provider_data_source.dart';
import '../../../../service_records/data/repositories/service_record_provider_repo_impl.dart';
import '../../../../service_records/domain/use_cases/rate_provider_use_case.dart';
import '../../../../service_records/presentation/bloc/rate_provider_bloc.dart';
import '../../../data/date_source/provider_data_source.dart';
import '../../../data/repositories/provider_repo_impl.dart';
import '../../../domain/entities/invoice_entity.dart';
import '../../../domain/use_cases/recieve_cash_use_case.dart';
import '../../working_state/screens/homepage_provider_screen.dart';
import '../bloc/cash_paid_bloc.dart';

class ProviderInvoiceRequestScreen extends StatelessWidget {
  static const routeName = 'provider_invoice_request_screen';
  final int id;
  final InvoiceEntity invoiceEntity;
  final double? lat;
  final double? lng;
  const ProviderInvoiceRequestScreen({
    Key? key,
    required this.invoiceEntity,
    required this.lat,
    required this.lng,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getCashPaidBloc(),
        ),
        BlocProvider(
          create: (context) => _getRateBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return MultiBlocListener(
          listeners: [
            BlocListener<CashPaidBloc, CashPaidState>(
              listener: (context, state) {
                _buildMarkAsPaidListener(state, context);
              },
            ),
            BlocListener<RateProviderBloc, RateProviderState>(
              listener: (context, state) {
                _buildRateListener(state, context);
              },
            ),
          ],
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                '${AppLocalizations.of(context)?.invoiceLabel ?? ""} #${invoiceEntity.bookingId}',
              ),
            ),
            body: InvoiceScreen(
              bookingId: invoiceEntity.bookingId!,
              baseFare: (invoiceEntity.basicPrice) ,
              hourlyRate: (invoiceEntity.hourlyPrice as String).replaceFirst(RegExp('AED'), ''),
              consumedTime: invoiceEntity.time,
              discount: (invoiceEntity.discount!  ).replaceFirst(RegExp('AED'), ''),
              tax: (invoiceEntity.tax!   ).replaceFirst(RegExp('AED'), ''),
              amountToBePaid: (invoiceEntity.total as String).replaceFirst(RegExp('AED'), ''),
              paymentMode: invoiceEntity.paymentMode,
              promocode: null,
              isFree: invoiceEntity.isFreeService!,
              showMessage: false,
            ),
            bottomSheet: (invoiceEntity.isFreeService! ||
                    invoiceEntity.paymentMode == "WALLET")
                ? _buildBackToHomeBtn(context)
                : _buildCashPaid(context, id),
          ),
        );
      }),
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

  void _buildMarkAsPaidListener(CashPaidState state, BuildContext context) {
    if (state is LoadingCashPaid) {
      showLoadingDialog(context, showText: false);
    }
    if (state is CashPaidOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is CashPaidErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('An error has ocurred, try again');
    } else if (state is DoneCashPaid) {
      Navigator.pop(context);
      _showRateDialog(context);
    }
  }

  Widget _buildBackToHomeBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        child: AppButton(
          title: AppLocalizations.of(context)?.finish ?? "",
          onTap: () {
            _showRateDialog(context);
          },
        ),
      ),
    );
  }

  void _showRateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<RateProviderBloc>(),
          child: RatingDialog(
            closehandler: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                ProviderScreen.routeName,
                (route) => false,
              );
            },
            reviewhandler: (comment, rate) {
              BlocProvider.of<RateProviderBloc>(context).add(
                RateEvent(
                  rating: rate.toInt(),
                  requestId: id,
                  comment: comment,
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _buildRateListener(RateProviderState state, BuildContext context) {
    if (state is LoadingRateProvider) {
      showLoadingDialog(context, text: 'submitting...');
    } else if (state is LoadedRateProvider) {
       ToastUtils.showSusToastMessage('Thank you');
      Navigator.pop(context);
      Navigator.pop(context);

     Navigator.pushNamedAndRemoveUntil(
          context, ProviderScreen.routeName, (route) => false,);

    } else if (state is RateProviderOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('NO internet Connection');
    } else if (state is RateProviderErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('An error occurred, try again');
    }
  }

  CashPaidBloc _getCashPaidBloc() {
    return CashPaidBloc(
        recieveCashUseCase: RecieveCashUseCase(
      providerRepo: ProviderRepoImpl(
        providerDataSource: ProviderDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
  }

  Padding _buildCashPaid(BuildContext context, int id) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppButton(
        onTap: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext c) {
              return DialogItem(
                title: AppLocalizations.of(context)!.markAsCashPaid,
                paragraph:
                    AppLocalizations.of(context)!.areYouSureMarkAsCashPaid,
                nextButtonText: AppLocalizations.of(context)!.confirm,
                nextButtonFunction: () async {
                  BlocProvider.of<CashPaidBloc>(context).add(
                    RecieveMoneyEvent(
                      id: id,
                    ),
                  );

                  Navigator.pop(context);
                },
              );
            },
          );
        },
        title: AppLocalizations.of(context)!.markAsCashPaid,
      ),
    );
  }

  // AppText _buildNote(BuildContext context) {
  //   return AppText(
  //     invoiceEntity.isFreeService ?? false
  //         ? AppLocalizations.of(context)?.serviceInvoiceMessageFree ?? ""
  //         : AppLocalizations.of(context)?.serviceInvoiceMessage ?? "",
  //     fontWeight: FontWeight.bold,
  //     fontSize: 12,
  //     color: Theme.of(context).primaryColor,
  //   );
  // }

  // InvoiceProviderItem _buildPaymentMode(BuildContext context) {
  //   return InvoiceProviderItem(
  //       title: AppLocalizations.of(context)?.paymentMode ?? "",
  //       subTitle: invoiceEntity.paymentMode != "WALLET"
  //           ? AppLocalizations.of(context)!.cash
  //           : AppLocalizations.of(context)!.walletLabel,
  //       isLast: true);
  // }

  // InvoiceProviderItem _buildTotal(BuildContext context) {
  //   return InvoiceProviderItem(
  //     title: AppLocalizations.of(context)?.totalLabel ?? "",
  //     subTitle: invoiceEntity.total ?? '',
  //   );
  // }

  // InvoiceProviderItem _buildCharity(BuildContext context) {
  //   return InvoiceProviderItem(
  //     title: AppLocalizations.of(context)?.charityValue ?? "",
  //     subTitle: invoiceEntity.charityValue ?? '',
  //   );
  // }

  // InvoiceProviderItem _buildCommission(BuildContext context) {
  //   return InvoiceProviderItem(
  //     title: AppLocalizations.of(context)?.commission ?? "",
  //     subTitle: invoiceEntity.commision ?? '',
  //   );
  // }

  // InvoiceProviderItem _buildLocalDiscount(BuildContext context) {
  //   return InvoiceProviderItem(
  //     title: AppLocalizations.of(context)?.localCompanyDiscount ?? "",
  //     subTitle: invoiceEntity.localCompanyDiscount ?? '',
  //   );
  // }

  // InvoiceProviderItem _buildTax(BuildContext context) {
  //   return InvoiceProviderItem(
  //     title: AppLocalizations.of(context)?.taxLAbel ?? "",
  //     subTitle: invoiceEntity.tax ?? '',
  //     colorSubTitle: Theme.of(context).primaryColor,
  //   );
  // }

  // InvoiceProviderItem _buildDiscount(BuildContext context) {
  //   return InvoiceProviderItem(
  //     title: AppLocalizations.of(context)?.discountLabel ?? "",
  //     subTitle: invoiceEntity.discount ?? '',
  //     colorSubTitle: Colors.green,
  //   );
  // }

  // InvoiceProviderItem _buildEmergencyTime(BuildContext context) {
  //   return InvoiceProviderItem(
  //     title: AppLocalizations.of(context)?.emergencyTimePrice ?? "",
  //     subTitle: invoiceEntity.emergenctTimePrice ?? '',
  //   );
  // }

  // InvoiceProviderItem _buildConsumedPrice(BuildContext context) {
  //   return InvoiceProviderItem(
  //     title: AppLocalizations.of(context)?.consumedTimeLabel ?? "",
  //     subTitle: invoiceEntity.time ?? '',
  //   );
  // }

  // InvoiceProviderItem _buildTimePrice(BuildContext context) {
  //   return InvoiceProviderItem(
  //     title: AppLocalizations.of(context)?.timePrice ?? "",
  //     subTitle: invoiceEntity.timePrice ?? '',
  //   );
  // }

  // InvoiceProviderItem _buildHourlyPrice(BuildContext context) {
  //   return InvoiceProviderItem(
  //     title: AppLocalizations.of(context)?.hourlyPriceLabel ?? "",
  //     subTitle: invoiceEntity.hourlyPrice ?? '',
  //     colorSubTitle: Theme.of(context).primaryColor,
  //   );
  // }

  // InvoiceProviderItem _buildPrice(BuildContext context) {
  //   return InvoiceProviderItem(
  //     title: AppLocalizations.of(context)?.basicPrice ?? "",
  //     subTitle: invoiceEntity.basicPrice ?? '',
  //     colorSubTitle: Theme.of(context).primaryColor,
  //   );
  // }

  // InvoiceProviderItem _buildStartTime(BuildContext context) {
  //   return InvoiceProviderItem(
  //     title: AppLocalizations.of(context)?.dateLabel ?? "",
  //     subTitle: invoiceEntity.startTime ?? '',
  //   );
  // }

  // CustomMap _buildMap() {
  //   return CustomMap(
  //     lat: lat ?? 0,
  //     lng: lng ?? 0,
  //   );
  // }
}
