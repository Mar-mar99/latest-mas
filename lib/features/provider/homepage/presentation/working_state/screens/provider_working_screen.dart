import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/ui/widgets/error_widget.dart';
import 'package:masbar/core/ui/widgets/no_connection_widget.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';
import 'package:masbar/features/provider/homepage/domain/use_cases/fetch_offline_requests_use_case.dart';
import 'package:masbar/features/provider/homepage/domain/use_cases/get_current_request_use_case.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../../../core/ui/widgets/app_dialog.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/app_button.dart';
import 'package:lottie/lottie.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../data/date_source/provider_data_source.dart';
import '../../../data/repositories/provider_repo_impl.dart';
import '../../../domain/use_cases/accept_request_use_case.dart';
import '../../../domain/use_cases/get_working_status_use_casel.dart';
import '../../../domain/use_cases/reject_request_use_case.dart';
import '../../active_request/bloc/current_request_bloc.dart';
import '../../coming_request/bloc/accepting_rejecting_bloc.dart';
import '../../offline_requests/screens/offline_requests_provider.dart';
import '../bloc/fetch_offline_requests_bloc.dart';
import '../bloc/go_online_bloc.dart';
import '../../../domain/use_cases/go_online_use_case.dart';
import '../../offline_requests/widgets/offline_item.dart';

class ProviderWorkingScreen extends StatefulWidget {
  const ProviderWorkingScreen({super.key});

  @override
  State<ProviderWorkingScreen> createState() => _ProviderWorkingScreenState();
}

class _ProviderWorkingScreenState extends State<ProviderWorkingScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getOnlineBloc(),
        ),
        BlocProvider(
          create: (context) => _getOfflineRequestBloc(),
        ),

      ],
      child: Builder(builder: (context) {
        return BlocConsumer<GoOnlineBloc, GoOnlineState>(
          listener: (context, state) {
            _buildListener(state, context);
          },
          builder: (context, state) {
            return Scaffold(
              body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (state.isOnline) _buildOnline(),
                        if (!state.isOnline)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AppText(
                                AppLocalizations.of(context)!
                                    .makeSureYouReadyForServices,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    PhosphorIcons.check,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  AppText(
                                    AppLocalizations.of(context)
                                            ?.chargedPhoneMessage ??
                                        "",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        // if (state.isOnline)
                        //   Container(
                        //     margin: const EdgeInsets.only(left: 26, right: 26),
                        //     child: AppText(
                        //       AppLocalizations.of(context)
                        //               ?.stopServiceMessage ??
                        //           "",
                        //       textAlign: TextAlign.center,
                        //     ),
                        //   ),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildStartStopWorkingBtn(state, context)
                      ],
                    )),
              ),
            );
          },
        );
      }),
    );
  }



  Widget _buildOnline() {
    return Expanded(
      child: OfflineRequestProvider()
    );
  }


  AppButton _buildStartStopWorkingBtn(
      GoOnlineState state, BuildContext context) {
    return AppButton(
      title: state.isOnline
          ? AppLocalizations.of(context)?.stopLabel ?? ""
          : AppLocalizations.of(context)?.startWork ?? "",
      isLoading: state.providerOnlineState == ProviderOnlineState.loading,
      onTap: () async {
        BlocProvider.of<GoOnlineBloc>(context).add(
          ChangeOnlineEvent(),
        );
      },
    );
  }

  void _buildListener(GoOnlineState state, BuildContext context) {
    if (state.providerOnlineState == ProviderOnlineState.noInternet) {
      ToastUtils.showErrorToastMessage('No Internet Connection');
    } else if (state.providerOnlineState == ProviderOnlineState.error) {
      ToastUtils.showErrorToastMessage('Something went wrong, try again');
    } else if (state.isOnline) {
      BlocProvider.of<FetchOfflineRequestsBloc>(context)
          .add(GetOfflineRequestsEvent());
    }
  }

  GoOnlineBloc _getOnlineBloc() {
    return GoOnlineBloc(
      getWorkingStatusUseCase: GetWorkingStatusUseCase(),
      goOnlineUseCase: GoOnlineUseCase(
        providerRepo: ProviderRepoImpl(
          providerDataSource: ProviderDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetWorkingStatusEvent());
  }

  FetchOfflineRequestsBloc _getOfflineRequestBloc() {
    return FetchOfflineRequestsBloc(
        fetchOfflineRequestUseCase: FetchOfflineRequestUseCase(
      providerRepo: ProviderRepoImpl(
        providerDataSource: ProviderDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
  }
}
