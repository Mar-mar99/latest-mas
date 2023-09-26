// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../../core/utils/helpers/toast_utils.dart';
import '../../../../../navigation/screens/provider_screen.dart';
import '../../../data/date_source/provider_data_source.dart';
import '../../../data/repositories/provider_repo_impl.dart';
import '../../../domain/use_cases/accept_request_use_case.dart';
import '../../../domain/use_cases/reject_request_use_case.dart';
import '../../../domain/use_cases/suggest_time_use_case.dart';
import '../../coming_request/bloc/accepting_rejecting_bloc.dart';
import '../../coming_request/bloc/suggest_time_bloc.dart';
import '../../working_state/bloc/fetch_offline_requests_bloc.dart';
import '../widgets/offline_item.dart';

class OfflineRequestProvider extends StatelessWidget {
  final bool isServiceRecord;
  const OfflineRequestProvider({
    Key? key,
    this.isServiceRecord = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getAcceptRejectBloc(),
        ),
        BlocProvider(
          create: (context) => _getSuggestTimeBloc(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AcceptingRejectingBloc, AcceptingRejectingState>(
            listener: (context, state) {
              _buildAcceptRejectListener(state, context);
            },
          ),
          BlocListener<SuggestTimeBloc, SuggestTimeState>(
            listener: (context, state) {
              _buildSuggestListener(state, context);
            },
          ),
        ],
        child: BlocBuilder<FetchOfflineRequestsBloc, FetchOfflineRequestsState>(
          builder: (context, state) {
            if (state is LoadingFetchOfflineRequests) {
              return LoadingWidget();
            } else if (state is FetchOfflineRequestsOfflineState) {
              return NoConnectionWidget(onPressed: () {
                BlocProvider.of<FetchOfflineRequestsBloc>(context)
                    .add(GetOfflineRequestsEvent());
              });
            } else if (state is FetchOfflineRequestsErrorState) {
              return NetworkErrorWidget(
                  message: state.message,
                  onPressed: () {
                    BlocProvider.of<FetchOfflineRequestsBloc>(context)
                        .add(GetOfflineRequestsEvent());
                  });
            } else if (state is LoadedFetchOfflineRequests) {
              return state.data.isEmpty
                  ? Center(
                      child: isServiceRecord
                          ? Text('No offline records')
                          : Lottie.asset(
                              'assets/progress-loader.json',
                            ),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        return OfflineItem(
                          data: state.data[index],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 16,
                        );
                      },
                      itemCount: state.data.length,
                    );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  void _buildSuggestListener(SuggestTimeState state, BuildContext context) {
    if (state is LoadingSuggestTime) {
      showLoadingDialog(context, showText: false);
    } else if (state is SuggestTimeOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is SuggestTimeErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('error (${state.message})');
    } else if (state is LoadedSuggestTime) {
      Navigator.pop(context);
     
      Navigator.pop(context);
      ToastUtils.showSusToastMessage(
        'The suggested time has been set successfully',
      );

      BlocProvider.of<FetchOfflineRequestsBloc>(context)
          .add(GetOfflineRequestsEvent());
    }
  }

  void _buildAcceptRejectListener(
      AcceptingRejectingState state, BuildContext context) {
    if (state is LoadingAcceptingRejecting) {
      showLoadingDialog(context, showText: false);
    } else if (state is AcceptingRejectingOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is AcceptingRejectingErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('error (${state.message})');
    } else if (state is LoadedAcceptingRejecting) {
      Navigator.pop(context);

      ToastUtils.showSusToastMessage(state.isAccepted
          ? 'Request has been accepted'
          : 'Request has been rejected');
      BlocProvider.of<FetchOfflineRequestsBloc>(context)
          .add(GetOfflineRequestsEvent());
    }
  }

  AcceptingRejectingBloc _getAcceptRejectBloc() {
    return AcceptingRejectingBloc(
        acceptRequestUseCase: AcceptRequestUseCase(
          providerRepo: ProviderRepoImpl(
            providerDataSource: ProviderDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
          ),
        ),
        rejectRequestUseCase: RejectRequestUseCase(
          providerRepo: ProviderRepoImpl(
            providerDataSource: ProviderDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
          ),
        ));
  }

  SuggestTimeBloc _getSuggestTimeBloc() {
    return SuggestTimeBloc(
        suggestTimeUseCase: SuggestTimeUseCase(
      providerRepo: ProviderRepoImpl(
        providerDataSource: ProviderDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
  }
}
