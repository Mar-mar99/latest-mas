import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../homepage/data/date_source/provider_data_source.dart';
import '../../../homepage/data/repositories/provider_repo_impl.dart';
import '../../../homepage/domain/use_cases/cancel_after_request_use_case.dart';
import '../../../homepage/domain/use_cases/start_working_use_case.dart';
import '../../../homepage/presentation/active_request/bloc/cancel_after_accept_bloc.dart';
import '../../../homepage/presentation/active_request/bloc/start_bloc.dart';
import '../bloc/get_history_record_provider_bloc.dart';
import '../bloc/get_upcoming_record_provider_bloc.dart';
import '../widgets/upcoming_provider_record_card.dart';

class UpcomingRequestProviderScreen extends StatefulWidget {
  const UpcomingRequestProviderScreen({super.key});

  @override
  State<UpcomingRequestProviderScreen> createState() =>
      _UpcomingRequestProviderScreenState();
}

class _UpcomingRequestProviderScreenState
    extends State<UpcomingRequestProviderScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
   // _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // _scrollController
    //   ..removeListener(_onScroll)
    //   ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      context
          .read<GetUpcomingRecordProviderBloc>()
          .add(GetProviderUpcomingtRequestsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getCancelAfterAcceptBloc(),
        ),
        BlocProvider(
          create: (context) => _getStartBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<GetUpcomingRecordProviderBloc,
              GetUpcomingRecordProviderState>(
            builder: (context, state) {
              switch (state.status) {
                case ProviderUpcomingRequestsStatus.loading:
                  return const LoadingWidget();
                case ProviderUpcomingRequestsStatus.success:
                 case ProviderUpcomingRequestsStatus.loadingMore:
                  if (state.data.isEmpty) {
                    return Center(
                      child:
                          Text(AppLocalizations.of(context)!.noPastServicesYet),
                    );
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                    controller: _scrollController,
                    itemCount: state.hasReachedMax
                        ? state.data.length
                        : state.data.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      return index >= state.data.length
                          ? state.status == ProviderUpcomingRequestsStatus.success
                          ? TextButton(
                              onPressed: () {
                                context
                                    .read<GetUpcomingRecordProviderBloc>()
                                    .add(GetProviderUpcomingtRequestsEvent());
                              },
                              child: Text('Load More',style: TextStyle(fontSize: 14),))
                          : const LoadingWidget()
                          : UpcomingProviderRecordCard(
                              upcoming: state.data[index],
                            );
                    },
                  );
                case ProviderUpcomingRequestsStatus.error:
                  return NetworkErrorWidget(
                    message: state.errorMessage,
                    onPressed: () {
                      BlocProvider.of<GetUpcomingRecordProviderBloc>(context)
                          .add(GetProviderUpcomingtRequestsEvent(
                        refresh: true,
                      ));
                    },
                  );
                case ProviderUpcomingRequestsStatus.offline:
                  return NoConnectionWidget(
                    onPressed: () {
                      BlocProvider.of<GetUpcomingRecordProviderBloc>(context)
                          .add(GetProviderUpcomingtRequestsEvent(
                        refresh: true,
                      ));
                    },
                  );
              }
            },
          ),
        );
      }),
    );
  }

  CancelAfterAcceptBloc _getCancelAfterAcceptBloc() {
    return CancelAfterAcceptBloc(
      cancelAfterRequestUseCase: CancelAfterRequestUseCase(
        providerRepo: ProviderRepoImpl(
          providerDataSource: ProviderDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  StartBloc _getStartBloc() {
    return StartBloc(
        startWorkingUseCase: StartWorkingUseCase(
      providerRepo: ProviderRepoImpl(
        providerDataSource: ProviderDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
  }
}
