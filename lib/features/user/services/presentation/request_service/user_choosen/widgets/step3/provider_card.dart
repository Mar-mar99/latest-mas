
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

import '../../../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../../../core/constants/api_constants.dart';
import '../../../../../../../../core/ui/dialogs/cancellation_fee_dialog.dart';
import '../../../../../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../../../../../core/utils/enums/enums.dart';
import '../../../../../../../../core/utils/helpers/helpers.dart';
import '../../../../../../../../core/utils/helpers/toast_utils.dart';
import '../../../../../../favorites/data/data_source/favorite_data_source.dart';
import '../../../../../../favorites/data/repositories/favorites_repo_impl.dart';
import '../../../../../../favorites/domain/use_cases/delete_fav_use_case.dart';
import '../../../../../../favorites/domain/use_cases/save_fav_use_case.dart';
import '../../../../../../favorites/presentation/fav/bloc/add_fav_bloc.dart';
import '../../../../../../favorites/presentation/fav/bloc/remove_fav_bloc.dart';
import '../../../../../domain/entities/service_provider_entity.dart';
import '../../bloc/user_create_request_bloc.dart';

class ProviderCard extends StatefulWidget {
  final ProviderStatus providerStatus;
  final ServiceProviderEntity provider;
  final Function changeCurrentTab;
  const ProviderCard({
    Key? key,
    required this.providerStatus,
    required this.provider,
    required this.changeCurrentTab,
  }) : super(key: key);

