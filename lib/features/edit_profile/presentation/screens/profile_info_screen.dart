// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';

import '../../../../core/network/check_internet.dart';
import '../../../../core/ui/widgets/error_widget.dart';
import '../../../../core/ui/widgets/loading_widget.dart';
import '../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/utils/helpers/helpers.dart';
import '../../../company/account/presentation/profile/presentation/screens/company_profile_screen.dart';
import '../../../user_emirate/bloc/uae_states_bloc.dart';
import '../../../user_emirate/data/data sources/uae_states_remote_data_source.dart';
import '../../../user_emirate/data/repositories/uae_state_repo_impl.dart';
import '../../../user_emirate/domain/use cases/fetch_uae_states_usecase.dart';
import 'profile_edit_info_screen.dart';

class ProfileInfoScreen extends StatelessWidget {
  static const routeName = 'profile_info_screen';
  final TypeAuth typeAuth;
  const ProfileInfoScreen({
    Key? key,
    required this.typeAuth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getUAEStatesBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.profile),
        ),
        body: SafeArea(
          child: BlocBuilder<UaeStatesBloc, UaeStatesState>(
            builder: (context, state) {
              if (state is LoadingUaeStates) {
                return const LoadingWidget();
              } else if (state is UAEStatesOfflineState) {
                return NoConnectionWidget(
                  onPressed: () {
                    BlocProvider.of<UaeStatesBloc>(context)
                        .add(FetchUaeStatesEvent());
                  },
                );
              } else if (state is UAEStatesErrorState) {
                return NetworkErrorWidget(
                  message: state.message,
                  onPressed: () {
                    BlocProvider.of<UaeStatesBloc>(context)
                        .add(FetchUaeStatesEvent());
                  },
                );
              } else if (state is LoadedUaeStates) {
                switch(typeAuth){

                  case TypeAuth.user:
                      return ProfileEditInfoScreen(
                  typeAuth: typeAuth,
                  states: state.states,
                );
                  case TypeAuth.company:
                  return CompanyProfileScreen(states: state.states,);
                  case TypeAuth.provider:
                    return ProfileEditInfoScreen(
                  typeAuth: typeAuth,
                  states: state.states,
                );
                }

              } else {
                return Container();
              }
            },
          ),
        ),
      ),
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
}
