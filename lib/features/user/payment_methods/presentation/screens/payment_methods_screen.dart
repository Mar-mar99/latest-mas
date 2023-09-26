import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/ui/dialogs/loading_dialog.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';

import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../data/data_source/payment_data_source.dart';
import '../../data/repositories/payment-method_repo_impl.dart';
import '../../domain/use_cases/delete_card_use_case.dart';
import '../../domain/use_cases/get_payments_use_case.dart';
import '../../domain/use_cases/set_default_use_case.dart';
import '../bloc/delete_card_bloc.dart';
import '../bloc/get_payments_bloc.dart';
import '../bloc/set_default_bloc.dart';
import '../dialogs/delete_card_dialog.dart';
import '../widgets/payment_card_item.dart';
import 'add_card_screen.dart';

class PaymentMethodsScreen extends StatelessWidget {
  static const routeName = 'payment_methods_screen';
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getPaymentsBloc(),
        ),
        BlocProvider(
          create: (context) => _getDeletBloc(),
        ),
        BlocProvider(
          create: (context) => _getSetDefaultBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return MultiBlocListener(
          listeners: [
            BlocListener<DeleteCardBloc, DeleteCardState>(
              listener: (context, state) {
                _buildDeleteListener(state, context);
              },
            ),
            BlocListener<SetDefaultBloc, SetDefaultState>(
              listener: (context, state) {
                _buildSetDefaultListener(state, context);
              },
            ),
          ],
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.paymentMethodsTitle),
            ),
            body: SafeArea(
              child: BlocBuilder<GetPaymentsBloc, GetPaymentsState>(
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
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: state.payments.isEmpty
                          ? _buildEmptyList(context)
                          : _buildList(state),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
            ),
            bottomSheet: _buildAddCardBtn(context),
          ),
        );
      }),
    );
  }

  void _buildSetDefaultListener(SetDefaultState state, BuildContext context) {
    if (state is LoadingSetDefault) {
      showLoadingDialog(context);
    } else if (state is SetDefaultOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internnet Connection');
    } else if (state is SetDefaultErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage(state.message);
    } else if (state is DoneSetDefault) {
      Navigator.pop(context);
      dialogSuccess(
        context,
      );

      BlocProvider.of<GetPaymentsBloc>(context).add(GetPaymentsMethodsEvent());
    }
  }

  void _buildDeleteListener(DeleteCardState state, BuildContext context) {
    if (state is LoadingDeleteCard) {
      showLoadingDialog(context);
    } else if (state is DeleteCardOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internnet Connection');
    } else if (state is DeleteCardErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage(state.message);
    } else if (state is DoneDeleteCard) {
      Navigator.pop(context);
      ToastUtils.showSusToastMessage('The card has been deleted successfully');
      BlocProvider.of<GetPaymentsBloc>(context).add(GetPaymentsMethodsEvent());
    }
  }

  SetDefaultBloc _getSetDefaultBloc() {
    return SetDefaultBloc(
      setDefaultUseCase: SetDefaultUseCase(
        paymentMethodsRepo: PaymentMethodsRepoImpl(
          paymentDataSource: PaymentDataSourWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  DeleteCardBloc _getDeletBloc() {
    return DeleteCardBloc(
        deleteCardUseCase: DeleteCardUseCase(
            paymentMethodsRepo: PaymentMethodsRepoImpl(
      paymentDataSource: PaymentDataSourWithHttp(
        client: NetworkServiceHttp(),
      ),
    )));
  }

  Padding _buildList(LoadedGetPayments state) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {},
                  child: PaymentCardItem(
                    card: state.payments[index],
                  ));
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 16,
              );
            },
            itemCount: state.payments.length));
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

  Padding _buildAddCardBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppButton(
        title: AppLocalizations.of(context)?.addCardLabel ?? "",
        onTap: () {
          Navigator.pushNamed(context, AddCardScreen.routeName);
        },
      ),
    );
  }

  Widget _buildEmptyList(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              "assets/images/credit_empty.png",
              height: 50.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              AppLocalizations.of(context)!.letsGetYouSetupMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2.0),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 250.0),
              child: Opacity(
                opacity: 0.5,
                child: Text(
                  AppLocalizations.of(context)!.emptyCardMessage,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
