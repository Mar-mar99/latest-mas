import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/features/company/manage_promotion/presentation/screens/create_promo_screen.dart';

import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../data/data_source/promotion_data_source.dart';
import '../../data/repositories/promotion_repo_impl.dart';
import '../../domain/use_cases/get_promotions_use_case.dart';
import '../bloc/get_promos_bloc.dart';
import 'details_edit_promo_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManagePromotionScreen extends StatelessWidget {
  static const routeName = 'manage_promotion_screen';
  const ManagePromotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getPromosBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          floatingActionButton: _buildCreatePromoFloatingBtn(context),
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.manage_promotions),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<GetPromosBloc, GetPromosState>(
              builder: (context, state) {
                if (state is LoadingGetPromos) {
                  return _buildLoadingState();
                } else if (state is GetPromosOfflineState) {
                  return _buildNoConnectionState(context);
                } else if (state is GetPromosErrorState) {
                  return _buildNetworkErrorState(state, context);
                } else if (state is LoadedGetPromos) {
                  return _buildBody(context, state);
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

  GridView _buildBody(BuildContext c, LoadedGetPromos state) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 450,
        mainAxisExtent: 160,
      ),
      itemCount: state.data.length,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          state.data[index].promo,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 18, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        state.data[index].status,
                        maxLines: 1,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.discount, size: 20, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        '${state.data[index].discount}%',
                        maxLines: 1,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 20,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${state.data[index].expiration.year}/${state.data[index].expiration.month}/${state.data[index].expiration.day}',
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return BlocProvider.value(
                                  value: c.read<GetPromosBloc>(),
                                  child: DetailsEditPromoScreen(
                                      id: state.data[index].id),
                                );
                              },
                            ));
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.blue,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  NetworkErrorWidget _buildNetworkErrorState(
      GetPromosErrorState state, BuildContext context) {
    return NetworkErrorWidget(
      message: state.message,
      onPressed: () {
        BlocProvider.of<GetPromosBloc>(context).add(LoadPromosEvent());
      },
    );
  }

  NoConnectionWidget _buildNoConnectionState(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<GetPromosBloc>(context).add(LoadPromosEvent());
      },
    );
  }

  LoadingWidget _buildLoadingState() {
    return const LoadingWidget();
  }

  GetPromosBloc _getPromosBloc() {
    return GetPromosBloc(
        getPromotionsUseCase: GetPromotionsUseCase(
      promotionRepo: PromotionRepoImpl(
        promotionDataSource: PromotionDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ))
      ..add(LoadPromosEvent());
  }

  FloatingActionButton _buildCreatePromoFloatingBtn(BuildContext c) {
    return FloatingActionButton(
      backgroundColor: Theme.of(c).primaryColor,
      onPressed: () {
        Navigator.push(c, MaterialPageRoute(
          builder: (context) {
            return BlocProvider.value(
              value: c.read<GetPromosBloc>(),
              child: CreatePromoScreen(),
            );
          },
        ));
        // Navigator.pushNamed(context, CreatePromoScreen.routeName);
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }
}
