import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import 'package:masbar/features/user/wallet/domain/use_cases/charge_wallet_use_case.dart';
import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/network/check_internet.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_dialog.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../../../auth/accounts/data/data sources/user_remote_data_source.dart';
import '../../../../auth/accounts/data/repositories/user_repo_impl.dart';
import '../../../payment_methods/data/data_source/payment_data_source.dart';
import '../../../payment_methods/data/repositories/payment-method_repo_impl.dart';
import '../../../payment_methods/domain/entities/payment_method_entity.dart';
import '../../../payment_methods/domain/use_cases/get_payments_use_case.dart';
import '../../../payment_methods/presentation/bloc/get_payments_bloc.dart';
import '../../../payment_methods/presentation/screens/payment_methods_screen.dart';
import '../../data/data_source/wallet_data_source.dart';
import '../../data/repositories/wallet_repo_impl.dart';
import '../bloc/charge_wallet_bloc.dart';
import '../widgets/default_payment_method_item.dart';
import 'electronic_wallet_screen.dart';

class ChargingWalletScreen extends StatelessWidget {
  static const routeName = 'charging_wallet_screen';
  ChargingWalletScreen({super.key});
  final formKey = GlobalKey<FormState>();

  final FocusNode promoCodeFocus = FocusNode();
  final TextEditingController promoCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getPaymentsBloc(),
        ),
        BlocProvider(
          create: (context) => _getChargeWallet(context),
        ),
      ],
      child: Builder(builder: (context) {
        return BlocListener<ChargeWalletBloc, ChargeWalletState>(
          listener: (context, state) {
            _buildChargeWalletListener(state, context);
          },
          child: Scaffold(
            appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.chargingWallet)),
            body: BlocBuilder<GetPaymentsBloc, GetPaymentsState>(
              builder: (context, state) {
                if (state is LoadingGetPayments) {
                  return const LoadingWidget();
                } else if (state is GetPaymentsOfflineState) {
                  return NoConnectionWidget(onPressed: () {
                    BlocProvider.of<GetPaymentsBloc>(context)
                        .add(GetPaymentsMethodsEvent());
                  });
                } else if (state is GetPaymentsErrorState) {
                  return NetworkErrorWidget(
                      message: state.message,
                      onPressed: () {
                        BlocProvider.of<GetPaymentsBloc>(context)
                            .add(GetPaymentsMethodsEvent());
                      });
                } else if (state is LoadedGetPayments) {
                  PaymentsMethodEntity? defaultPayment = state.payments
                      .firstWhereOrNull((element) => element.isDefault == 1);

                  return SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          kToolbarHeight -
                          20,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Expanded(
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _buildAmountLabel(context),
                                    _buildAmountField(context),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    _buildPaymentMethodLabel(context),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    defaultPayment == null
                                        ? _buildNoDefault(context)
                                        : _buildSpecifiedDefault(
                                            defaultPayment, context),
                                  ],
                                ),
                              ),
                            ),
                            _buildChargeBtn(context, defaultPayment)
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        );
      }),
    );
  }

  Column _buildSpecifiedDefault(
      PaymentsMethodEntity defaultPayment, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DefaultPaymentMethodItem(defaultPayment: defaultPayment),
        const SizedBox(
          height: 8,
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
                context, PaymentMethodsScreen.routeName);
          },
          child: Text(
            'Change your default payment method',
          ),
        ),
      ],
    );
  }

  void _buildChargeWalletListener(
      ChargeWalletState state, BuildContext context) {
    if (state is LoadingChargeWallet) {
      showLoadingDialog(context);
    } else if (state is ChargeWalletOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internnet Connection');
    } else if (state is ChargeWalletErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage(state.message);
    } else if (state is LoadedChargeWallet) {
      ToastUtils.showSusToastMessage(
          'The wallet has been charged successfully');
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, ElectronicWalletScreen.routeName);
    }
  }

  AppButton _buildChargeBtn(
      BuildContext c, PaymentsMethodEntity? defaultPayment) {
    return AppButton(
      // isLoading: isLoading,
      title: AppLocalizations.of(c)?.chargingWallet ?? "",
      isDisabled: defaultPayment == null,
      onTap: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          showDialog(
              context: c,
              builder: (BuildContext context) {
                return DialogItem(
                  title: AppLocalizations.of(c)?.chargingWallet ?? "",
                  paragraph:
                      "${AppLocalizations.of(c)?.areYouSureThatYourWalletChargingWorth ?? ""} ${promoCodeController.text}?",
                  cancelButtonText: AppLocalizations.of(c)?.cancel ?? "",
                  nextButtonText: AppLocalizations.of(c)?.save ?? "",
                  nextButtonFunction: () async {
                    chargeWalletHandler(c, defaultPayment);
                    Navigator.pop(context);
                  },
                  cancelButtonFunction: () {
                    Navigator.pop(context);
                  },
                );
              });
        }
        ;
      },
    );
  }

  Container _buildNoDefault(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            5.0,
          ),
        ),
        border: Border.all(
          color: Colors.grey,
          width: 0.4,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText(AppLocalizations.of(context)!.enterPaymentMethodMessage),
          OutlinedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, PaymentMethodsScreen.routeName);
            },
            child: Text(
              AppLocalizations.of(context)!.continueLabel,
            ),
          ),
        ],
      ),
    );
  }

  ChargeWalletBloc _getChargeWallet(BuildContext context) {
    return ChargeWalletBloc(
        chargeWalletUseCase: ChargeWalletUseCase(
      authRepo: context.read<AuthRepo>(),
      userRepo: UserRepoImpl(
        userRemoteDataSource: UserRemoteDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
      walletRepo: WalletRepoImpl(
        walletDataSource: WalletDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
  }

  GetPaymentsBloc _getPaymentsBloc() {
    return GetPaymentsBloc(
      getPaymentMethodsUseCase: GetPaymentMethodsUseCase(
        paymentMethodsRepo: PaymentMethodsRepoImpl(
          paymentDataSource: PaymentDataSourWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetPaymentsMethodsEvent());
  }

  AppText _buildPaymentMethodLabel(BuildContext context) {
    return AppText(
      AppLocalizations.of(context)?.paymentMethod ?? "",
      bold: true,
    );
  }

  AppText _buildAmountLabel(BuildContext context) {
    return AppText(
      AppLocalizations.of(context)?.amount ?? "",
      bold: true,
    );
  }

  AppTextField _buildAmountField(BuildContext context) {
    return AppTextField(
      textInputAction: TextInputAction.go,
      focusNode: promoCodeFocus,
      controller: promoCodeController,
      keyboardType: TextInputType.number,
      labelText: AppLocalizations.of(context)?.amount ?? "",
      hintText: AppLocalizations.of(context)?.amount ?? "",
      validator: (val) {
        if (val.toString().isEmpty) {
          return AppLocalizations.of(context)?.pleaseEnterAmount ?? "";
        } else if (!val.toString().contains(RegExp(r'^\d{0,8}(\.\d{1,4})?$'))) {
          return AppLocalizations.of(context)?.pleaseEnterAmount ?? "";
        }
        return null;
      },
    );
  }

  void chargeWalletHandler(
      BuildContext context, PaymentsMethodEntity? defaultPayment) {
    BlocProvider.of<ChargeWalletBloc>(context).add(
      ChargeEvent(
        amount: promoCodeController.text.toString().trim(),
        cardId: defaultPayment!.id!,
      ),
    );
  }
}
