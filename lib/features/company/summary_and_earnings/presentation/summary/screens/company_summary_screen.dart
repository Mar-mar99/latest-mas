// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/core/ui/widgets/app_drop_down.dart';
import 'package:masbar/core/ui/widgets/loading_widget.dart';
import 'package:masbar/features/company/services_settings/data/repositories/services_repo_impl.dart';
import 'package:masbar/features/company/services_settings/domain/use_cases/get_providers_use_case.dart';
import 'package:masbar/features/company/summary_and_earnings/domain/use_cases/get_range_summary_company_use_case.dart';

import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../provider/earning_summary/data/data_source/earnings_summary_provider_data_source.dart';
import '../../../../../provider/earning_summary/data/repositories/summary_earnings_provider_repo_impl.dart';
import '../../../../services_settings/data/data_sources/services_remote_data_source.dart';
import '../../../../services_settings/domain/entities/company_provider_entity.dart';
import '../../../data/data_source/earnings_summary_provider_data_source.dart';
import '../../../data/repositories/summary_earnings_company_repo_impl.dart';
import '../bloc/comapny_summary_bloc.dart';
import '../widgets/date_range_picker.dart';

class CompanySummaryScreen extends StatefulWidget {
  static const routeName = 'company_summary_screen';
  final bool showAppbar;
  const CompanySummaryScreen({
    Key? key,
     this.showAppbar=true,
  }) : super(key: key);

  @override
  State<CompanySummaryScreen> createState() => _CompanySummaryScreenState();
}

class _CompanySummaryScreenState extends State<CompanySummaryScreen> {
  String? providerId;
  DateTime end = DateTime.now();
  DateTime from = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar:widget.showAppbar? AppBar(title: Text(AppLocalizations.of(context)!.summary)):null,
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<ComapnySummaryBloc, ComapnySummaryState>(
                builder: (context, state) {
              if (state.status == ComapnySummaryStatus.loadingProviders) {
                return _buildLoadingWidget();
              } else if (state.status == ComapnySummaryStatus.offline) {
                return _buildNoInternet(context);
              } else if (state.status == ComapnySummaryStatus.error) {
                return _buildError(state, context);
              } else if (state.status == ComapnySummaryStatus.successful) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildProvidersDropDown(context,state),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildDatePicker(context),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildInfo(context, state)
                  ],
                );
              }
              if (state.status == ComapnySummaryStatus.loadingData) {
                return Column(
                  children: [
                    _buildProvidersDropDown(context, state),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildDatePicker(context),
                    const SizedBox(
                      height: 20,
                    ),
                    const LoadingWidget()
                  ],
                );
              } else {
                return Container();
              }
            }),
          ),
        );
      }),
    );
  }

  NetworkErrorWidget _buildError(
      ComapnySummaryState state, BuildContext context) {
    return NetworkErrorWidget(
        message: state.errorMessage,
        onPressed: () {
          BlocProvider.of<ComapnySummaryBloc>(context).add(
            GetCompanySummaryDataWithProviders(
              end: DateTime.now(),
              start: DateTime.now(),
            ),
          );
        });
  }

  NoConnectionWidget _buildNoInternet(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<ComapnySummaryBloc>(context).add(
          GetCompanySummaryDataWithProviders(
            end: DateTime.now(),
            start: DateTime.now(),
          ),
        );
      },
    );
  }

  LoadingWidget _buildLoadingWidget() {
    return const LoadingWidget();
  }

  Container _buildInfo(BuildContext context, ComapnySummaryState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(
            context,
            AppLocalizations.of(context)!.totalNumberOfService,
            state.data!.completed!.count!.toString(),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          _buildRow(
            context,
            AppLocalizations.of(context)!.revenueLabel,
            state.data!.completed!.revenue!.toString(),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          _buildRow(
            context,
            AppLocalizations.of(context)!.scheduleService,
            state.data!.scheduled!.toString(),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          _buildRow(
            context,
            AppLocalizations.of(context)!.cancelService,
            state.data!.canceled!.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText(
            AppLocalizations.of(context)?.dateLabel ?? "",
            bold: true,
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => DateRangePicker(
                          selectedFrom: from,
                          selectedTo: end,
                          select: (DateTime f, DateTime t) {
                            setState(() {
                              from = f;
                              end = t;
                            });
                            BlocProvider.of<ComapnySummaryBloc>(context).add(
                              GetCompanySummaryDataWithoutProviders(
                                start: from,
                                end: end,
                                providerId: providerId,
                              ),
                            );
                          },
                        )),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.withOpacity(.3),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: AppText(
                  '${from.year}-${from.month}-${from.day} ${AppLocalizations.of(context)?.toLabel ?? ""} ${end.year}-${end.month}-${end.day}'),
            ),
          ),
        ],
      )
    ;
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

  Widget _buildProvidersDropDown(
      BuildContext context, ComapnySummaryState state) {
    return  Column(
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
              BlocProvider.of<ComapnySummaryBloc>(context).add(
                GetCompanySummaryDataWithoutProviders(
                  start: from,
                  end: end,
                  providerId: value.id.toString(),
                ),
              );
            },
          )

        ],
      )
    ;
  }

  ComapnySummaryBloc _getBloc() {
    return ComapnySummaryBloc(
      getRangeSummaryCompanyUseCase: GetRangeSummaryCompanyUseCase(
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
    )..add(
        GetCompanySummaryDataWithProviders(
          start: DateTime.now(),
          end: DateTime.now(),
        ),
      );
  }

  Row _buildRow(BuildContext context, String title, String text) {
    return Row(
      children: [
        AppText(
          title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(letterSpacing: 1, fontSize: 10),
        ),
        const Spacer(),
        AppText(
          text,
          bold: true,
          color: Theme.of(context).primaryColor,
          fontSize: 15,
        ),
      ],
    );
  }
}
