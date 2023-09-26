import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:masbar/core/api_service/network_service_http.dart';

import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../data/data_source/favorite_data_source.dart';
import '../../../data/repositories/favorites_repo_impl.dart';
import '../../../domain/use_cases/get_fav_categories_use_case.dart';
import '../../fav/bloc/get_fav_categories_bloc.dart';
import '../widgets/favorites_category_card.dart';

class FavoritesCategoriesScreen extends StatelessWidget {
  const FavoritesCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetFavCategoriesBloc(
        getFavCategoriesUseCase: GetFavCategoriesUseCase(
          favoritesRepo: FavoritesRepoImpl(
            favoritesDataSource: FavoritesDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
          ),
        ),
      )..add(LoadFavCategories()),
      child: Builder(builder: (context) {
        return Scaffold(

            body: Padding(
              padding: const EdgeInsets.all(
                16,
              ),
              child: BlocBuilder<GetFavCategoriesBloc, GetFavCategoriesState>(
                builder: (context, state) {
                  if (state is LoadingGetFavCategories) {
                    return _buildLoading(context);
                  } else if (state is GetFavCategoriesOfflineState) {
                    return _buildNoInternet(context);
                  } else if (state is GetFavCategoriesErrorState) {
                    return _buildError(state, context);
                  } else if (state is LoadedGetFavCategories) {
                    return _buildGrid(state);
                  } else {
                    return Container();
                  }
                },
              ),
            ));
      }),
    );
  }

  Widget _buildError(GetFavCategoriesErrorState state, BuildContext context) {
    return NetworkErrorWidget(
        message: state.message,
        onPressed: () {
          BlocProvider.of<GetFavCategoriesBloc>(context)
              .add(LoadFavCategories());
        });
  }

  Widget _buildNoInternet(BuildContext context) {
    return NoConnectionWidget(onPressed: () {
      BlocProvider.of<GetFavCategoriesBloc>(context).add(LoadFavCategories());
    });
  }

  Widget _buildLoading(BuildContext context) {
    return LoadingWidget();
  }

  Widget _buildGrid(LoadedGetFavCategories state) {
    return state.data.isEmpty
        ? const Center(child: Text('No Favorites',textAlign: TextAlign.center,))
        : AnimationLimiter(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1 / 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: 2,
                  duration: const Duration(milliseconds: 1500),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    horizontalOffset: -50,
                    child: FadeInAnimation(
                      child: FavoritesCategoryCard(category: state.data[index]),
                    ),
                  ),
                );
              },
              itemCount: state.data.length,
            ),
          );
  }
}
