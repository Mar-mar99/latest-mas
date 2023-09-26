import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import 'package:masbar/features/user/wallet/presentation/bloc/charge_wallet_bloc.dart';

import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../data/data_source/wallet_data_source.dart';
import '../../data/repositories/wallet_repo_impl.dart';
import '../../domain/use_cases/charge_wallet_use_case.dart';
import '../../domain/use_cases/get_wallet_use_case.dart';
import '../bloc/get_wallet_bloc.dart';
import '../widgets/wallet_item.dart';
import 'charging_wallet_screen.dart';

class ElectronicWalletScreen extends StatelessWidget {
  static const routeName = 'electronic_wallet_screen';
  const ElectronicWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getWalletBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          appBar:
              AppBar(title: Text(AppLocalizations.of(context)!.walletLabel)),
          body: BlocBuilder<GetWalletBloc, GetWalletState>(
              builder: (context, state) {
            if (state is LoadingGetWallet) {
              return const LoadingWidget();
            } else if (state is GetWalletOfflineState) {
              return NoConnectionWidget(onPressed: () {
                BlocProvider.of<GetWalletBloc>(context)
                    .add(GetWalletDetailsEvent());
              });
            } else if (state is GetWalletErrorState) {
              return NetworkErrorWidget(
                  message: state.message,
                  onPressed: () {
                    BlocProvider.of<GetWalletBloc>(context)
                        .add(GetWalletDetailsEvent());
                  });
            } else if (state is LoadedGetWallet) {
              print('length ${state.wallets.length}');
              return SingleChildScrollView(
                child: SizedBox(

                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildCurrentAmountWallet(context),
                        const SizedBox(
                          height: 8,
                        ),
                        ...state.wallets
                            .map((e) => Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    WalletItem(walletEntity: e),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ))
                            .toList(),
                        // Expanded(
                        //   child: ListView.separated(
                        //     // primary: false,
                        //     //   shrinkWrap: true,
                        //     //   physics: const NeverScrollableScrollPhysics(),
                        //       itemBuilder: (context, index) {
                        //         return WalletItem(
                        //           walletEntity: state.wallets[index],
                        //         );
                        //       },
                        //       separatorBuilder: (context, index) =>
                        //           const SizedBox(
                        //             height: 16,
                        //           ),
                        //       itemCount: state.wallets.length),

                        // ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
          bottomSheet: _buildChargeBtn(context),
        );
      }),
    );
  }

  GetWalletBloc _getWalletBloc() {
    return GetWalletBloc(
      getWalletUseCase: GetWalletUseCase(
        walletRepo: WalletRepoImpl(
          walletDataSource: WalletDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetWalletDetailsEvent());
  }

  Widget _buildCurrentAmountWallet(BuildContext context) {
    return Container(
      height: 125,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            AppLocalizations.of(context)?.yourWalletAmountIs ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Theme.of(context).primaryColor.withOpacity(0.8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Text(
              context.read<AuthRepo>().getUserData()!.walletBalance.toString(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChargeBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppButton(
        title: AppLocalizations.of(context)?.chargingWallet ?? "",
        onTap: () {
          Navigator.pushNamed(context, ChargingWalletScreen.routeName);
        },
      ),
    );
  }
}
