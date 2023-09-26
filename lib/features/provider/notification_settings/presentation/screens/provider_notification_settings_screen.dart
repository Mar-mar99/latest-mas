import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';

import '../../../../../core/ui/widgets/error_widget.dart';
import '../../data/data_sources/provider_notification_settings_data_source.dart';
import '../../data/repositories/provider_notification_settings_repo_impl.dart';
import '../../domain/use_cases/get_provider_notification_settings_use_case.dart';
import '../../domain/use_cases/set_provider_notification_settings_use_case.dart';
import '../bloc/get_provider_notification_settings_bloc.dart';
import '../bloc/set_provider_notification_settings_bloc.dart';
import '../widgets/edit_provider_notification_settings_widget.dart';
import '../widgets/provider_notification_settings_widget.dart';

class ProviderNotificationSettingsScreen extends StatefulWidget {
  static const routeName = 'provider_notification_settings_screen';
  const ProviderNotificationSettingsScreen({super.key});

  @override
  State<ProviderNotificationSettingsScreen> createState() =>
      _ProviderNotificationSettingsScreenState();
}

class _ProviderNotificationSettingsScreenState
    extends State<ProviderNotificationSettingsScreen> {
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
        return BlocListener<SetProviderNotificationSettingsBloc,
        SetProviderNotificationSettingsState>(
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
            BlocProvider.of<GetProviderNotificationSettingsBloc>(context)
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
                child: BlocBuilder<GetProviderNotificationSettingsBloc,
                    GetProviderNotificationSettingsState>(
                  builder: (context, state) {
                    if (state is LoadingGetNotificationSettings) {
                      return _buildLoading();
                    } else if (state is GetNotificationSettingsOfflineState) {
                      return _buildOffline(context);
                    } else if (state is GetNotificationSettingsErrorState) {
                      return _buildNeteworkError(state, context);
                    } else if (state is LoadedGetNotificationSettings) {
                      return isEditing
                          ? EditProviderNotificationSettingsWidget(data: state.data)
                          : ProviderNotificationSettingsWidget(data: state.data);
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
          BlocProvider.of<GetProviderNotificationSettingsBloc>(context)
              .add(FetchNotificationSettingsEvent());
        },
      ),
    );
  }

  Center _buildOffline(BuildContext context) {
    return Center(
      child: NoConnectionWidget(onPressed: () {
        BlocProvider.of<GetProviderNotificationSettingsBloc>(context)
            .add(FetchNotificationSettingsEvent());
      }),
    );
  }

  Center _buildLoading() {
    return const Center(child: LoadingWidget());
  }

  GetProviderNotificationSettingsBloc _getBloc() {
    return GetProviderNotificationSettingsBloc(
      getNotificationSettingsUseCase: GetProviderNotificationSettingsUseCase(
        notificationSettingsRepo: ProviderNotificationSettingsRepoImpl(
          dataSource: ProviderNotificationSettingsDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(FetchNotificationSettingsEvent());
  }

  SetProviderNotificationSettingsBloc _getSetSettingsBloc() {
    return SetProviderNotificationSettingsBloc(
      setNotificationSettingsUseCase: SetProviderNotificationSettingsUseCase(
        notificationSettingsRepo: ProviderNotificationSettingsRepoImpl(
          dataSource: ProviderNotificationSettingsDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }
}
