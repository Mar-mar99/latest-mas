// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/ui/dialogs/loading_dialog.dart';
import 'package:masbar/core/ui/dialogs/rating_dialog.dart';
import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/invoice/invoice_screen.dart';
import '../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/utils/helpers/toast_utils.dart';
import '../../../../../navigation/screens/user_screen.dart';
import '../../../../service_record/data/data_source/user_service_record_data_source.dart';
import '../../../../service_record/data/repositories/user_service_record_repo_impl.dart';
import '../../../../service_record/domain/use_cases/rate_request_use_case.dart';
import '../../../../service_record/presentation/bloc/rate_request_bloc.dart';
import '../../../domain/entities/request_details_entity.dart';

class UserInvoiceRequestScreen extends StatelessWidget {
  static const routeName = 'user_invoice_request_screen';
  final RequestDetailsEntity requestDetailsEntity;
  const UserInvoiceRequestScreen({
    Key? key,
    required this.requestDetailsEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _buildRateBloc(),
      child: Builder(builder: (context) {
        return BlocListener<RateRequestBloc, RateRequestState>(
          listener: (context, state) {
            _buildRateListener(state, context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                  '${AppLocalizations.of(context)?.invoiceLabel ?? ""} #${requestDetailsEntity.bookingId}'),
            ),
            body: InvoiceScreen(
              bookingId: requestDetailsEntity.bookingId!,
              baseFare: requestDetailsEntity.payment!.fixed!,
              hourlyRate: requestDetailsEntity.payment!.hourlyRate!,
              consumedTime: requestDetailsEntity.totalServiceTime,
              discount: requestDetailsEntity.payment!.discount!,
              tax: requestDetailsEntity.payment!.tax!,
              amountToBePaid: requestDetailsEntity.payment!.total!,
              paymentMode: requestDetailsEntity.paymentMode,
              promocode: requestDetailsEntity.payment!.promocodeId!,
              isFree:
                  requestDetailsEntity.serviceType!.paymentStatus! != 'paid',
              showMessage: true,
            ),
            bottomSheet: _buildBackToHomeBtn(context),
          ),
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

  void _buildRateListener(RateRequestState state, BuildContext context)async {
    if (state is LoadingRateRequest) {
      showLoadingDialog(context, text: "Submitting...");
    }
    if (state is LoadedRateRequest) {
      Navigator.pop(context);
      Navigator.pop(context);
      ToastUtils.showSusToastMessage('Thank you');

  await Future.delayed(const Duration(seconds: 1));
  
   Navigator.pop(context);
   Navigator.pop(context);
      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   UserScreen.routName,
      //   (route) => false,
      //   arguments: {
      //     'showExploreScreen': null,
      //     'requestId': null,
      //   },
      // );
    } else if (state is RateRequestOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('NO internet Connection');
    } else if (state is RateRequestErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('An error occurred, try again');
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
            showDialog(
              context: context,
              builder: (dialogContext) {
                return BlocProvider.value(
                  value: context.read<RateRequestBloc>(),
                  child: RatingDialog(
                    showFav: true,
                    closehandler: () {
                    // Navigator.pushNamedAndRemoveUntil(
                    //   context,
                    //   UserScreen.routName,
                    //   (route) => false,
                    //   arguments: {
                    //     'showExploreScreen': null,
                    //     'requestId': null,
                    //   },
                    //);
                    Navigator.pop(context);

                  }, reviewhandler: (comment, rate,isFav) {
                    BlocProvider.of<RateRequestBloc>(context).add(
                      RateEvent(
                        rating: rate.toInt(),
                        requestId: requestDetailsEntity.id!,
                        comment: comment,
                        isFav: isFav
                      ),
                    );
                  }),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
