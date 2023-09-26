// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/core/ui/widgets/app_drop_down.dart';
import 'package:masbar/core/utils/helpers/form_submission_state.dart';
import 'package:masbar/features/user_emirate/bloc/uae_states_bloc.dart';
import 'package:masbar/features/user_emirate/domain/entities/uae_state_entity.dart';

import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../../../user_emirate/data/data sources/uae_states_remote_data_source.dart';
import '../../../../user_emirate/data/repositories/uae_state_repo_impl.dart';
import '../../../../user_emirate/domain/use cases/fetch_uae_states_usecase.dart';
import '../../data/data_source/manage_provider_data_source.dart';
import '../../data/repositories/manage_provider_repo_impl.dart';
import '../../domain/use_cases/invite_provider_use_case.dart';
import '../bloc/add_provider_bloc.dart';

class AddNewProviderScreen extends StatelessWidget {
  final int activeExperts;
  final int allowedExperts;
  final VoidCallback onBackHandler;
  static const routeName = 'add_provider_screen';
  AddNewProviderScreen({
    Key? key,
    required this.activeExperts,
    required this.allowedExperts,
    required this.onBackHandler,
  }) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onBackHandler();
        return Future.value(true);
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => _getInviteProvider(),
          ),
          BlocProvider(
            create: (context) => _getUAEStatesBloc(),
          ),
        ],
        child: Builder(builder: (context) {
          return BlocBuilder<UaeStatesBloc, UaeStatesState>(
            builder: (context, state) {
              if (state is LoadingUaeStates) {
                return Scaffold(body: const LoadingWidget());
              } else if (state is UAEStatesOfflineState) {
                return Scaffold(
                  body: NoConnectionWidget(
                    onPressed: () {
                      BlocProvider.of<UaeStatesBloc>(context)
                          .add(FetchUaeStatesEvent());
                    },
                  ),
                );
              } else if (state is UAEStatesErrorState) {
                return Scaffold(
                  body: NetworkErrorWidget(
                    message: state.message,
                    onPressed: () {
                      BlocProvider.of<UaeStatesBloc>(context)
                          .add(FetchUaeStatesEvent());
                    },
                  ),
                );
              } else if (state is LoadedUaeStates) {
                return BlocListener<AddProviderBloc, AddProviderState>(
                  listener: (context, state) {
                    _buildListener(state, context);
                  },
                  child: Scaffold(
                      appBar: _buildAppBar(context),
                      body: SafeArea(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildImage(),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  AppText(
                                    '${AppLocalizations.of(context)!.currentUser} $activeExperts',
                                    bold: true,
                                  ),
                                  _buildDivider(),
                                  AppText(
                                    '${AppLocalizations.of(context)!.remainingUser} $allowedExperts',
                                    bold: true,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  _buildFirstNameField(context),
                                  _buildDivider(),
                                  _buildLastNameField(context),
                                  _buildDivider(),
                                  _buildStateDropDown(context, state),
                                  _buildDivider(),
                                  _buildPhoneField(context),
                                  _buildDivider(),
                                  _buildAppBtn(context)
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                );
              } else {
                return Container();
              }
            },
          );
        }),
      ),
    );
  }

  void _buildListener(AddProviderState state, BuildContext context) {
    if (state.validation == InviteProviderValidation.stateNotSelected) {
      ToastUtils.showErrorToastMessage('You should select the state');
    }
    if (state.formSubmissionState is FormNoInternetState) {
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state.formSubmissionState is FormNetworkErrorState) {
      ToastUtils.showErrorToastMessage(
          'An error occurred while sending, please try again \n ${(state.formSubmissionState as FormNetworkErrorState).message}');
    } else if (state.formSubmissionState is FormSuccesfulState) {
      ToastUtils.showSusToastMessage(
          'The inivitation has been sent to the provider sucessfully');

              onBackHandler();
              Navigator.pop(context);
    }
  }

  AppDropDown<UAEStateEntity> _buildStateDropDown(
    BuildContext context,
    LoadedUaeStates state,
  ) {
    return AppDropDown<UAEStateEntity>(
      hintText: AppLocalizations.of(context)!.choose_your_emirate,
      items: state.states.map((e) => _buildDropMenuItem(context, e)).toList(),
      onChanged: (value) {
        BlocProvider.of<AddProviderBloc>(context)
            .add(StateChangedEvent(state: (value as UAEStateEntity).id));
      },
      initSelectedValue: null,
    );
  }

  UaeStatesBloc _getUAEStatesBloc() {
    return UaeStatesBloc(
      fetchUaeStatesUseCase: FetchUaeStatesUseCase(
        uaeStatesRepo: UAEStatesRepoImpl(
          uaeStatesRemoteDataSource:
              UAEStatesDataSourceWithHttp(client: Client()),
          networkInfo: NetworkInfoImpl(
            internetConnectionChecker: InternetConnectionChecker(),
          ),
        ),
      ),
    )..add(FetchUaeStatesEvent());
  }

  Widget _buildAppBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<AddProviderBloc, AddProviderState>(
        builder: (context, state) {
          var isLoading = false;
          if (state.formSubmissionState is FormSubmittingState) {
            isLoading = true;
          }
          return AppButton(
            isLoading: isLoading,
            title: AppLocalizations.of(context)?.invitation ?? "",
            onTap: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                BlocProvider.of<AddProviderBloc>(context).add(InviteEvent());
              }
            },
          );
        },
      ),
    );
  }

  AddProviderBloc _getInviteProvider() {
    return AddProviderBloc(
        inviteProviderUseCase: InviteProviderUseCase(
      manageProviderRepo: ManageProviderRepoImpl(
        networkInfo: NetworkInfoImpl(
          internetConnectionChecker: InternetConnectionChecker(),
        ),
        manageProvidersDataSource:
            ManageProvidersDataSourceWithHttp(client: NetworkServiceHttp()),
      ),
    ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)?.addNewServiceProvider ?? "",
      ),
    );
  }

  SizedBox _buildDivider() {
    return const SizedBox(
      height: 8,
    );
  }

  AppTextField _buildPhoneField(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      labelText: AppLocalizations.of(context)?.mobileNoLabel ?? "",
      controller: mobileNoController,
      prefix: AppText(
        '+971 ',
        color: Theme.of(context).primaryColor,
      ),
      hintText: AppLocalizations.of(context)?.enterMobileNo ?? "",
      onChanged: (value) {
        BlocProvider.of<AddProviderBloc>(context)
            .add(PhoneChangedEvent(phone: value));
      },
      validator: (value) {
        if (value.toString().trim().isEmpty) {
          return AppLocalizations.of(context)?.mobileError ?? "";
        } else if (value.toString().trim().length != 9) {
          return AppLocalizations.of(context)?.mobileError2 ?? "";
        }
        return null;
      },
    );
  }

  AppTextField _buildLastNameField(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      controller: lastNameController,
      labelText: AppLocalizations.of(context)?.lastName ?? "",
      hintText: AppLocalizations.of(context)?.enterLastName ?? "",
      onChanged: (value) {
        BlocProvider.of<AddProviderBloc>(context)
            .add(LastNameChangedEvent(lastName: value));
      },
      validator: (val) {
        if (val.toString().isEmpty) {
          return AppLocalizations.of(context)?.lastNameError ?? "";
        }
        return null;
      },
    );
  }

  AppTextField _buildFirstNameField(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.next,
      controller: firstNameController,
      labelText: AppLocalizations.of(context)?.firstName ?? "",
      hintText: AppLocalizations.of(context)?.enterFirstName ?? "",
      onChanged: (value) {
        BlocProvider.of<AddProviderBloc>(context)
            .add(FirstNameChangedEvent(firstName: value));
      },
      validator: (val) {
        if (val.toString().isEmpty) {
          return AppLocalizations.of(context)?.firstNameError ?? "";
        }
        return null;
      },
    );
  }

  Container _buildImage() {
    return Container(
      child: Image.asset(
        'assets/images/logo.jpg',
        height: 95,
      ),
    );
  }

  DropdownMenuItem<UAEStateEntity> _buildDropMenuItem(
      BuildContext context, UAEStateEntity e) {
    return DropdownMenuItem<UAEStateEntity>(
      value: e,
      child: Text(
        e.state,
      ),
    );
  }
}
