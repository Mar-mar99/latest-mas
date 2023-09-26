// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:masbar/core/ui/widgets/app_button.dart';
import 'package:masbar/core/ui/widgets/app_switch.dart';
import 'package:masbar/core/ui/widgets/app_textfield.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';

import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../company_services/domain/entities/company_service_entity.dart';
import '../../data/data_sources/services_remote_data_source.dart';
import '../../data/repositories/services_repo_impl.dart';
import '../../domain/use_cases/get_cancellation_use_case.dart';
import '../../domain/use_cases/set_cancellation_use_case.dart';
import '../bloc/get_cancellation_bloc.dart';
import '../bloc/set_cancellation_bloc.dart';
import '../widgets/cancellation_data.dart';

class CancelationSettings extends StatelessWidget {
  final CompanyServiceEntity companyServiceEntity;
  static const routeName = 'cancelation_settings_screen';
  const CancelationSettings({
    Key? key,
    required this.companyServiceEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getCancellationBloc(),
        ),
        BlocProvider(
          create: (context) => _getSetBloc(),
        ),
      ],
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.cancelation_settings,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: BlocListener<SetCancellationBloc, SetCancellationState>(
                listener: (context, state) {
                  _buildSetListener(state, context);
                },
                child: BlocBuilder<GetCancellationBloc, GetCancellationState>(
                  builder: (context, state) {
                    if (state is LoadingGetCancellation) {
                      return _buildLoadingState();
                    } else if (state is GetCancellationOfflineState) {
                      return _buildNoConnectionState(context);
                    } else if (state is GetCancellationNetworkErrorState) {
                      return _buildNetworkErrorState(state, context);
                    } else if (state is LoadedGetCancellation) {
                      return _buildData(context, state);
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          )),
    );
  }

  void _buildSetListener(SetCancellationState state, BuildContext context) {
    if (state is SetCancellationOfflineState) {
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state is SetCancellationNetworkErrorState) {
      ToastUtils.showErrorToastMessage(
          'An error occured, try again\n ${state.message}');
    } else if (state is LoadedSetCancellation) {
      ToastUtils.showSusToastMessage('Updated Successfully');
      BlocProvider.of<GetCancellationBloc>(context)
          .add(GetCancellationSettings(serviceId: companyServiceEntity.id));
    }
  }

  Widget _buildData(BuildContext context, LoadedGetCancellation state) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height -(
              MediaQuery.of(context).viewPadding.top +
              MediaQuery.of(context).viewPadding.bottom +
              MediaQuery.of(context).viewInsets.top +
              MediaQuery.of(context).viewInsets.bottom+
              kToolbarHeight+32
          )-50
              ,
          child: CancellationData(
            isEnabled: state.data.hasCancellationFees,
            fee: state.data.fees,
            serviceId: companyServiceEntity.id,
          ),
        ),
      ],
    );
  }

  SetCancellationBloc _getSetBloc() {
    return SetCancellationBloc(
        setCancellationUseCase: SetCancellationUseCase(
      servicesRepo: ServicesRepoImpl(
        servicesRemoteDataSource:
            ServicesRemoteDataSourceWithHttp(client: NetworkServiceHttp()),
      ),
    ));
  }

  NetworkErrorWidget _buildNetworkErrorState(
      GetCancellationNetworkErrorState state, BuildContext context) {
    return NetworkErrorWidget(
      message: state.message,
      onPressed: () {
        BlocProvider.of<GetCancellationBloc>(context)
            .add(GetCancellationSettings(serviceId: companyServiceEntity.id));
      },
    );
  }

  NoConnectionWidget _buildNoConnectionState(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<GetCancellationBloc>(context)
            .add(GetCancellationSettings(serviceId: companyServiceEntity.id));
      },
    );
  }

  LoadingWidget _buildLoadingState() {
    return const LoadingWidget();
  }

  GetCancellationBloc _getCancellationBloc() {
    return GetCancellationBloc(
        getCancellationUseCase: GetCancellationUseCase(
      servicesRepo: ServicesRepoImpl(
        servicesRemoteDataSource:
            ServicesRemoteDataSourceWithHttp(client: NetworkServiceHttp()),
      ),
    ))
      ..add(GetCancellationSettings(serviceId: companyServiceEntity.id));
  }
}
