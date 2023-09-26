// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/utils/extensions/extensions.dart';

import '../../../../../../../../core/utils/enums/enums.dart';
import '../../../../../../../../core/utils/helpers/helpers.dart';
import '../../../../../domain/entities/service_info_entity.dart';
import '../../bloc/user_create_request_bloc.dart';

class SelectedDataCard extends StatefulWidget {
  final ServiceInfoEntity serviceInfoEntity;
  const SelectedDataCard({
    Key? key,
    required this.serviceInfoEntity,
  }) : super(key: key);

  @override
  State<SelectedDataCard> createState() => _SelectedDataCardState();
}

class _SelectedDataCardState extends State<SelectedDataCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCreateRequestBloc, UserCreateRequestState>(
      builder: (context, state) {
        return Container(
          child: Card(

            child: Container(
              padding: EdgeInsets.all(8),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Image.network(
                            Helpers.getImage(
                              widget.serviceInfoEntity.image,
                            ),
                            // width: 80,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                        '${widget.serviceInfoEntity.name} - ',
                                        style:const TextStyle(fontSize: 18)),
                                  ),
                                  Flexible(
                                    child: Text('${state.stateName}',
                                        style:const TextStyle(
                                            color: Colors.green, fontSize: 18)),
                                  ),
                                ],
                              ),
                              if (state.paymentStatus ==
                                  ServicePaymentType.free)
                                Text('FREE'),
                              if (state.paymentStatus !=
                                  ServicePaymentType.free)
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Payment: ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        '${state.paymentMethod!.getText()}',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                  ],
                                ),
                              if (state.paymentStatus !=
                                  ServicePaymentType.free)
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Promo Code: ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        '${state.promoCode == null ? 'NA' : state.promoCode!.promocode!.promoCode}',
                                        style:const TextStyle(color: Colors.green),
                                      ),
                                    ),
                                  ],
                                ),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 18, color: Colors.green),
                                  Text('${state.distance} KM'),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  ExpansionTile(
                    onExpansionChanged: (value) {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    trailing: Icon(
                      !isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
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
                        fontWeight:
                            isExpanded ? FontWeight.w700 : FontWeight.normal,
                      ),
                    ),
                    collapsedTextColor: Colors.green,
                    childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      if (widget.serviceInfoEntity.attributes != null &&
                          widget.serviceInfoEntity.attributes!.isNotEmpty)
                        ...widget.serviceInfoEntity.attributes!
                            .map((attribute) {

                          return Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  '${attribute.name}: ',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${state.selectedAttributes[attribute.id] ?? 'NA'}',
                                  style:const TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                              )
                            ],
                          );
                        }).toList()
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
