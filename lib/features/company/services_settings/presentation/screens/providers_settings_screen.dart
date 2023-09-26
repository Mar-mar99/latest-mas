// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/ui/dialogs/loading_dialog.dart';
import 'package:masbar/core/ui/widgets/app_dialog.dart';
import 'package:masbar/core/utils/helpers/snackbar.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../company_services/domain/entities/company_service_entity.dart';
import '../../data/data_sources/services_remote_data_source.dart';
import '../../data/repositories/services_repo_impl.dart';
import '../../domain/entities/company_provider_entity.dart';
import '../../domain/use_cases/assign_provider_use_case.dart';
import '../../domain/use_cases/get_providers_use_case.dart';
import '../../domain/use_cases/get_service_assigned_providers.dart';
import '../../domain/use_cases/remove_provider_use_case.dart';
import '../bloc/assign_provider_bloc.dart';
import '../bloc/get_assigned_providers_bloc.dart';
import '../bloc/remove_provider_bloc.dart';
import '../widgets/autocomplete_provider.dart';

class AssignProviderToServiceScreen extends StatelessWidget {
  final CompanyServiceEntity service;
  static const routeName = 'provider_settings_screen';
  const AssignProviderToServiceScreen({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getAssignedBloc(),
        ),
        BlocProvider(
          create: (context) => _getAssignBloc(),
        ),
        BlocProvider(
          create: (context) => _removeBloc(),
        )
      ],
      child: Builder(builder: (context) {
        return MultiBlocListener(
          listeners: [
            BlocListener<AssignProviderBloc, AssignProviderState>(
              listener: (context, state) {
                _buildAssignListener(state, context);
              },
            ),
            BlocListener<RemoveProviderBloc, RemoveProviderState>(
              listener: (context, state) {
                _buildRemoveListener(state, context);
              },
            ),
          ],
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.service_mapping),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<GetAssignedProvidersBloc,
                  GetAssignedProvidersState>(
                builder: (context, state) {
                  if (state is LoadingGetAssignedProvidersInfoState) {
                    return _buildLoadingState();
                  } else if (state is GetAssignedProvidersInfoOfflineState) {
                    return _buildNoConnectionState(context);
                  } else if (state is GetAssignedProvidersNetworkErrorState) {
                    return _buildNetworkErrorState(state, context);
                  } else if (state is LoadedGetAssignedProvidersInfoState) {
                    return _buildData(context,state);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        );
      }),
    );
  }

  void _buildAssignListener(AssignProviderState state, BuildContext context) {
     if (state is LoadingAssignProvider) {
      showLoadingDialog(context, text: 'assigning...');
    } else if (state is AssignProviderOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internt Connection');
    } else if (state is AssignProviderNetworkErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage(
          'An error has occurred,\n ${state.message}\n try again');
    } else if (state is LoadedAssignProvider) {
      Navigator.pop(context);
      ToastUtils.showSusToastMessage('Assigned Successfully');
      BlocProvider.of<GetAssignedProvidersBloc>(context).add(
          GetAssignedProvidersAndAllProviders(
              serviceId: service.id));
    }
  }

  void _buildRemoveListener(RemoveProviderState state, BuildContext context) {
     if (state is LoadingRemoveProvider) {
      showLoadingDialog(context, text: 'removing...');
    } else if (state is RemoveProviderOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internt Connection');
    } else if (state is RemoveProviderNetworkErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage(
          'An error has occurred,\n ${state.message}\n try again');
    } else if (state is LoadedRemoveProvider) {
      Navigator.pop(context);
      ToastUtils.showSusToastMessage('Removed Successfully');
      BlocProvider.of<GetAssignedProvidersBloc>(context).add(
          GetAssignedProvidersAndAllProviders(
              serviceId: service.id));
    }
  }

