import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/core/ui/widgets/loading_widget.dart';
import 'package:masbar/core/ui/widgets/no_connection_widget.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';
import 'package:masbar/features/user/notification_settings/data/data_sources/notification_settings_data_source.dart';
import 'package:masbar/features/user/notification_settings/data/repositories/notification_settings_repo_impl.dart';
import 'package:masbar/features/user/notification_settings/domain/use_cases/get_notification_settings_use_case.dart';

import '../../../../../core/ui/widgets/error_widget.dart';
import '../../domain/use_cases/set_notification_settings_use_case.dart';
import '../bloc/get_notification_settings_bloc.dart';
import '../bloc/set_notification_settings_bloc.dart';
import '../widgets/edit_notification_settings_widget.dart';
import '../widgets/notification_settings_widget.dart';

class UserNotificationSettingsScreen extends StatefulWidget {
  static const routeName = 'user_notification_settings_screen';
  const UserNotificationSettingsScreen({super.key});

  @override
  State<UserNotificationSettingsScreen> createState() =>
      _UserNotificationSettingsScreenState();
}

class _UserNotificationSettingsScreenState
    extends State<UserNotificationSettingsScreen> {
  bool isEditing = false;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getBloc(),
        ),
        BlocProvider(
          create: (context) => _getSetSettingsBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return BlocListener<SetNotificationSettingsBloc,
        SetNotificationSettingsState>(
          listener: (context, state) {
         if(state is SetNotificationSettingsOfflineState){
          ToastUtils.showErrorToastMessage('No internet Connection');
         }else if(state is SetNotificationSettingsErrorState){
          ToastUtils.showErrorToastMessage('${state.message}\n try agian');
         }else if(state is LoadedSetNotificationSettings){
          ToastUtils.showSusToastMessage('Updated Successfully');
          setState(() {
            isEditing=false;
          });
            BlocProvider.of<GetNotificationSettingsBloc>(context)
              .add(FetchNotificationSettingsEvent());
         }
          },
          child: Scaffold(
            appBar: _buildAppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(
                  16,
                ),
                child: BlocBuilder<GetNotificationSettingsBloc,
                    GetNotificationSettingsState>(
                  builder: (context, state) {
                    if (state is LoadingGetNotificationSettings) {
                      return _buildLoading();
                    } else if (state is GetNotificationSettingsOfflineState) {
                      return _buildOffline(context);
                    } else if (state is GetNotificationSettingsErrorState) {
                      return _buildNeteworkError(state, context);
                    } else if (state is LoadedGetNotificationSettings) {
                      return isEditing
                          ? EditNotificationSettingsWidget(data: state.data)
                          : NotificationSettingsWidget(data: state.data);
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        isEditing ? 'Edit Notification Settings' : 'Notification Settings',
      ),
      actions: [
        if (!isEditing)
          IconButton(
            onPressed: () {
              setState(() {
                isEditing = true;
              });
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
        if (isEditing)
          IconButton(
            onPressed: () {
              setState(() {
                isEditing = false;
              });
            },
            icon: const Icon(
              Icons.close,
            ),
          )
      ],
    );
  }

  Center _buildNeteworkError(
      GetNotificationSettingsErrorState state, BuildContext context) {
    return Center(
      child: NetworkErrorWidget(
        message: state.message,
        onPressed: () {
          BlocProvider.of<GetNotificationSettingsBloc>(context)
              .add(FetchNotificationSettingsEvent());
        },
      ),
    );
  }

  Center _buildOffline(BuildContext context) {
    return Center(
      child: NoConnectionWidget(onPressed: () {
        BlocProvider.of<GetNotificationSettingsBloc>(context)
            .add(FetchNotificationSettingsEvent());
      }),
    );
  }

  Center _buildLoading() {
    return const Center(child: LoadingWidget());
  }

  GetNotificationSettingsBloc _getBloc() {
    return GetNotificationSettingsBloc(
      getNotificationSettingsUseCase: GetNotificationSettingsUseCase(
        notificationSettingsRepo: NotificationSettingsRepoImpl(
          dataSource: NotificationSettingsDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(FetchNotificationSettingsEvent());
  }

  SetNotificationSettingsBloc _getSetSettingsBloc() {
    return SetNotificationSettingsBloc(
      setNotificationSettingsUseCase: SetNotificationSettingsUseCase(
        notificationSettingsRepo: NotificationSettingsRepoImpl(
          dataSource: NotificationSettingsDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }
}
