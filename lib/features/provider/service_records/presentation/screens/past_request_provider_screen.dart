import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../user/service_record/presentation/bloc/user_history_requests_bloc.dart';
import '../bloc/get_history_record_provider_bloc.dart';
import '../widgets/past_provider_record_card.dart';

class PastRequestProviderScreen extends StatefulWidget {
  const PastRequestProviderScreen({super.key});

  @override
  State<PastRequestProviderScreen> createState() =>
      _PastRequestProviderScreenState();
}

class _PastRequestProviderScreenState extends State<PastRequestProviderScreen> {
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
          .read<GetHistoryRecordProviderBloc>()
          .add(GetProviderPastRequestsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<GetHistoryRecordProviderBloc,
          GetHistoryRecordProviderState>(
        builder: (context, state) {
          switch (state.status) {
            case ProviderPastRequestsStatus.loading:
              return const LoadingWidget();
            case ProviderPastRequestsStatus.success:
            case ProviderPastRequestsStatus.loadingMore:
              if (state.data.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.noPastServicesYet),
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
                      ? state.status == ProviderPastRequestsStatus.success
                          ? TextButton(
                              onPressed: () {
                                context
                                    .read<GetHistoryRecordProviderBloc>()
                                    .add(GetProviderPastRequestsEvent());
                              },
                              child: Text('Load More',style: TextStyle(fontSize: 14),))
                          : const LoadingWidget()
                      : PastProviderRecordCard(
                          past: state.data[index],
                        );
                },
              );
            case ProviderPastRequestsStatus.error:
              return NetworkErrorWidget(
                message: state.errorMessage,
                onPressed: () {
                  context
                      .read<GetHistoryRecordProviderBloc>()
                      .add(GetProviderPastRequestsEvent(
                        refresh: true,
                      ));
                },
              );
            case ProviderPastRequestsStatus.offline:
              return NoConnectionWidget(
                onPressed: () {
                  context
                      .read<GetHistoryRecordProviderBloc>()
                      .add(GetProviderPastRequestsEvent(
                        refresh: true,
                      ));
                },
              );
          }
        },
      ),
    );
  }
}
