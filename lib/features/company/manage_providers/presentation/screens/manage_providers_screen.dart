import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/core/api_service/base_api_service.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/features/company/manage_providers/data/repositories/manage_provider_repo_impl.dart';
import 'package:masbar/features/company/manage_providers/presentation/screens/pending_providers.dart';

import '../../../../../core/network/check_internet.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../data/data_source/manage_provider_data_source.dart';
import '../../domain/use_cases/delete_invitation_use_case.dart';
import '../../domain/use_cases/enable_disable_use_case.dart';
import '../../domain/use_cases/get_pending_provider_use_case.dart';
import '../../domain/use_cases/get_provider_info_use_case.dart';
import '../../domain/use_cases/resend_invitation_use_case.dart';
import '../bloc/delete_invitation_bloc.dart';
import '../bloc/enable_disable_bloc.dart';
import '../bloc/provider_info_bloc.dart';
import '../bloc/resend_invitation_bloc.dart';
import 'active_providers.dart';
import 'add_new_provider_screen.dart';

class ManageProvidersScreen extends StatelessWidget {
  static const routeName = 'manage_provider_screen';
  const ManageProvidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getBloc(),
        ),
        BlocProvider(
          create: (context) => _getEnableBloc(),
        ),
        BlocProvider(
          create: (context) => _getDeleteInvitationBloc(),
        ),
        BlocProvider(
          create: (context) => _getResendInvitationBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return MultiBlocListener(
          listeners: [
            BlocListener<EnableDisableBloc, EnableDisableState>(
              listener: (context, state) {
                _buildEnableDisableListener(state);
              },
            ),
            BlocListener<DeleteInvitationBloc, DeleteInvitationState>(
              listener: (context, state) {
                _buildDeleteInvitationListener(context, state);
              },
            ),
            BlocListener<ResendInvitationBloc, ResendInvitationState>(
              listener: (context, state) {
                _buildResendInvitationListener(state);
              },
            ),
          ],
          child: BlocBuilder<ProviderInfoBloc, ProviderInfoState>(
            builder: (context, state) {
              if (state is LoadingProviderInfo) {
                return const Scaffold(body: LoadingWidget());
              } else if (state is ProviderInfoOfflineState) {
                return Scaffold(
                  body: NoConnectionWidget(
                    onPressed: () {
                      BlocProvider.of<ProviderInfoBloc>(context)
                          .add(GetProviderInfoAndPending());
                    },
                  ),
                );
              } else if (state is ProviderInfoNetworkErrorState) {
                return Scaffold(
                  body: NetworkErrorWidget(
                    message: state.message,
                    onPressed: () {
                      BlocProvider.of<ProviderInfoBloc>(context)
                          .add(GetProviderInfoAndPending());
                    },
                  ),
                );
              } else if (state is LoadedProviderInfo) {
                return DefaultTabController(
                  initialIndex: 0,
                  length: 2,
                  child: Scaffold(
                    appBar: AppBar(
                      iconTheme: const IconThemeData(color: Colors.black),
                      backgroundColor: Colors.white,
                      title: AppText(
                        AppLocalizations.of(context)?.manageProvidersLabel ??
                            "",
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      elevation: 0,
                      centerTitle: true,
                      bottom: TabBar(
                        indicatorColor: Theme.of(context).primaryColor,
                        tabs: <Widget>[
                          Tab(
                            child: AppText(
                                AppLocalizations.of(context)?.activeLabel ??
                                    ""),
                          ),
                          Tab(
                            child: AppText(
                                AppLocalizations.of(context)?.pendingLabel ??
                                    ""),
                          ),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        ActiveProviders(
                          providersInfo: state.info,
                        ),
                        PendingProviders(
                          providers: state.pending,
                        )
                      ],
                    ),
                    bottomSheet: _buildAddUserBtn(state, context),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        );
      }),
    );
  }

  void _buildEnableDisableListener(EnableDisableState state) {
    if (state is EnableDisableOfflineState) {
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state is EnableDisableStateErrorState) {
      ToastUtils.showErrorToastMessage(state.message);
    }
  }

  void _buildDeleteInvitationListener(
      BuildContext context, DeleteInvitationState state) {
    if (state is DeleteInvitationOfflineState) {
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state is DeleteInvitationStateErrorState) {
      ToastUtils.showErrorToastMessage(state.message);
    } else if (state is DoneDeleteInvitationState) {
      ToastUtils.showSusToastMessage(
          'The invitation has been deleted successfully');

      BlocProvider.of<ProviderInfoBloc>(context)
          .add(GetProviderInfoAndPending());
    }
  }
}

void _buildResendInvitationListener(ResendInvitationState state) {
  if (state is ResendInvitationOfflineState) {
    ToastUtils.showErrorToastMessage('No internet connection');
  } else if (state is ResendInvitationStateErrorState) {
    ToastUtils.showErrorToastMessage(state.message);
  } else if (state is DoneResendInvitationState) {
    ToastUtils.showSusToastMessage(
        'The invitation has been resent successfully');
  }
}

DeleteInvitationBloc _getDeleteInvitationBloc() {
  return DeleteInvitationBloc(
      deleteInvitationUseCase: DeleteInvitationUseCase(
          manageProviderRepo: ManageProviderRepoImpl(
    networkInfo: NetworkInfoImpl(
      internetConnectionChecker: InternetConnectionChecker(),
    ),
    manageProvidersDataSource:
        ManageProvidersDataSourceWithHttp(client: NetworkServiceHttp()),
  )));
}

ResendInvitationBloc _getResendInvitationBloc() {
  return ResendInvitationBloc(
      resendInvitationUseCase: ResendInvitationUseCase(
          manageProviderRepo: ManageProviderRepoImpl(
    networkInfo: NetworkInfoImpl(
      internetConnectionChecker: InternetConnectionChecker(),
    ),
    manageProvidersDataSource:
        ManageProvidersDataSourceWithHttp(client: NetworkServiceHttp()),
  )));
}

EnableDisableBloc _getEnableBloc() {
  return EnableDisableBloc(
    enableDisableUseCase: EnableDisableUseCase(
      manageProviderRepo: ManageProviderRepoImpl(
        networkInfo: NetworkInfoImpl(
          internetConnectionChecker: InternetConnectionChecker(),
        ),
        manageProvidersDataSource:
            ManageProvidersDataSourceWithHttp(client: NetworkServiceHttp()),
      ),
    ),
  );
}

ProviderInfoBloc _getBloc() {
  return ProviderInfoBloc(
      getPendingProviderUseCase: GetPendingProviderUseCase(
        manageProviderRepo: ManageProviderRepoImpl(
          networkInfo: NetworkInfoImpl(
            internetConnectionChecker: InternetConnectionChecker(),
          ),
          manageProvidersDataSource: ManageProvidersDataSourceWithHttp(
              client: NetworkServiceHttp()),
        ),
      ),
      getProviderInfoUseCase: GetProviderInfoUseCase(
        manageProviderRepo: ManageProviderRepoImpl(
          networkInfo: NetworkInfoImpl(
            internetConnectionChecker: InternetConnectionChecker(),
          ),
          manageProvidersDataSource: ManageProvidersDataSourceWithHttp(
              client: NetworkServiceHttp()),
        ),
      ))
    ..add(GetProviderInfoAndPending());
}

Container _buildAddUserBtn(LoadedProviderInfo state, BuildContext context) {
  return Container(
    width: double.infinity,
    color: Colors.white,
    margin: const EdgeInsets.all(16),
    child: AppButton(
      title: AppLocalizations.of(context)?.addNewUser ?? "",
      onTap: () {
        Navigator.pushNamed(context, AddNewProviderScreen.routeName,
            arguments: {
              'activeExperts': state.info.activeExperts,
              'allowedExperts': state.info.allowedExperts,
              'backHandler': () {
                print('called');
                BlocProvider.of<ProviderInfoBloc>(context)
                    .add(GetProviderInfoAndPending());
              }
            });
      },
    ),
  );
}
