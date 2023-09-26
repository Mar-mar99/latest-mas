// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../core/ui/widgets/error_widget.dart';
// import '../../../../../core/ui/widgets/loading_widget.dart';
// import '../../../../../core/ui/widgets/no_connection_widget.dart';
// import '../bloc/user_history_requests_bloc.dart';
// import '../widgets/past_service_record_card.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class PastRequestsScreen extends StatefulWidget {
//   const PastRequestsScreen({super.key});

//   @override
//   State<PastRequestsScreen> createState() => _PastRequestsScreenState();
// }

// class _PastRequestsScreenState extends State<PastRequestsScreen> {
//   final _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }

//   @override
//   void dispose() {
//     _scrollController
//       ..removeListener(_onScroll)
//       ..dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     final maxScroll = _scrollController.position.maxScrollExtent;
//     final currentScroll = _scrollController.offset;
//     if (currentScroll >= (maxScroll * 0.9)) {
//       context.read<UserHistoryRequestsBloc>().add(GetUserPastRequestsEvent());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: BlocBuilder<UserHistoryRequestsBloc, UserHistoryRequestsState>(
//         builder: (context, state) {
//           switch (state.status) {
//             case UserPastRequestsStatus.loading:
//               return const LoadingWidget();
//             case UserPastRequestsStatus.success:
//               if (state.data.isEmpty) {
//                 return Center(
//                   child: Text(AppLocalizations.of(context)!.noPastServicesYet),
//                 );
//               }
//               return ListView.separated(
//                 separatorBuilder: (context, index) => const SizedBox(
//                   height: 16,
//                 ),
//                 controller: _scrollController,
//                 itemCount: state.hasReachedMax
//                     ? state.data.length
//                     : state.data.length + 1,
//                 itemBuilder: (BuildContext context, int index) {
//                   return index >= state.data.length
//                       ? const LoadingWidget()
//                       : PastServiceRecordCard(
//                           past: state.data[index],
//                         );
//                 },
//               );
//             case UserPastRequestsStatus.error:
//               return NetworkErrorWidget(
//                 message: state.errorMessage,
//                 onPressed: () {
//                   context
//                       .read<UserHistoryRequestsBloc>()
//                       .add(GetUserPastRequestsEvent(refresh: true));
//                 },
//               );
//             case UserPastRequestsStatus.offline:
//               return NoConnectionWidget(
//                 onPressed: () {
//                   context
//                       .read<UserHistoryRequestsBloc>()
//                       .add(GetUserPastRequestsEvent(refresh: true));
//                 },
//               );
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../bloc/user_history_requests_bloc.dart';
import '../widgets/past_service_record_card.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PastRequestsScreen extends StatefulWidget {
  const PastRequestsScreen({super.key});

  @override
  State<PastRequestsScreen> createState() => _PastRequestsScreenState();
}

class _PastRequestsScreenState extends State<PastRequestsScreen> {
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
      context.read<UserHistoryRequestsBloc>().add(GetUserPastRequestsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<UserHistoryRequestsBloc, UserHistoryRequestsState>(
        builder: (context, state) {
          switch (state.status) {
            case UserPastRequestsStatus.loading:
              return const LoadingWidget();
            case UserPastRequestsStatus.success:
            case UserPastRequestsStatus.loadingMore:
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
                      ? state.status == UserPastRequestsStatus.success
                          ? TextButton(
                              onPressed: () {
                                context
                                    .read<UserHistoryRequestsBloc>()
                                    .add(GetUserPastRequestsEvent());
                              },
                              child: Text('Load More',style: TextStyle(fontSize: 14),))
                          : const LoadingWidget()
                      : PastServiceRecordCard(
                          past: state.data[index],
                        );
                },
              );
            case UserPastRequestsStatus.error:
              return NetworkErrorWidget(
                message: state.errorMessage,
                onPressed: () {
                  context
                      .read<UserHistoryRequestsBloc>()
                      .add(GetUserPastRequestsEvent(refresh: true));
                },
              );
            case UserPastRequestsStatus.offline:
              return NoConnectionWidget(
                onPressed: () {
                  context
                      .read<UserHistoryRequestsBloc>()
                      .add(GetUserPastRequestsEvent(refresh: true));
                },
              );
          }
        },
      ),
    );
  }
}
