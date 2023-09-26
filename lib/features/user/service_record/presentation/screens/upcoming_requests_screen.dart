import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/ui/dialogs/loading_dialog.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';
import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../services/data/data_source/explore_services_data_source.dart';
import '../../../services/data/repositories/explore_services_repo_impl.dart';
import '../../../services/domain/use_cases/cancel_request_use_case.dart';
import '../../../services/presentation/service_details.dart/bloc/cancel_user_request_bloc.dart';
import '../bloc/user_history_requests_bloc.dart';
import '../bloc/user_upcoming_requests_bloc.dart';
import '../widgets/upcoming_service_record_card.dart';

class UpcomingRequestsScreen extends StatefulWidget {
  const UpcomingRequestsScreen({super.key});

  @override
  State<UpcomingRequestsScreen> createState() => _UpcomingRequestsScreenState();
}

class _UpcomingRequestsScreenState extends State<UpcomingRequestsScreen> {
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
          .read<UserUpcomingRequestsBloc>()
          .add(GetUserUpcomingtRequestsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _buildCancelBloc(),
      child: Builder(builder: (context) {
        return BlocListener<CancelUserRequestBloc, CancelUserRequestState>(
          listener: (context, state) {
            _buildCancelListener(state, context);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<UserUpcomingRequestsBloc,
                UserUpcomingRequestsState>(
              builder: (context, state) {
                switch (state.status) {
                  case UserUpcomingRequestsStatus.loading:
                    return const LoadingWidget();
                  case UserUpcomingRequestsStatus.success:
                   case UserUpcomingRequestsStatus.loadingMore:
                    if (state.data.isEmpty) {
                      return Center(
                        child: Text(
                            AppLocalizations.of(context)!.noUpcomingServiceYet),
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
                            ?  state.status == UserUpcomingRequestsStatus.success
                          ? TextButton(
                              onPressed: () {
                                context
                                    .read<UserUpcomingRequestsBloc>()
                                    .add(GetUserUpcomingtRequestsEvent());
                              },
                              child: Text('Load More',style: TextStyle(fontSize: 14),))
                          : const LoadingWidget()
                            : UpcomingServiceRecordCard(
                                upcoming: state.data[index],
                              );
                      },
                    );
                  case UserUpcomingRequestsStatus.error:
                    return NetworkErrorWidget(
                      message: state.errorMessage,
                      onPressed: () {
                        context
                            .read<UserUpcomingRequestsBloc>()
                            .add(GetUserUpcomingtRequestsEvent(refresh: true));
                      },
                    );
                  case UserUpcomingRequestsStatus.offline:
                    return NoConnectionWidget(
                      onPressed: () {
                        context
                            .read<UserUpcomingRequestsBloc>()
                            .add(GetUserUpcomingtRequestsEvent(refresh: true));
                      },
                    );
                }
              },
            ),
          ),
        );
      }),
    );
  }

  void _buildCancelListener(
      CancelUserRequestState state, BuildContext context) {
    if (state is LoadingCancelUserRequest) {
      showLoadingDialog(context, text: 'cancelling');
    } else if (state is CancelUserRequestOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No Internet Connection');
    } else if (state is CancelUserRequestErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('An error has occurred, try again');
    } else if (state is DoneCancelUserRequest) {
      Navigator.pop(context);
      ToastUtils.showSusToastMessage(
          'The request has been canceled successfully');
      context
          .read<UserUpcomingRequestsBloc>()
          .add(GetUserUpcomingtRequestsEvent(refresh: true));
    }
  }

  CancelUserRequestBloc _buildCancelBloc() {
    return CancelUserRequestBloc(
        cancelRequestUseCase: CancelRequestUseCase(
      exploreServicesRepo: ExploreServicesRepoImpl(
        exploreServicesDataSource: ExploreServicesDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
  }
}
