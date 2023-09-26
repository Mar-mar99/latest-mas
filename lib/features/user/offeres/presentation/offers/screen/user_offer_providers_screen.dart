// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../favorites/data/data_source/favorite_data_source.dart';
import '../../../../favorites/data/repositories/favorites_repo_impl.dart';
import '../../../../favorites/domain/use_cases/delete_fav_use_case.dart';
import '../../../../favorites/domain/use_cases/save_fav_use_case.dart';
import '../../../../favorites/presentation/fav/bloc/add_fav_bloc.dart';
import '../../../../favorites/presentation/fav/bloc/remove_fav_bloc.dart';
import '../../../data/data_source/offers_data_source.dart';
import '../../../data/repositories/offers_repo_impl.dart';
import '../../../domain/entities/offer_service_entity.dart';
import '../../../domain/use_cases/get_promos_providers_use_case.dart';
import '../bloc/get_promos_providers_bloc.dart';
import '../widgets/user_promo_provider_card.dart';

class UserOfferProvidersScreen extends StatelessWidget {
  static const routeName = 'user_offer_providers_screen';

  final OfferServiceEntity offerServiceEntity;
  const UserOfferProvidersScreen({
    Key? key,
    required this.offerServiceEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getBloc(),
        ),
        BlocProvider(
          create: (context) => _getSaveFavBloc(),
        ),
        BlocProvider(
          create: (context) => _buildRemoveFav(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Services'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(
              16,
            ),
            child: BlocBuilder<GetPromosProvidersBloc, GetPromosProvidersState>(
              builder: (context, state) {
                if (state is LoadingGetPromosProviders) {
                  return _buildLoading(context);
                } else if (state is GetPromosProvidersOfflineState) {
                  return _buildNoInternet(context);
                } else if (state is GetPromosProvidersErrorState) {
                  return _buildError(state, context);
                } else if (state is LoadedGetPromosProviders) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _buildGrid(context, state)),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        );
      }),
    );
  }

  RemoveFavBloc _buildRemoveFav() {
    return RemoveFavBloc(
            deleteFavServicesUseCase: DeleteFavServicesUseCase(
          favoritesRepo: FavoritesRepoImpl(
            favoritesDataSource: FavoritesDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
          ),
        ));
  }

  Widget _buildError(GetPromosProvidersErrorState state, BuildContext context) {
    return NetworkErrorWidget(
        message: state.message,
        onPressed: () {
          BlocProvider.of<GetPromosProvidersBloc>(context)
              .add(LoadProvidersEvent(
            serviceId: offerServiceEntity.id,
          ));
        });
  }

  Widget _buildNoInternet(BuildContext context) {
    return NoConnectionWidget(onPressed: () {
      BlocProvider.of<GetPromosProvidersBloc>(context).add(LoadProvidersEvent(
        serviceId: offerServiceEntity.id,
      ));
    });
  }

  Widget _buildLoading(BuildContext context) {
    return const LoadingWidget();
  }

  Widget _buildGrid(BuildContext context, LoadedGetPromosProviders state) {
    return state.data.isEmpty
        ? Center(
            child: Text(
            'No providers',
            textAlign: TextAlign.center,
          ))
        : MasonryGridView.builder(
            gridDelegate: const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 500,
            ),
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              return Container(
                child: UserPromoProviderCard(
                  key: UniqueKey(),
                  serviceId: offerServiceEntity.id,
                  offerProviderEntity: state.data[index],
                ),
              );
            },
          );
  }

  GetPromosProvidersBloc _getBloc() {
    return GetPromosProvidersBloc(
        getPromosProvidersUseCase: GetPromosProvidersUseCase(
      offersRepo: OffersRepoImpl(
        offersDataSource: OffersDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ))
      ..add(
        LoadProvidersEvent(
          serviceId: offerServiceEntity.id,
        ),
      );
  }

  AddFavBloc _getSaveFavBloc() {
    return AddFavBloc(
        saveFavServicesUseCase: SaveFavServicesUseCase(
      favoritesRepo: FavoritesRepoImpl(
        favoritesDataSource: FavoritesDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
  }
}
