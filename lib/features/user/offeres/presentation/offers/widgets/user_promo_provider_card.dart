import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

import 'package:masbar/core/ui/dialogs/loading_dialog.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';

import '../../../../../../core/constants/api_constants.dart';
import '../../../../../../core/utils/helpers/helpers.dart';
import '../../../../favorites/presentation/fav/bloc/add_fav_bloc.dart';
import '../../../../favorites/presentation/fav/bloc/remove_fav_bloc.dart';
import '../../../domain/entities/offer_provider_entity.dart';
import '../../request_offer/screens/request_offer_screen.dart';
import '../bloc/get_promos_providers_bloc.dart';

class UserPromoProviderCard extends StatefulWidget {
  final int serviceId;
  final OfferProviderEntity offerProviderEntity;
  const UserPromoProviderCard({
    Key? key,
    required this.serviceId,
    required this.offerProviderEntity,
  }) : super(key: key);

  @override
  State<UserPromoProviderCard> createState() => _UserPromoProviderCardState();
}

class _UserPromoProviderCardState extends State<UserPromoProviderCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddFavBloc, AddFavState>(
          listener: (context, state) async {
            _addFavListener(state, context);
          },
        ),
        BlocListener<RemoveFavBloc, RemoveFavState>(listener: (context, state) {
          _removeFavListener(state, context);
        }),
      ],
      child: Container(
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          _buildImage(widget.offerProviderEntity.image),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildName(widget.offerProviderEntity.name),
                                _buildRating(widget.offerProviderEntity.rating),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 8,
                      ),
                      const SizedBox(height:4),
                      Text('Discount'),
                      Row(
                        children: [
                          Expanded(child: _buildDiscount()),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(child: _buildExpire()),
                        ],
                      ),

                      const SizedBox(height:4),
                      const Divider(
                        height: 8,
                      ),
                      _buildCompletedService(),
                      const Divider(
                        height: 8,
                      ),
                      const SizedBox(height:4),
                      _buildBasicPrice(widget.offerProviderEntity.fixedPrice),
                      _buildHourlyPrice(widget.offerProviderEntity.hourlyPrice),
                     const SizedBox(height:4),
                      _buildAttributes(),
                    ]),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildRequestBtn(context),
                    ),
                    const SizedBox(width: 4),
                    _buildFavBtn(context, widget.offerProviderEntity.id)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addFavListener(AddFavState state, BuildContext context) {
    if (state is LoadingAddFav) {
      showLoadingDialog(context, text: 'Saving to Favorites...');
    } else if (state is AddFavOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is AddFavErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage(state.message);
    } else if (state is LoadedAddFav) {
      Navigator.pop(context);
      ToastUtils.showSusToastMessage('Added to Favorites Successfully');
      BlocProvider.of<GetPromosProvidersBloc>(context)
          .add(LoadProvidersEvent(serviceId: widget.serviceId));
    }
  }

  void _removeFavListener(RemoveFavState state, BuildContext context) {
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
      ToastUtils.showSusToastMessage('Removed from Favorites Successfully');

      BlocProvider.of<GetPromosProvidersBloc>(context)
          .add(LoadProvidersEvent(serviceId: widget.serviceId));
    }
  }

  Widget _buildCompletedService() {
    return Row(
      children: [
        const Icon(Icons.check_circle, size: 18, color: Colors.green),
        const SizedBox(width: 4),
        Expanded(
            child: Text(
                '${widget.offerProviderEntity.completedRequests} completed services',
                style: const TextStyle(fontSize: 15)))
      ],
    );
  }

  Widget _buildAttributes() {
    return ExpansionTile(
      onExpansionChanged: (value) {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      tilePadding: const EdgeInsets.all(0),
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
            children: widget.offerProviderEntity.attributes
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

  Widget _buildDiscount() {
    return Row(
      children: [
        const Icon(Icons.discount, size: 18, color: Colors.green),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '${widget.offerProviderEntity.discountPercentage}%',
            style:const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          ),
        )
      ],
    );
  }

  Widget _buildExpire() {
    return Row(
      children: [
        const Icon(Icons.calendar_month, size: 20, color: Colors.blue),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '${widget.offerProviderEntity.expiredDatePromo.year}/${widget.offerProviderEntity.expiredDatePromo.month}/${widget.offerProviderEntity.expiredDatePromo.day}',
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          ),
        )
      ],
    );
  }

  ElevatedButton _buildRequestBtn(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      onPressed: () {
        // BlocProvider.of<UserCreateRequestBloc>(context).add(
        //   ProviderTypeChangedEvent(providerStatus: widget.providerStatus),
        // );
        Navigator.pushNamed(context, RequestOfferScreen.routeName, arguments: {
          'serviceId': widget.serviceId,
          "provider": widget.offerProviderEntity
        });
      },
      child: Text(
        'Request Now',
        maxLines: 1,
        style: TextStyle(overflow: TextOverflow.ellipsis),
      ),
    );
  }

  IconButton _buildFavBtn(BuildContext context, int providerId) {
    return IconButton(
      icon: Icon(
          widget.offerProviderEntity.isFavorite
              ? Icons.favorite
              : Icons.favorite_border,
          color: Colors.red),
      onPressed: () {
        if (widget.offerProviderEntity.isFavorite) {
          BlocProvider.of<RemoveFavBloc>(context).add(
            RemoveFavProvider(
              providerId: providerId,
            ),
          );
        } else {
          BlocProvider.of<AddFavBloc>(context)
              .add(AddFavProvider(providerId: providerId));
        }
      },
    );
  }

  Widget _buildHourlyPrice(String hourly) {
    return Row(
      children: [
        Flexible(child: Text('Hourly: ', style: TextStyle(fontSize: 15))),
        Flexible(child: Text('$hourly AED', style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal)))
      ],
    );
  }

  Row _buildBasicPrice(String basic) {
    return Row(
      children: [
        Flexible(
            child: Text('Basic: ',
                style: TextStyle(
                  fontSize: 15,
                ))),
        Flexible(child: Text('$basic AED', style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal)))
      ],
    );
  }

  Widget _buildRating(String rating) {
    return Container(
      child: Row(
        children: [
          RatingBar.builder(
            initialRating: double.parse(rating),
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
          const SizedBox(width: 4),
          Text('(${widget.offerProviderEntity.ratingCount})',
              style: const TextStyle(fontSize: 14, color: Colors.grey))
        ],
      ),
    );
  }

  Widget _buildName(String name) {
    return Container(
      //  color:Colors.green,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stack _buildImage(String image) {
    Color c = Colors.green;
    if (widget.offerProviderEntity.expertOnline) {
      c = Colors.green;
    } else if (!widget.offerProviderEntity.expertOnline) {
      c = Colors.grey;
    } else if (widget.offerProviderEntity.isBusy) {
      c = Colors.red;
    }

    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(image == ''
              ? ApiConstants.userImageDefault
              : Helpers.getImage(image)),
        ),
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
