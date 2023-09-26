import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/network/check_internet.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../data/data_source/manage_provider_data_source.dart';
import '../../data/repositories/manage_provider_repo_impl.dart';
import '../../domain/use_cases/search_active_provider_use_case.dart';
import '../bloc/search_providers_bloc.dart';
import '../widgets/active_provider_card.dart';

class SearchActiveProvidersScreen extends StatelessWidget {
  static const routeName = 'search_active_providers_screen';
  const SearchActiveProvidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getSearchBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(title: Text( AppLocalizations.of(context)!.search_for_providers)),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSearchField(context),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocBuilder<SearchProvidersBloc, SearchProvidersState>(
                    builder: (context, state) {
                      if (state is LoadingSearchProviders) {
                        return _buildLoading();
                      } else if (state is SearchProvidersOfflineState) {
                        return _buildOffline(context);
                      } else if (state is SearchProvidersNetworkErrorState) {
                        return _buildError(state, context);
                      } else if (state is LoadedSearchProviders) {
                        return Column(
                          children: [
                            if (state.data.isNotEmpty)
                              ...state.data.map(
                                (e) => Column(
                                  children: [
                                    ActiveProviderCard(
                                      provider: e,
                                    ),
                                    const Divider(
                                      height: 8,
                                    )
                                  ],
                                ),
                              ),
                            if (state.data.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: AppText(
                                  AppLocalizations.of(context)
                                          ?.noUsersProviders ??
                                      "",
                                ),
                              )
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  SearchProvidersBloc _getSearchBloc() {
    return SearchProvidersBloc(
        searchActiveProviderUseCase: SearchActiveProviderUseCase(
      manageProviderRepo: ManageProviderRepoImpl(
        networkInfo: NetworkInfoImpl(
          internetConnectionChecker: InternetConnectionChecker(),
        ),
        manageProvidersDataSource:
            ManageProvidersDataSourceWithHttp(client: NetworkServiceHttp()),
      ),
    ));
  }

  AppTextField _buildSearchField(BuildContext context) {
    return AppTextField(
                  controller: TextEditingController(),
                  suffixIcon: Icons.search_rounded,
                  hintText:
                      AppLocalizations.of(context)?.findTheProviders ?? "",
                  onChanged: (value) {
                    BlocProvider.of<SearchProvidersBloc>(context)
                        .add(SearchEvent(key: value));
                  },
                );
  }

  NetworkErrorWidget _buildError(
      SearchProvidersNetworkErrorState state, BuildContext context) {
    return NetworkErrorWidget(
      message: state.message,
      onPressed: () {
        BlocProvider.of<SearchProvidersBloc>(context).add(SearchEvent(key: ''));
      },
    );
  }

  LoadingWidget _buildLoading() => LoadingWidget();

  NoConnectionWidget _buildOffline(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<SearchProvidersBloc>(context).add(SearchEvent(key: ''));
      },
    );
  }
}
