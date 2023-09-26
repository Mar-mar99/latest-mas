import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/features/user/offeres/data/data_source/offers_data_source.dart';
import 'package:masbar/features/user/offeres/data/repositories/offers_repo_impl.dart';

import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../domain/use_cases/get_promos_categories_use_case.dart';
import '../bloc/get_promos_categories_bloc.dart';
import '../widgets/user_promo_category_card.dart';

class UserOffersCategoriesScreen extends StatelessWidget {
  const UserOffersCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetPromosCategoriesBloc(
        getPromosCategoriesUseCase: GetPromosCategoriesUseCase(
          offersRepo: OffersRepoImpl(
            offersDataSource: OffersDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
          ),
        ),
      )..add(LoadPromosCategories()),
      child: Builder(builder: (context) {
        return Scaffold(
            body: Padding(
              padding:const EdgeInsets.all(
                16,
              ),
              child: BlocBuilder<GetPromosCategoriesBloc, GetPromosCategoriesState>(
                builder: (context, state) {
               if (state is LoadingGetPromosCategories) {
                  return _buildLoading(context);
                } else if (state is GetPromosCategoriesOfflineState) {
                  return _buildNoInternet(context);
                } else if (state is GetPromosCategoriesErrorState) {
                  return _buildError(state, context);
                } else if (state is LoadedGetPromosCategories) {
                  return _buildGrid(state);
                } else {
                  return Container();
                }
              },
            ),
        )
      );
      }
    ),);
      }

  Widget _buildError(GetPromosCategoriesErrorState state, BuildContext context) {
    return NetworkErrorWidget(
        message: state.message,
        onPressed: () {
          BlocProvider.of<GetPromosCategoriesBloc>(context).add(LoadPromosCategories());
        });
  }

  Widget _buildNoInternet(BuildContext context) {
    return NoConnectionWidget(onPressed: () {
      BlocProvider.of<GetPromosCategoriesBloc>(context).add(LoadPromosCategories());
    });
  }

  Widget _buildLoading(BuildContext context) {
    return LoadingWidget();
  }



  Widget _buildGrid(LoadedGetPromosCategories state) {
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
                child: UserPromoCategoryCard(category: state.data[index]),
              ),
            ),
          );
        },
        itemCount: state.data.length,
      ),

 );
  }
}
