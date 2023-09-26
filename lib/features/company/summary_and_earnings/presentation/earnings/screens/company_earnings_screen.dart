import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/widgets/app_drop_down.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../services_settings/data/data_sources/services_remote_data_source.dart';
import '../../../../services_settings/data/repositories/services_repo_impl.dart';
import '../../../../services_settings/domain/entities/company_provider_entity.dart';
import '../../../../services_settings/domain/use_cases/get_providers_use_case.dart';
import '../../../data/data_source/earnings_summary_provider_data_source.dart';
import '../../../data/repositories/summary_earnings_company_repo_impl.dart';
import '../../../domain/use_cases/get_today_company_summary_use_case.dart';
import '../bloc/company_earnings_bloc.dart';

class CompanyEarningsScreen extends StatefulWidget {
  static const routeName = 'company_earnings_screen';

  const CompanyEarningsScreen({super.key});

  @override
  State<CompanyEarningsScreen> createState() => _CompanyEarningsScreenState();
}

class _CompanyEarningsScreenState extends State<CompanyEarningsScreen> {
  String? providerId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.earningLabel),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<CompanyEarningsBloc, CompanyEarningsState>(
                builder: (context, state) {
                  if (state.status == CompanyEarningsStatus.loadingProviders) {
                    return _buildLoadingWidget();
                  } else if (state.status == CompanyEarningsStatus.offline) {
                    return _buildNoInternet(context);
                  } else if (state.status == CompanyEarningsStatus.error) {
                    return _buildError(state, context);
                  } else if (state.status ==
                      CompanyEarningsStatus.loadingData) {
                    return Center(
                      child: Column(
                        children: [
                          _buildProvidersDropDown(context, state),
                          const SizedBox(
                            height: 15,
                          ),
                          AppText(
                            AppLocalizations.of(context)!.todayCompletedTarget,
                            bold: true,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                         const LoadingWidget(),
                        ],
                      ),
                    );
                  } else if (state.status == CompanyEarningsStatus.successful) {
                    return Center(
                      child: Column(
                        children: [
                          _buildProvidersDropDown(context, state),
                          const SizedBox(
                            height: 15,
                          ),
                          AppText(
                            AppLocalizations.of(context)!.todayCompletedTarget,
                            bold: true,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    width: 5,
                                    color: Colors.green.withOpacity(0.5))),
                            child: Center(
                              child: FractionallySizedBox(
                                heightFactor: 0.9,
                                widthFactor: 0.9,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: AppText(
                                      "${state.data!.completed!.count ?? ''}/${(state.data!.completed!.count ?? 0) + (state.data!.canceled ?? 0) + (state.data!.scheduled ?? 0)}",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          AppText(
                            AppLocalizations.of(context)?.totalEarning ?? "",
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AppText(
                            state.data!.completed!.revenue ?? '',
                            bold: true,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  DropdownMenuItem<CompanyProviderEntity> _buildProviderDropMenuItem(
      BuildContext context, CompanyProviderEntity e) {
    return DropdownMenuItem<CompanyProviderEntity>(
      value: e,
      child: Text(
        e.name,
      ),
    );
  }

  Padding _buildProvidersDropDown(
      BuildContext context, CompanyEarningsState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText(
            AppLocalizations.of(context)?.expertLabel ?? "",
            bold: true,
          ),
          const SizedBox(
            height: 10,
          ),
          AppDropDown<CompanyProviderEntity>(
            hintText: 'All',
            items: state.providers
                .map((e) => _buildProviderDropMenuItem(context, e))
                .toList(),
            initSelectedValue: null,
            onChanged: (value) {
              setState(() {
                providerId = value.id.toString();
              });
              BlocProvider.of<CompanyEarningsBloc>(context).add(
                GetEarningsDataWithoutProviders(
                  providerId: value.id.toString(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  NetworkErrorWidget _buildError(
      CompanyEarningsState state, BuildContext context) {
    return NetworkErrorWidget(
        message: state.errorMessage,
        onPressed: () {
          BlocProvider.of<CompanyEarningsBloc>(context).add(
            GetEarningsDataWithProviders(),
          );
        });
  }

  NoConnectionWidget _buildNoInternet(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<CompanyEarningsBloc>(context).add(
          GetEarningsDataWithProviders(),
        );
      },
    );
  }

  LoadingWidget _buildLoadingWidget() {
    return const LoadingWidget();
  }

  CompanyEarningsBloc _getBloc() {
    return CompanyEarningsBloc(
      getTodayCompanyUseCase: GetTodayCompanyUseCase(
        summaryEarningsCompanyRepo: SummaryEarningsCompanyRepoImpl(
          earningsSummaryDataSource: CompanyEarningsSummaryDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
      getProvidersUseCase: GetProvidersUseCase(
        servicesRepo: ServicesRepoImpl(
          servicesRemoteDataSource: ServicesRemoteDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetEarningsDataWithProviders());
  }
}