  @override
  State<ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends State<ProviderCard> {
  bool isExpanded = false;
  late bool isFav;
  @override
  void initState() {
    super.initState();
    isFav = widget.provider.isFavourite;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getRemoveFavBloc(),
        ),
        BlocProvider(
          create: (context) => _getAddFavBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return MultiBlocListener(
          listeners: [
            BlocListener<RemoveFavBloc, RemoveFavState>(
                listener: (context, state) {
              _buildRemoveListener(state, context);
            }),
            BlocListener<AddFavBloc, AddFavState>(
              listener: (context, state) {
                _buildAddFavListener(state, context);
              },
            ),
          ],
          child: Container(
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImage(),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildName(),
                                _buildRating(),
                                const Divider(
                                  height: 8,
                                ),
                                _buildCompletedService(),
                                const Divider(
                                  height: 8,
                                ),
                                const SizedBox(height: 4,),
                                _buildBasicPrice(),
                                _buildHourlyPrice(),
                                const SizedBox(height: 4,),
                                _buildAttributes(),
                              ]),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildRequestBtn(context),
                        ),
                        const SizedBox(width: 4),
                        _buildFavBtn(context)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _buildAddFavListener(AddFavState state, BuildContext context) {
    if (state is LoadingAddFav) {
      showLoadingDialog(context, text: 'Saving to Favorites...');
    } else if (state is AddFavOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is AddFavErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('${state.message}');
    } else if (state is LoadedAddFav) {
      Navigator.pop(context);
      ToastUtils.showSusToastMessage('Added to favorites successfully');
      setState(() {
        isFav = !isFav;
      });
    }
  }

  void _buildRemoveListener(RemoveFavState state, BuildContext context) {
    if (state is LoadingRemoveFav) {
      showLoadingDialog(context, text: 'Removing From Favorites...');
    } else if (state is RemoveFavOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is RemoveFavErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage(
          'An error has ocurred,\n try again,\n ${state.message}');
    } else if (state is LoadedRemoveFav) {
      Navigator.pop(context);
      ToastUtils.showSusToastMessage('Removed from favorites successfully');
      setState(() {
        isFav = !isFav;
      });
    }
  }

  Widget _buildCompletedService() {
    return Row(
      children: [
       const Icon(Icons.check_circle, size: 18, color: Colors.green),
        const SizedBox(width: 4),
        Expanded(child: Text('${widget.provider.completedRequests} completed services', style:const TextStyle(fontSize: 15)))
      ],
    );
  }

  ElevatedButton _buildRequestBtn(BuildContext context) {
    Color c = Colors.green;
    switch (widget.providerStatus) {
      case ProviderStatus.online:
        c = Colors.green;
        break;
      case ProviderStatus.busy:
        c = Colors.red;
        break;
      case ProviderStatus.offline:
        c = Colors.grey;
        break;
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: c),
      onPressed: () {
        if (widget.provider.cancelationFees != '0') {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return CancellationFee(
                amount: widget.provider.cancelationFees,
                cancelHandler: () {
                  Navigator.pop(dialogContext);
                },
                okHandler: () {
                  Navigator.pop(dialogContext);
                  BlocProvider.of<UserCreateRequestBloc>(context).add(
                    ProviderTypeChangedEvent(
                        providerStatus: widget.providerStatus),
                  );
                  BlocProvider.of<UserCreateRequestBloc>(context)
                      .add(ProviderIdChangedEvent(id: widget.provider.id));

                  widget.changeCurrentTab();
                },
              );
            },
          );
        } else {
          BlocProvider.of<UserCreateRequestBloc>(context).add(
            ProviderTypeChangedEvent(providerStatus: widget.providerStatus),
          );
          BlocProvider.of<UserCreateRequestBloc>(context)
              .add(ProviderIdChangedEvent(id: widget.provider.id));

          widget.changeCurrentTab();
        }
      },
      child: Text(
        'Request Now',
        maxLines: 1,
        style: TextStyle(overflow: TextOverflow.ellipsis),
      ),
    );
  }

  IconButton _buildFavBtn(BuildContext context) {
    return IconButton(
      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
          color: Colors.red),
      onPressed: () {
        if (isFav) {
          BlocProvider.of<RemoveFavBloc>(context)
              .add(RemoveFavProvider(providerId: widget.provider.id));
        } else {
          BlocProvider.of<AddFavBloc>(context)
              .add(AddFavProvider(providerId: widget.provider.id));
        }
      },
    );
  }

  RemoveFavBloc _getRemoveFavBloc() {
    return RemoveFavBloc(
      deleteFavServicesUseCase: DeleteFavServicesUseCase(
        favoritesRepo: FavoritesRepoImpl(
          favoritesDataSource: FavoritesDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  AddFavBloc _getAddFavBloc() {
    return AddFavBloc(
      saveFavServicesUseCase: SaveFavServicesUseCase(
        favoritesRepo: FavoritesRepoImpl(
          favoritesDataSource: FavoritesDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  Widget _buildAttributes() {
    return ExpansionTile(
      onExpansionChanged: (value) {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      tilePadding: EdgeInsets.all(0),
      trailing: Icon(
        !isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
        color: isExpanded ? Colors.black : Colors.grey,
      ),
      leading: Icon(
          isExpanded
              ? Icons.do_not_disturb_on_outlined
              : Icons.add_circle_outline,
          color: isExpanded ? Colors.black : Colors.grey),
      collapsedIconColor: Colors.white,
      title: Text(
        'Attributes',
        style: TextStyle(
          color: isExpanded ? Colors.black : Colors.grey,
          fontWeight: isExpanded ? FontWeight.w700 : FontWeight.normal,
        ),
      ),

      //childrenPadding: EdgeInsets.symmetric(horizontal: 16),
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.provider.attrs
                .map((e) => Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            '${e.name}: ',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${e.value}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6)
                      ],
                    ))
                .toList())
      ],
    );
  }

  Widget _buildHourlyPrice() {
    return Row(
      children: [
        Flexible(child: Text('Hourly Price: ', style: TextStyle(fontSize: 15))),
        Flexible(
            child: Text('${widget.provider.hourlyPrice} AED',
               style:const TextStyle(fontSize: 15,fontWeight: FontWeight.normal)))
      ],
    );
  }

  Row _buildBasicPrice() {
    return Row(
      children: [
        Flexible(
            child: Text('Basic Price: ',
                style: TextStyle(
                  fontSize: 15,
                ))),
        Flexible(
            child: Text('${widget.provider.fixedPrice} AED',
               style:const TextStyle(fontSize: 15,fontWeight: FontWeight.normal)))
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        RatingBar.builder(
          initialRating: double.parse(widget.provider.rating),
          minRating: 1,
          updateOnDrag: false,
          direction: Axis.horizontal,
          allowHalfRating: false,
          ignoreGestures: true,
          itemCount: 5,
          itemSize: 16,
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {},
        ),
      const SizedBox(width:4)
,      Text('(${widget.provider.ratingCount})',style:const TextStyle(fontSize:14,color:Colors.grey))
      ],
    );
  }

  Row _buildName() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Text(
                '${widget.provider.firstName} ${widget.provider.lastName}',
                style: TextStyle(fontSize: 18))),
        const SizedBox(width: 2),
        Text('${widget.provider.distance} KM', style: TextStyle(fontSize: 14))
      ],
    );
  }

  Stack _buildImage() {
    Color c = Colors.green;
    switch (widget.providerStatus) {
      case ProviderStatus.online:
        c = Colors.green;
        break;
      case ProviderStatus.busy:
        c = Colors.red;
        break;
      case ProviderStatus.offline:
        c = Colors.grey;
        break;
    }

    return Stack(
      children: [
        CircleAvatar(
            radius: 24,
          backgroundImage: widget.provider.avatar.isNotEmpty
              ? NetworkImage(Helpers.getImage(widget.provider.avatar))
              : const NetworkImage(
                  ApiConstants.userImageDefault),
        ),
        Container(),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(shape: BoxShape.circle, color: c),
          ),
        )
      ],
    );
  }
}
