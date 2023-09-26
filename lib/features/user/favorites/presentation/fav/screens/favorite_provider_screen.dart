// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../data/data_source/favorite_data_source.dart';
import '../../../data/repositories/favorites_repo_impl.dart';
import '../../../domain/entities/favorite_service_entity.dart';
import '../../../domain/use_cases/delete_fav_use_case.dart';
import '../../../domain/use_cases/get_fav_list_use_case.dart';
import '../../fav/bloc/get_fav_providers_bloc.dart';
import '../../fav/bloc/remove_fav_bloc.dart';
import '../widgets/favorite_provider_card.dart';

class FavoritesProviderScreen extends StatelessWidget {
  final FavoriteServiceEntity favoriteServiceEntity;
  const FavoritesProviderScreen({
    Key? key,
    required this.favoriteServiceEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetFavProvidersBloc(
            getFavListUseCase: GetFavListUseCase(
              favoritesRepo: FavoritesRepoImpl(
                favoritesDataSource: FavoritesDataSourceWithHttp(
                  client: NetworkServiceHttp(),
                ),
              ),
            ),
          )..add(
              LoadFavProvidersEvent(serviceId: favoriteServiceEntity.id),
            ),
        ),
        BlocProvider(
          create: (context) => RemoveFavBloc(
              deleteFavServicesUseCase: DeleteFavServicesUseCase(
            favoritesRepo: FavoritesRepoImpl(
              favoritesDataSource: FavoritesDataSourceWithHttp(
                client: NetworkServiceHttp(),
              ),
            ),
          )),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          'Providers - ${favoriteServiceEntity.name}',
        )),
        body: Padding(
          padding: const EdgeInsets.all(
            16,
          ),
          child: BlocBuilder<GetFavProvidersBloc, GetFavProvidersState>(
            builder: (context, state) {
              if (state is LoadingGetFavProviders) {
                return _buildLoading(context);
              } else if (state is GetFavProvidersOfflineState) {
                return _buildNoInternet(context, favoriteServiceEntity.id);
              } else if (state is GetFavProvidersErrorState) {
                return _buildError(state, context, favoriteServiceEntity.id);
              } else if (state is LoadedGetFavProviders) {
                return state.data.isEmpty
                    ? const Center(
                        child: Text('No Favourites'),
                      )
                    : MasonryGridView.builder(
                        gridDelegate:
                            const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 500,
                        ),
                        itemCount: state.data.length,
                        itemBuilder: (context, index) {
                          return FavoriteProviderCard(
                            key: UniqueKey(),
                            serviceId: favoriteServiceEntity.id,
                            provider: state.data[index],
                          );
                        },
                      );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildError(
      GetFavProvidersErrorState state, BuildContext context, int id) {
    return NetworkErrorWidget(
        message: state.message,
        onPressed: () {
          BlocProvider.of<GetFavProvidersBloc>(context)
              .add(LoadFavProvidersEvent(serviceId: id));
        });
  }

  Widget _buildNoInternet(BuildContext context, int id) {
    return NoConnectionWidget(onPressed: () {
      BlocProvider.of<GetFavProvidersBloc>(context)
          .add(LoadFavProvidersEvent(serviceId: id));
    });
  }

  Widget _buildLoading(BuildContext context) {
    return LoadingWidget();
  }
}
