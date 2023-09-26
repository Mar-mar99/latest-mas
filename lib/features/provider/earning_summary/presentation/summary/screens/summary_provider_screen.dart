import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../data/data_source/earnings_summary_provider_data_source.dart';
import '../../../data/repositories/summary_earnings_provider_repo_impl.dart';
import '../../../domain/use_cases/get_range_summary_provider_use_case.dart';
import '../bloc/get_provider_summary_range_bloc.dart';

class SummaryProviderScreen extends StatelessWidget {
  static const routeName = 'summary_provider_screen';
  const SummaryProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.summary)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<GetProviderSummaryRangeBloc,
              GetProviderSummaryRangeState>(
            builder: (context, state) {
              if (state is LoadingGetProviderSummaryRange) {
                return _buildLoading();
              } else if (state is GetProviderSummaryRangeOfflineState) {
                return _buildOffline(context);
              } else if (state is GetProviderSummaryRangeErrorState) {
                return _buildNetworkError(state, context);
              } else if (state is LoadedGetProviderSummaryRange) {
                return _buildData(context, state);
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Column _buildData(BuildContext context, LoadedGetProviderSummaryRange state) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
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
                  '${state.data.completed!.count ?? ''}'),
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
                state.data.completed!.revenue ?? '',
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
                '${state.data.scheduled ?? ''}',
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
                '${state.data.canceled ?? ''}',
              ),
            ],
          ),
        )
      ],
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

  NetworkErrorWidget _buildNetworkError(
      GetProviderSummaryRangeErrorState state, BuildContext context) {
    return NetworkErrorWidget(
        message: state.message,
        onPressed: () {
          BlocProvider.of<GetProviderSummaryRangeBloc>(context).add(
              GetProviderSummaryRange(
                  end: DateTime.now(), start: DateTime.now()));
        });
  }

  NoConnectionWidget _buildOffline(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<GetProviderSummaryRangeBloc>(context).add(
            GetProviderSummaryRange(
                end: DateTime.now(), start: DateTime.now()));
      },
    );
  }

  LoadingWidget _buildLoading() {
    return const LoadingWidget();
  }

  GetProviderSummaryRangeBloc _getBloc() {
    return GetProviderSummaryRangeBloc(
      getRangeSummaryProviderUseCase: GetRangeSummaryProviderUseCase(
        summaryEarningsProviderRepo: SummaryEarningsProviderRepoImpl(
          earningsSummaryDataSource: EarningsSummaryDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetProviderSummaryRange(end: DateTime.now(), start: DateTime.now()));
  }
}
