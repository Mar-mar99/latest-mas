import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/ui/dialogs/cancel_reason_dialog.dart';
import '../../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/profile/mini_avatar.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../../homepage/data/date_source/provider_data_source.dart';
import '../../../homepage/data/repositories/provider_repo_impl.dart';
import '../../../homepage/domain/use_cases/cancel_after_request_use_case.dart';
import '../../../homepage/domain/use_cases/start_working_use_case.dart';
import '../../../homepage/presentation/active_request/bloc/cancel_after_accept_bloc.dart';
import '../../../homepage/presentation/active_request/bloc/start_bloc.dart';
import '../../domain/entities/request_upcoming_provider_entity.dart';
import '../bloc/get_upcoming_record_provider_bloc.dart';
import '../screens/upcoming_request_details_provider.dart';

class UpcomingProviderRecordCard extends StatelessWidget {
  final RequestUpcomingProviderEntity upcoming;
  UpcomingProviderRecordCard({super.key, required this.upcoming});

  final formKey = GlobalKey<FormState>();
  TextEditingController cancelTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CancelAfterAcceptBloc, CancelAfterAcceptState>(
          listener: (context, state) {
            _buildCancelingListener(state, context);
          },
        ),
        BlocListener<StartBloc, StartState>(
          listener: (context, state) {
            _buildStartListener(state, context);
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              border: Border.all(width: 0.2, color: Colors.grey)),
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
                        AppText(
                          upcoming.serviceType?.name ?? '',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        AppText(
                          upcoming.scheduleAt.toString(),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                              color: (upcoming.status ?? '') == 'CANCELLED'
                                  ? Colors.red
                                  : Colors.green,
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        AppText(
                          upcoming.status ?? '',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
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
                          ('${upcoming.user!.firstName ?? ''} ${upcoming.user!.lastName ?? ''}'),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            AppText(
                              upcoming.user!.rating ?? '',
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
              if (upcoming.status != 'CANCELLED')
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildViewDetailsBtn(context),
                      _buildStartBtn(context),
                      _buildCancelBtn(context),
                    ],
                  ),
                ),
            ],
          ),
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
              return CancelReasonDialog(handler: (value) {
                BlocProvider.of<CancelAfterAcceptBloc>(context)
                    .add(CancelRequest(id: upcoming.id!, reason: value));
              });
            },
          );
        },
        isSmall: true,
        buttonColor: ButtonColor.green,
        title: AppLocalizations.of(context)?.cancelLabel ?? "");
  }

  AppButton _buildViewDetailsBtn(BuildContext context) {
    return AppButton(
      onTap: () {
        Navigator.pushNamed(
            context, UpcomingRequestDetailsProviderScreen.routeName,
            arguments: {'data': upcoming});
      },
      isSmall: true,
      buttonColor: ButtonColor.transparentBorderPrimary,
      title: AppLocalizations.of(context)?.viewDetails ?? "",
    );
  }

  AppButton _buildStartBtn(BuildContext context) {
    return AppButton(
        onTap: () {
          BlocProvider.of<StartBloc>(context)
              .add(StartRequestEvent(id: upcoming.id!));
        },
        isSmall: true,
        buttonColor: ButtonColor.primary,
        title: AppLocalizations.of(context)?.start ?? "");
  }

  void _buildCancelingListener(
      CancelAfterAcceptState state, BuildContext context) {
    if (state is LoadingCancel) {
      showLoadingDialog(context, text: 'Canceling...');
    } else if (state is CancelOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is CancelErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('An error has ocurred, try again');
    } else if (state is DoneCancel) {
      Navigator.pop(context);
      BlocProvider.of<GetUpcomingRecordProviderBloc>(context).add(
        GetProviderUpcomingtRequestsEvent(refresh: true),
      );
    }
  }

  void _buildStartListener(StartState state, BuildContext context) {
    if (state is LoadingStart) {
      showLoadingDialog(context, text: 'Starting...');
    } else if (state is StartOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is StartErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('An error has ocurred, try again');
    } else if (state is DoneStart) {
      Navigator.pop(context);
      BlocProvider.of<GetUpcomingRecordProviderBloc>(context).add(
        GetProviderUpcomingtRequestsEvent(refresh: true),
      );
    }
  }
}
