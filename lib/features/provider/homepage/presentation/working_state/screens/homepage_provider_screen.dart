// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:masbar/core/ui/dialogs/loading_dialog.dart';
// import 'package:masbar/features/provider/homepage/presentation/active_request/screens/active_request_screen.dart';
// import 'package:masbar/features/provider/homepage/presentation/working_state/screens/provider_working_screen.dart';

// import '../../../../../../core/api_service/network_api_service_http.dart';
// import '../../../../../../core/ui/widgets/error_widget.dart';
// import '../../../../../../core/ui/widgets/loading_widget.dart';
// import '../../../../../../core/ui/widgets/no_connection_widget.dart';
// import '../../../../../../core/utils/helpers/helpers.dart';
// import '../../../data/date_source/provider_data_source.dart';
// import '../../../data/repositories/provider_repo_impl.dart';
// import '../../../domain/use_cases/arrived_use_case.dart';
// import '../../../domain/use_cases/cancel_after_request_use_case.dart';
// import '../../../domain/use_cases/get_current_request_use_case.dart';
// import '../../../domain/use_cases/start_working_use_case.dart';
// import '../../active_request/bloc/arrived_bloc.dart';
// import '../../active_request/bloc/cancel_after_accept_bloc.dart';
// import '../../active_request/bloc/current_request_bloc.dart';
// import '../../active_request/bloc/start_bloc.dart';

// class HomePageProviderScreen extends StatelessWidget {
//   static const routeName = 'home_page_provider_screen';
//   const HomePageProviderScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => _getCurrentBloc(),
//         ),
//         BlocProvider(
//           create: (context) => _getArrivedBloc(),
//         ),
//         BlocProvider(
//           create: (context) => _getCancelAfterAcceptBloc(),
//         ),
//         BlocProvider(
//           create: (context) => _getStartBloc(),
//         ),
//       ],
//       child: BlocConsumer<CurrentRequestBloc, CurrentRequestState>(
//           listener: (context, state) {
//         _buildListener(state, context);
//       }, builder: (context, state) {
//         if (state is LoadingCurrentRequest) {
//           return _buildLoading();
//         } else if (state is CurrentRequestOfflineState) {
//           return _buildNoInternet(context);
//         } else if (state is CurrentRequestErrorState) {
//           return _buildError(context);
//         } else if (state is LoadedCurrentRequest) {
//           return _buildLoadedBody(state);
//         } else if (state is RefreshedCurrentRequest) {
//           return _buildRefreshedBody(state);
//         } else {
//           return _buildLoading();
//         }
//       }),
//     );
//   }

//   void _buildListener(CurrentRequestState state, BuildContext context) {
//     if (state is RefreshingCurrentRequest) {
//       showLoadingDialog(context, text: 'Refreshing...');
//     } else if (state is RefreshedCurrentRequest) {
//       if (Helpers.isThereCurrentDialogShowing(context)) {
//         Navigator.pop(context);
//       }
//     } else if (state is CurrentRequestOfflineState) {
//       if (Helpers.isThereCurrentDialogShowing(context)) {
//         Navigator.pop(context);
//       }
//     } else if (state is CurrentRequestErrorState) {
//       if (Helpers.isThereCurrentDialogShowing(context)) {
//         Navigator.pop(context);
//       }
//     }
//   }

//   Widget _buildRefreshedBody(RefreshedCurrentRequest state) {
//     return state.hasCurrent
//         ? ActiveRequestScreen(
//           requestId: state.data!.id!,

//           )
//         : const ProviderWorkingScreen();
//   }



//   StartBloc _getStartBloc() {
//     return StartBloc(
//         startWorkingUseCase: StartWorkingUseCase(
//       providerRepo: ProviderRepoImpl(
//         providerDataSource: ProviderDataSourceWithHttp(
//           client: NetworkApiServiceHttp(),
//         ),
//       ),
//     ));
//   }

//   CancelAfterAcceptBloc _getCancelAfterAcceptBloc() {
//     return CancelAfterAcceptBloc(
//       cancelAfterRequestUseCase: CancelAfterRequestUseCase(
//         providerRepo: ProviderRepoImpl(
//           providerDataSource: ProviderDataSourceWithHttp(
//             client: NetworkApiServiceHttp(),
//           ),
//         ),
//       ),
//     );
//   }



//   ArrivedBloc _getArrivedBloc() {
//     return ArrivedBloc(
//       arrivedUseCase: ArrivedUseCase(
//         providerRepo: ProviderRepoImpl(
//           providerDataSource: ProviderDataSourceWithHttp(
//             client: NetworkApiServiceHttp(),
//           ),
//         ),
//       ),
//     );
//   }
// }
