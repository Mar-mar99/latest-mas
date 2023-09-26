// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../../core/utils/helpers/helpers.dart';
import '../../../data/data_source/favorite_data_source.dart';

import '../../../data/repositories/favorites_repo_impl.dart';
import '../../../domain/entities/favorite_category_entity.dart';
import '../../../domain/use_cases/get_fav_services_use_case.dart';
import '../../fav/bloc/get_fav_services_bloc.dart';
import '../widgets/favorite_service_card.dart';

class FavoritesServicesScreen extends StatelessWidget {
  static const routeName = 'favorites_services_screen';
  final FavoriteCategoryEntity category;

  const FavoritesServicesScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetFavServicesBloc(
        getFavServicesUseCase: GetFavServicesUseCase(
          favoritesRepo: FavoritesRepoImpl(
            favoritesDataSource: FavoritesDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
          ),
        ),
      )..add(LoadFavServices(id: category.id)),
      child: Builder(builder: (context) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Favorite Services'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(
                16,
              ),
              child: BlocBuilder<GetFavServicesBloc, GetFavServicesState>(
                builder: (context, state) {
                  if (state is LoadingGetFavServices) {
                    return _buildLoading(context);
                  } else if (state is GetFavServicesOfflineState) {
                    return _buildNoInternet(context);
                  } else if (state is GetFavServicesErrorState) {
                    return _buildError(state, context);
                  } else if (state is LoadedGetFavServices) {
                    return  state.data.isEmpty?
                    Center(child: Text('No services')):
                    Column(
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
            ));
      }),
    );
  }

  Widget _buildError(GetFavServicesErrorState state, BuildContext context) {
    return NetworkErrorWidget(
        message: state.message,
        onPressed: () {
          BlocProvider.of<GetFavServicesBloc>(context)
              .add(LoadFavServices(id: category.id));
        });
  }

  Widget _buildNoInternet(BuildContext context) {
    return NoConnectionWidget(onPressed: () {
     BlocProvider.of<GetFavServicesBloc>(context)
              .add(LoadFavServices(id: category.id));
    });
  }

  Widget _buildLoading(BuildContext context) {
    return LoadingWidget();
  }

  Widget _buildGrid(BuildContext context, LoadedGetFavServices state) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // SliverToBoxAdapter(
        //   child: _buildSearchField(context),
        // ),
        // const SliverToBoxAdapter(
        //   child: SizedBox(
        //     height: 16,
        //   ),
        // ),
        SliverToBoxAdapter(
          child: _buildCategory(context, category),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 16,
          ),
        ),
        // SliverToBoxAdapter(
        //   child: ServiceDetailsBtn(),
        // ),
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 160,
            childAspectRatio: 4 / 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return FavoritesServiceCard(
                favoriteServiceEntity:
                 state.data[index],
              );
            },
            childCount: state.data.length,
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 90,
          ),
        )
      ],
    );
  }

  Widget _buildCategory(BuildContext context, FavoriteCategoryEntity category) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: Colors.grey,
        ),
      ),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: GridTile(
            // footer: GridTileBar(
            //   title: Text(category.title),
            //   backgroundColor: Colors.black54,
            // ),
            child: Container(
              color: Colors.white,
              child: Image.network(
                Helpers.getImage(
                  category.image,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
