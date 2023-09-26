// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:masbar/features/user/services/presentation/explore/screens/search_services_screen.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../../core/utils/helpers/helpers.dart';
import '../../../data/data_source/explore_services_data_source.dart';
import '../../../data/repositories/explore_services_repo_impl.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/use_cases/get_services_use_case.dart';
import '../../service_details.dart/screen/service_details_screen.dart';
import '../bloc/get_services_bloc.dart';
import '../widgets/explore_category_card.dart';
import '../widgets/search_text_field.dart';
import '../widgets/service_details_btn.dart';
import '../widgets/service_item_card.dart';

class ExploreServicesScreen extends StatelessWidget {
  static const routeName = 'explore_services_screen';
  final CategoryEntity categoryEntity;

  const ExploreServicesScreen({
    Key? key,
    required this.categoryEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(),
      child: Builder(builder: (context) {
        return BlocBuilder<GetServicesBloc, GetServicesState>(
            builder: (context, state) {
          if (state is LoadingGetService) {
            return _buildLoading(context);
          } else if (state is GetServiceOfflineState) {
            return _buildNoInternet(context);
          } else if (state is GetServiceErrorState) {
            return _buildError(state, context);
          } else if (state is LoadedGetService) {
            return _buildExploreServicesbody(context, state, categoryEntity);
          } else {
            return Container();
          }
        });
      }),
    );
  }

  Scaffold _buildExploreServicesbody(
      BuildContext context, LoadedGetService state, CategoryEntity category) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryEntity.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildSearchField(context),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 16,
              ),
            ),
            SliverToBoxAdapter(
              child: _buildCategory(context, category),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 16,
              ),
            ),
            SliverToBoxAdapter(
              child: ServiceDetailsBtn(),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160,
                childAspectRatio: 4 / 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ServiceItemCard(
                    serviceEntity: state.services[index],
                  );
                },
                childCount: state.services.length,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 90,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(BuildContext context, CategoryEntity category) {
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

  Scaffold _buildError(GetServiceErrorState state, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryEntity.title)),
      body: NetworkErrorWidget(
          message: state.message,
          onPressed: () {
            BlocProvider.of<GetServicesBloc>(context)
                .add(LoadServicesEvent(id: categoryEntity.id));
          }),
    );
  }

  Scaffold _buildNoInternet(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryEntity.title)),
      body: NoConnectionWidget(onPressed: () {
        BlocProvider.of<GetServicesBloc>(context)
            .add(LoadServicesEvent(id: categoryEntity.id));
      }),
    );
  }

  Scaffold _buildLoading(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryEntity.title)),
      body: LoadingWidget(),
    );
  }

  GetServicesBloc _getBloc() {
    return GetServicesBloc(
      getServicesUseCase: GetServicesUseCase(
        exploreServicesRepo: ExploreServicesRepoImpl(
          exploreServicesDataSource: ExploreServicesDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(LoadServicesEvent(id: categoryEntity.id));
  }

  Widget _buildSearchField(BuildContext context) {
    return SearchTextField(
      categoryEntity: categoryEntity,
    );
  }
}
