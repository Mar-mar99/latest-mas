import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/ui/widgets/loading_widget.dart';
import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';

import '../../../data/data_source/earnings_summary_provider_data_source.dart';
import '../../../data/repositories/summary_earnings_provider_repo_impl.dart';
import '../../../domain/use_cases/get_today_provider_summary_use_case.dart';
import '../bloc/get_provider_summary_today_bloc.dart';

class EarningProviderScreen extends StatelessWidget {
  static const routeName = 'earning_provider_screen';
  const EarningProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar:
              AppBar(title: Text(AppLocalizations.of(context)!.earningLabel)),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<GetProviderSummaryTodayBloc,
                GetProviderSummaryTodayState>(
              builder: (context, state) {
                if (state is LoadingGetProviderSummaryToady) {
                  return _buildLoading();
                } else if (state is GetProviderSummaryToadyOfflineState) {
                  return _buildOffline(context);
                } else if (state is GetProviderSummaryToadyErrorState) {
                  return _buildNetworkError(state, context);
                } else if (state is LoadedGetProviderSummaryToady) {
                  return _buildData(context, state);
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

  Center _buildData(BuildContext context, LoadedGetProviderSummaryToady state) {
    return Center(
      child: Column(
        children: [
          AppText(
            AppLocalizations.of(context)?.todayCompletedTarget ?? "",
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
                color: Colors.green.withOpacity(
                  0.5,
                ),
              ),
            ),
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
                      "${state.data.completed!.count ?? ''}/${(state.data.completed!.count ?? 0) + (state.data.canceled ?? 0) + (state.data.scheduled ?? 0)}",
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
            state.data.completed!.revenue ?? '',
            bold: true,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  NetworkErrorWidget _buildNetworkError(
      GetProviderSummaryToadyErrorState state, BuildContext context) {
    return NetworkErrorWidget(
        message: state.message,
        onPressed: () {
          BlocProvider.of<GetProviderSummaryTodayBloc>(context)
              .add(GetProviderTodaySummary());
        });
  }

  NoConnectionWidget _buildOffline(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<GetProviderSummaryTodayBloc>(context)
            .add(GetProviderTodaySummary());
      },
    );
  }

  LoadingWidget _buildLoading() {
    return const LoadingWidget();
  }

  GetProviderSummaryTodayBloc _getBloc() {
    return GetProviderSummaryTodayBloc(
      getTodayProviderUseCase: GetTodayProviderUseCase(
        summaryEarningsProviderRepo: SummaryEarningsProviderRepoImpl(
          earningsSummaryDataSource: EarningsSummaryDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetProviderTodaySummary());
  }
}
