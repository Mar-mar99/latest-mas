import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/features/user/services/presentation/request_service/user_choosen/widgets/step3/provider_card.dart';
import 'package:masbar/features/user/services/presentation/request_service/user_choosen/widgets/step3/selected_data_card.dart';
import '../../../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../../../../core/utils/enums/enums.dart';
import '../../../../../../../../core/utils/helpers/helpers.dart';
import '../../../../../data/data_source/explore_services_data_source.dart';
import '../../../../../data/repositories/explore_services_repo_impl.dart';
import '../../../../../domain/entities/service_info_entity.dart';
import '../../../../../domain/entities/service_provider_entity.dart';
import '../../../../../domain/use_cases/get_service_providers_use_case.dart';
import '../../bloc/search_providers_bloc.dart';
import '../../bloc/user_create_request_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class UserRequestStep3 extends StatelessWidget {
  final ServiceInfoEntity serviceInfoEntity;
  final Function changeCurrentTab;
  const UserRequestStep3({
    Key? key,
    required this.serviceInfoEntity,
    required this.changeCurrentTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getSearchBloc(context),
      child: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SelectedDataCard(serviceInfoEntity: serviceInfoEntity),
                const SizedBox(height: 8),
                BlocConsumer<SearchProvidersBloc, SearchProvidersState>(
                  listener: (context, state) {
                    if (state is LoadedSearchProviders) {
                      BlocProvider.of<UserCreateRequestBloc>(context)
                          .add(RequestIdChangedEvent(id: state.requestId));
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingSearchProviders) {
                      return _buildLoading();
                    } else if (state is SearchProvidersOfflineState) {
                      return _buildOffline(context);
                    } else if (state is SearchProvidersErrorState) {
                      return _buildNetworkError(state, context);
                    } else if (state is LoadedSearchProviders) {
                      return Column(
                        children: [
                          _buildOnlineProviders(state.online),
                          _buildBusyProviders(state.busy),
                          _buildOfflineProviders(state.offline)
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  SearchProvidersBloc _getSearchBloc(BuildContext context) {
    return SearchProvidersBloc(
      getServiceProvidersUseCase: GetServiceProvidersUseCase(
        exploreServicesRepo: ExploreServicesRepoImpl(
          exploreServicesDataSource: ExploreServicesDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(
        _serachEvent(context),
      );
  }

  NetworkErrorWidget _buildNetworkError(
      SearchProvidersErrorState state, BuildContext context) {
    return NetworkErrorWidget(
      message: state.message,
      onPressed: () {
        _serachProviderRequest(context);
      },
    );
  }

  NoConnectionWidget _buildOffline(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        _serachProviderRequest(context);
      },
    );
  }

  LoadingWidget _buildLoading() {
    return const LoadingWidget();
  }

  ExpansionTile _buildOnlineProviders(List<ServiceProviderEntity> online) {
    return ExpansionTile(
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: const Icon(
          Icons.online_prediction,
          color: Colors.green,
        ),
        collapsedIconColor: Colors.green,
        trailing: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.green,
        ),
        title: Text(
          'Online (${online.length} providers)',
          style:
              const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        children: [
          online.isEmpty
              ? _buildEmptyProviders('No Online Providers')
              : Container(
                  height: 300,
                  child: MasonryGridView.builder(
                    gridDelegate:
                        const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                    ),
                    itemCount: online.length,
                    itemBuilder: (context, index) {
                      return ProviderCard(
                        key: UniqueKey(),
                        providerStatus: ProviderStatus.online,
                        provider: online[index],
                        changeCurrentTab: () {
                          changeCurrentTab(3);
                        },
                      );
                    },
                  ))
        ]);
  }

  ExpansionTile _buildBusyProviders(List<ServiceProviderEntity> busy) {
    return ExpansionTile(
        leading: const Icon(
          Icons.punch_clock,
          color: Colors.red,
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.red,
        ),
        collapsedIconColor: Colors.red,
        title: Text('Busy (${busy.length} providers)',
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold)),
        children: [
          busy.isEmpty
              ? _buildEmptyProviders('No Busy Providers')
              : Container(
                  height: 300,
                  child: MasonryGridView.builder(
                    gridDelegate:
                        const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                    ),
                    itemCount: busy.length,
                    itemBuilder: (context, index) {
                      return ProviderCard(
                          key: UniqueKey(),
                          providerStatus: ProviderStatus.busy,
                          provider: busy[index],
                          changeCurrentTab: () {
                            changeCurrentTab(3);
                          });
                    },
                  ),
                )
        ]);
  }

  ExpansionTile _buildOfflineProviders(List<ServiceProviderEntity> offline) {
    return ExpansionTile(
        leading: const Icon(
          Icons.portable_wifi_off,
          color: Colors.black,
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black,
        ),
        collapsedIconColor: Colors.black,
        title: Text('Offline (${offline.length} providers)',
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        children: [
          offline.isEmpty
              ? _buildEmptyProviders('No Offline Providers')
              : Container(
                  height: 300,
                  child: MasonryGridView.builder(
                    gridDelegate:
                        const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                    ),
                    itemCount: offline.length,
                    itemBuilder: (context, index) {
                      return ProviderCard(
                          key: UniqueKey(),
                          provider: offline[index],
                          providerStatus: ProviderStatus.offline,
                          changeCurrentTab: () {
                            changeCurrentTab(3);
                          });
                    },
                  ))
        ]);
  }

  Padding _buildEmptyProviders(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _serachProviderRequest(BuildContext context) {
    BlocProvider.of<SearchProvidersBloc>(context).add(_serachEvent(context));
  }

  GetProvidersEvent _serachEvent(BuildContext context) {
    return GetProvidersEvent(
        state: context.read<UserCreateRequestBloc>().state.stateId,
        serviceType: context.read<UserCreateRequestBloc>().state.serviceType,
        paymentStatus:
            context.read<UserCreateRequestBloc>().state.paymentStatus,
        paymentMethod:
            context.read<UserCreateRequestBloc>().state.paymentMethod!,
        distance: context.read<UserCreateRequestBloc>().state.distance.toInt(),
        address: context.read<UserCreateRequestBloc>().state.address,
        lat: context.read<UserCreateRequestBloc>().state.latitude,
        lng: context.read<UserCreateRequestBloc>().state.longitude,
        images: context.read<UserCreateRequestBloc>().state.images,
        notes: context.read<UserCreateRequestBloc>().state.note,
        promoCode: context.read<UserCreateRequestBloc>().state.withPromo
            ? context.read<UserCreateRequestBloc>().state.promoCode != null
                ? context
                    .read<UserCreateRequestBloc>()
                    .state
                    .promoCode!
                    .promoCodeId
                    .toString()
                : null
            : null,
        scheduleDate: context.read<UserCreateRequestBloc>().state.scheduleDate,
        scheduleTime: context.read<UserCreateRequestBloc>().state.scheduleTime,
        selectedAttributes:
            context.read<UserCreateRequestBloc>().state.selectedAttributes);
  }
}
