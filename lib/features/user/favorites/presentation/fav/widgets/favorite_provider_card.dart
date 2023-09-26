// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:masbar/core/ui/widgets/app_dialog.dart';

import '../../../../../../core/constants/api_constants.dart';
import '../../../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../../../core/utils/helpers/helpers.dart';
import '../../../../../../core/utils/helpers/toast_utils.dart';
import '../../../domain/entities/favorite_provider_entity.dart';
import '../../fav/bloc/get_fav_providers_bloc.dart';
import '../../fav/bloc/remove_fav_bloc.dart';
import '../../request_fav/screens/request_fav_provider.dart';

class FavoriteProviderCard extends StatefulWidget {
  final int serviceId;
  final FavoriteProviderEntity provider;
  const FavoriteProviderCard({
    Key? key,
    required this.serviceId,
    required this.provider,
  }) : super(key: key);

  @override
  State<FavoriteProviderCard> createState() => _FavoriteProviderCardState();
}

class _FavoriteProviderCardState extends State<FavoriteProviderCard> {
  bool isExpanded = false;
  bool isFav = true;
  @override
  Widget build(BuildContext context) {
    return BlocListener<RemoveFavBloc, RemoveFavState>(
      listener: (context, state) {
        if (state is LoadingRemoveFav) {
          showLoadingDialog(context, text: 'Removing From Favorites...');
        } else if (state is RemoveFavOfflineState) {
          Navigator.pop(context);
          ToastUtils.showErrorToastMessage('No internet Connection');
        } else if (state is RemoveFavErrorState) {
          Navigator.pop(context);
          ToastUtils.showErrorToastMessage(
              'An error has occured,\n try again,\n ${state.message}');
        } else if (state is LoadedRemoveFav) {
          Navigator.pop(context);

          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.of(context).pop(true);
                });
                return Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_sharp,
                            color: Colors.green,
                          ),
                          Text('Removed from Favorites Successfully'),
                        ],
                      )
                    ]),
                  ),
                );
              });

          BlocProvider.of<GetFavProvidersBloc>(context)
              .add(LoadFavProvidersEvent(serviceId: widget.serviceId));
        }
      },
      child: Container(
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                            const SizedBox(height: 4),
                            _buildBasicPrice(),
                            _buildHourlyPrice(),
                            const SizedBox(height: 4),
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
                    _buildFavBtn()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedService() {
    return Row(
      children: [
        const Icon(Icons.check_circle, size: 18, color: Colors.green),
        const SizedBox(width: 4),
        Expanded(
            child: Text(
          '${widget.provider.completedRequest} completed service',
          style: const TextStyle(
            fontSize: 15,
          ),
        ))
      ],
    );
  }

  ElevatedButton _buildRequestBtn(BuildContext context) {
    Color c = Colors.green;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: c),
      onPressed: () {
        Navigator.pushNamed(context, RequestFavProviderScreen.routeName,
            arguments: {
              'serviceId': widget.serviceId,
              "providerId": widget.provider.id,
              "cancelFee": widget.provider.cancellationFee
            });
      },
      child: Text(
        'Request Now',
        maxLines: 1,
        style: TextStyle(overflow: TextOverflow.ellipsis),
      ),
    );
  }

  IconButton _buildFavBtn() {
    return IconButton(
      icon: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border,
          color: Colors.red),
      onPressed: () {
        showDialog(
          context: context,
          builder: (dialogcontext) {
            return DialogItem(
              title: 'Remove Confirmation',
              paragraph:
                  'Are you sure you want to remove this provider from the favorites?',
              cancelButtonText: 'cancel',
              cancelButtonFunction: () {
                Navigator.pop(context);
              },
              nextButtonText: 'remove',
              nextButtonFunction: () {
                BlocProvider.of<RemoveFavBloc>(context)
                    .add(RemoveFavProvider(providerId: widget.provider.id));
                Navigator.pop(context);
              },
            );
          },
        );
      },
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
              .toList(),
        ),
      ],
    );
  }

  Widget _buildHourlyPrice() {
    return Row(
      children: [
        Flexible(child: Text('Hourly Price: ', style: TextStyle(fontSize: 15))),
        Flexible(
            child: Text('${widget.provider.hourlyPrice} AED',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.normal)))
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
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.normal)))
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        RatingBar.builder(
          initialRating: double.parse(widget.provider.rating.toString()),
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
        // Text('(${widget.provider.ratingCount})',
        //     style: const TextStyle(fontSize: 14, color: Colors.grey))
      ],
    );
  }

  Row _buildName() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Text('${widget.provider.name}',
                style: TextStyle(fontSize: 18))),
        const SizedBox(width: 2),
        Text('${widget.provider.distance} KM',
            style: const TextStyle(fontSize: 14))
      ],
    );
  }

  Stack _buildImage() {
    Color c = Colors.green;
    if (widget.provider.isExpertOnline) {
      c = Colors.green;
    } else if (!widget.provider.isExpertOnline) {
      c = Colors.grey;
    } else if (widget.provider.isBusy) {
      c = Colors.red;
    }

    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(
              // widget.provider. == '' ?
              ApiConstants.userImageDefault
              // :
              // Helpers.getImage(image,),
              ),
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
