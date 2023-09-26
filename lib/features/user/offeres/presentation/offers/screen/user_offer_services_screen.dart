// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:masbar/features/user/offeres/domain/use_cases/get_promos_services_use_case.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../../core/utils/helpers/helpers.dart';
import '../../../data/data_source/offers_data_source.dart';
import '../../../data/repositories/offers_repo_impl.dart';
import '../../../domain/entities/offer_category_entity.dart';
import '../bloc/get_promos_services_bloc.dart';
import '../widgets/user_promo_service_card.dart';

class UserOfferServicesScreen extends StatelessWidget {
  static const routeName = 'user_offer_services_screen';

  final OfferCategoryEntity categoryEntity;
  const UserOfferServicesScreen({
    Key? key,
    required this.categoryEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetPromosServicesBloc(
        getPromosServicesUseCase: GetPromosServicesUseCase(
          offersRepo: OffersRepoImpl(
            offersDataSource: OffersDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
          ),
        ),
      )..add(GetServiceEvent(id: categoryEntity.id)),
      child: Builder(builder: (context) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Services'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(
                16,
              ),
              child: BlocBuilder<GetPromosServicesBloc, GetPromosServicesState>(
                builder: (context, state) {
                  if (state is LoadingGetPromosServices) {
                    return _buildLoading(context);
                  } else if (state is GetPromosServicesOfflineState) {
                    return _buildNoInternet(context);
                  } else if (state is GetPromosServicesErrorState) {
                    return _buildError(state, context);
                  } else if (state is LoadedGetPromosServices) {
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
            ));
      }),
    );
  }

  Widget _buildError(GetPromosServicesErrorState state, BuildContext context) {
    return NetworkErrorWidget(
        message: state.message,
        onPressed: () {
          BlocProvider.of<GetPromosServicesBloc>(context)
              .add(GetServiceEvent(id: categoryEntity.id));
        });
  }

  Widget _buildNoInternet(BuildContext context) {
    return NoConnectionWidget(onPressed: () {
      BlocProvider.of<GetPromosServicesBloc>(context)
          .add(GetServiceEvent(id: categoryEntity.id));
    });
  }

  Widget _buildLoading(BuildContext context) {
    return LoadingWidget();
  }

  Widget _buildGrid(BuildContext context, LoadedGetPromosServices state) {
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
          child: _buildCategory(context, categoryEntity),
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
              return UserPromoServiceCard(
                service: state.data[index],
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

  Widget _buildCategory(BuildContext context, OfferCategoryEntity category) {
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