  CustomScrollView _buildData(BuildContext context, LoadedGetAssignedProvidersInfoState state) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Text(
            '${service.name} - ${AppLocalizations.of(context)!.providers}',
            style: TextStyle(fontSize: 18),
          ),
        ),
        SliverToBoxAdapter(
          child: Text(
            '${AppLocalizations.of(context)!.type_provider_name_to_assign}:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: AutocompleteProvider(
            providers: state.allProviders,
            serviceId: service.id,
          ),
        ),
        SliverToBoxAdapter(
          child: const SizedBox(
            height: 24,
          ),
        ),
        SliverToBoxAdapter(
          child: const Divider(
            height: 8,
          ),
        ),
        SliverToBoxAdapter(
          child: const SizedBox(
            height: 24,
          ),
        ),
        SliverToBoxAdapter(child: Text(AppLocalizations.of(context)!.assigned_providers)),
        SliverToBoxAdapter(
          child: Text('(${AppLocalizations.of(context)!.count_provider_assigned(state.assignedProviders.length)})',

              style: const TextStyle(fontSize: 14, color: Colors.blue,),),),

        SliverToBoxAdapter(
          child: const SizedBox(
            height: 8,
          ),
        ),
        SliverList.builder(
          itemCount: state.assignedProviders.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) {
                return _showRemoveDialog(context, state, index);
              },
              onDismissed: (direction) {
                showSnackbar(context, AppLocalizations.of(context)!.deleted);
              },
              child: Card(
                margin: const EdgeInsets.all(0),
                elevation: 1,
                child: ListTile(
                  title: Text(state.assignedProviders[index].name),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<bool?> _showRemoveDialog(BuildContext context,
      LoadedGetAssignedProvidersInfoState state, int index) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return DialogItem(
          title: AppLocalizations.of(context)!.remove_confirmation,
          paragraph: AppLocalizations.of(context)!.are_you_sure_you_want_to_remove_this_provider,
          nextButtonText: AppLocalizations.of(context)!.yes,
          cancelButtonText: AppLocalizations.of(context)!.cancel,
          cancelButtonFunction: () {
            Navigator.pop(context);
          },
          nextButtonFunction: () {
            BlocProvider.of<RemoveProviderBloc>(context).add(
              RemoveProviderFromServiceEvent(
                serviceId: service.id,
                providerId: state.assignedProviders[index].id,
              ),
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  RemoveProviderBloc _removeBloc() {
    return RemoveProviderBloc(
        removeProviderUseCase: RemoveProviderUseCase(
      servicesRepo: ServicesRepoImpl(
        servicesRemoteDataSource:
            ServicesRemoteDataSourceWithHttp(client: NetworkServiceHttp()),
      ),
    ));
  }

  AssignProviderBloc _getAssignBloc() {
    return AssignProviderBloc(
        assignProviderUseCase: AssignProviderUseCase(
      servicesRepo: ServicesRepoImpl(
        servicesRemoteDataSource:
            ServicesRemoteDataSourceWithHttp(client: NetworkServiceHttp()),
      ),
    ));
  }

  GetAssignedProvidersBloc _getAssignedBloc() {
    return GetAssignedProvidersBloc(
      getServiceAssignedProviderUseCase: GetServiceAssignedProviderUseCase(
        servicesRepo: ServicesRepoImpl(
          servicesRemoteDataSource:
              ServicesRemoteDataSourceWithHttp(client: NetworkServiceHttp()),
        ),
      ),
      getProvidersUseCase: GetProvidersUseCase(
        servicesRepo: ServicesRepoImpl(
          servicesRemoteDataSource:
              ServicesRemoteDataSourceWithHttp(client: NetworkServiceHttp()),
        ),
      ),
    )..add(GetAssignedProvidersAndAllProviders(serviceId: service.id));
  }

  NetworkErrorWidget _buildNetworkErrorState(
      GetAssignedProvidersNetworkErrorState state, BuildContext context) {
    return NetworkErrorWidget(
      message: state.message,
      onPressed: () {
        BlocProvider.of<GetAssignedProvidersBloc>(context)
            .add(GetAssignedProvidersAndAllProviders(serviceId: service.id));
      },
    );
  }

  NoConnectionWidget _buildNoConnectionState(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<GetAssignedProvidersBloc>(context)
            .add(GetAssignedProvidersAndAllProviders(serviceId: service.id));
      },
    );
  }

  LoadingWidget _buildLoadingState() {
    return const LoadingWidget();
  }
}
