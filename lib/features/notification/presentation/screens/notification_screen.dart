import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import 'package:masbar/features/notification/domain/use_case/delete_notification_use_case.dart';

import '../../../../core/api_service/network_service_http.dart';
import '../../../../core/ui/widgets/app_text.dart';
import '../../../../core/ui/widgets/error_widget.dart';
import '../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../core/ui/widgets/loading_widget.dart';
import '../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../core/utils/helpers/helpers.dart';
import '../../data/data_source/notification_data_source.dart';
import '../../data/repositories/notification_repo_impl.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/use_case/get_notification_use_case.dart';
import '../bloc/delete_notification_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  final TypeAuth typeAuth;
  const NotificationScreen({
    Key? key,
    required this.typeAuth,
  }) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  //   print('init');
  //   _scrollController.addListener(_onScroll);
   BlocProvider.of<NotificationBloc>(context).add(LoadNotificationEvent(typeAuth: widget.typeAuth,refresh: true));
   }

  @override
  void dispose() {print('dispose');
    // _scrollController
    //   ..removeListener(_onScroll)
    //   ..dispose();

    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<NotificationBloc>().add(
            LoadNotificationEvent(
              typeAuth: widget.typeAuth,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => _getDeleteBloc(context),
          ),
        ],
        child: Builder(builder: (context) {
          return BlocListener<DeleteNotificationBloc, DeleteNotificationState>(
              listener: (context, state) {
                _buildListener(state, context);
              },
              child: widget.typeAuth == TypeAuth.company
                  ? _buildEmptyNotification(context)
                  : _buildNotification());
        }));
  }

  void _buildListener(DeleteNotificationState state, BuildContext context) {
    if (state is LoadingDeleteNotificationn) {
      showLoadingDialog(context);
    } else if (state is DeleteNotificationOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state is DeleteNotificationErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage((state).message);
    } else if (state is DoneDeleteNotification) {
      ToastUtils.showSusToastMessage(
          'Notification has been deleted Successfully');
      Navigator.pop(context);

      BlocProvider.of<NotificationBloc>(context)
          .add(LoadNotificationEvent(typeAuth: widget.typeAuth,refresh:true));
    }
  }

  Widget _buildNotification() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Scaffold(
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            switch (state.status) {
              case NotificationStatus.loading:
                return const LoadingWidget();
              case NotificationStatus.success:
                case NotificationStatus.loadingMore:
                if (state.data.isEmpty) {
                  return _buildEmptyNotification(context);
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
                        ? state.status == NotificationStatus.success
                          ? TextButton(
                              onPressed: () {
                                context
                                    .read<NotificationBloc>()
                                    .add(LoadNotificationEvent(typeAuth:widget.typeAuth ));
                              },
                              child: Text('Load More',style: TextStyle(fontSize: 14),))
                          : const LoadingWidget()
                        : NotificationCard(
                            type: state.data[index].type!,
                            notification: state.data[index],
                          );
                  },
                );
              case NotificationStatus.offline:
                return NetworkErrorWidget(
                  message: state.errorMessage,
                  onPressed: () {
                    BlocProvider.of<NotificationBloc>(context)
                        .add(LoadNotificationEvent(typeAuth: widget.typeAuth));
                  },
                );
              case NotificationStatus.error:
                return NoConnectionWidget(
                  onPressed: () {
                    BlocProvider.of<NotificationBloc>(context)
                        .add(LoadNotificationEvent(typeAuth: widget.typeAuth));
                  },
                );
            }
          },
        ),
      ),
    );
  }

  DeleteNotificationBloc _getDeleteBloc(BuildContext context) {
    return DeleteNotificationBloc(
      deleteNotificationUseCase: DeleteNotificationUseCase(
        notificationRepo: NotificationRepoImpl(
          notificationDataSource: NotificationDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  Center _buildEmptyNotification(BuildContext context) {
    return Center(
        heightFactor: 1.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Image.asset('assets/images/logo.jpg'),
            ),
            const SizedBox(height: 16.0),
            AppText(
              AppLocalizations.of(context)?.noNotificationYet ?? "",
              textAlign: TextAlign.center,
            )
          ],
        ));
  }
}
