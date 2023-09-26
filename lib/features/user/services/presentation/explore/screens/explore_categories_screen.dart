import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../data/data_source/explore_services_data_source.dart';
import '../../../data/repositories/explore_services_repo_impl.dart';
import '../../../domain/use_cases/get_categories_use_case.dart';
import '../bloc/get_categories_bloc.dart';
import '../widgets/explore_category_card.dart';
import '../widgets/search_text_field.dart';

class ExploreCategoriesScreen extends StatelessWidget {
  static const routeName = 'explore_categories_screen';
  const ExploreCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.home,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, state) {
              if (state is LoadingGetCategories) {
                return _buildLoading(context);
              } else if (state is GetCategoriesOfflineState) {
                return _buildNoInternet(context);
              } else if (state is GetCategoriesErrorState) {
                return _buildError(state, context);
              } else if (state is LoadedGetCategories) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSearchField(context),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(child: _buildGrid(state)),
                  ],
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

  Widget _buildError(GetCategoriesErrorState state, BuildContext context) {
    return NetworkErrorWidget(
        message: state.message,
        onPressed: () {
          BlocProvider.of<GetCategoriesBloc>(context).add(LoadCategories());
        });
  }

  Widget _buildNoInternet(BuildContext context) {
    return NoConnectionWidget(onPressed: () {
      BlocProvider.of<GetCategoriesBloc>(context).add(LoadCategories());
    });
  }

  Widget _buildLoading(BuildContext context) {
    return LoadingWidget();
  }

  Widget _buildSearchField(BuildContext context) {
    return SearchTextField();
  }

  Widget _buildGrid(LoadedGetCategories state) {
    return AnimationLimiter(
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
                child: ExploreCategoryCard(category: state.categories[index]),
              ),
            ),
          );
        },
        itemCount: state.categories.length,
      ),
    );
//    );
  }

  GetCategoriesBloc _getBloc() {
    return GetCategoriesBloc(
        getCategoriesUseCase: GetCategoriesUseCase(
      exploreServicesRepo: ExploreServicesRepoImpl(
        exploreServicesDataSource: ExploreServicesDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ))
      ..add(LoadCategories());
  }
}
