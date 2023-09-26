import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/utils/extensions/extensions.dart';
import 'package:masbar/features/user/services/presentation/request_service/user_choosen/widgets/step1/user_select_payment_method.dart';
import 'package:masbar/features/user/services/presentation/request_service/user_choosen/widgets/step1/user_select_promo_code.dart';
import '../../../../../../../../core/managers/languages_manager.dart';
import '../../../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../../../core/ui/widgets/app_drop_down.dart';
import '../../../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../../../../core/utils/enums/enums.dart';
import '../../../../../../../../core/utils/helpers/helpers.dart';
import '../../../../../../../../core/utils/helpers/show_custom_bottom_sheet.dart';
import '../../../../../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../../../../../../../localization/cubit/lacalization_cubit.dart';
import '../../../../../../../user_emirate/bloc/uae_states_bloc.dart';
import '../../../../../../../user_emirate/domain/entities/uae_state_entity.dart';
import '../../../../../domain/entities/service_info_entity.dart';
import '../../../masbar_choosen/bloc/service_details_bloc.dart';
import '../../bloc/user_create_request_bloc.dart';

class UserRequestStep1 extends StatelessWidget {
  final ServiceInfoEntity serviceInfoEntity;
  final Function changeCurrentTab;
  UserRequestStep1({
    Key? key,
    required this.serviceInfoEntity,
    required this.changeCurrentTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UaeStatesBloc, UaeStatesState>(
        builder: (context, state) {
      if (state is LoadingUaeStates) {
        return _buildLoading();
      } else if (state is UAEStatesOfflineState) {
        return _buildOffline(context);
      } else if (state is UAEStatesErrorState) {
        return _buildNetworkError(state, context);
      } else if (state is LoadedUaeStates) {
        return Scaffold(
            body: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildImage(),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildName(),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildStateDropDown(context, state),
                    const SizedBox(
                      height: 16,
                    ),
                    // _buildPrice(context),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // _buildHourlyPrice(context),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    _buildType(context),
                    const SizedBox(
                      height: 16,
                    ),
                    if (serviceInfoEntity.paymentStatus !=
                        ServicePaymentType.free)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPayementMethod(context),
                          const SizedBox(
                            height: 20,
                          ),
                          _buildPromoCode(context),
                        ],
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildSlider(context),
                    const SizedBox(
                      height: 10,
                    ),
                    if (serviceInfoEntity.attributes != null)
                      _buildAttributes(context, serviceInfoEntity)
                  ],
                ),
              ),
            ]),
            persistentFooterButtons: [
              _buildBottomBtn(context),
            ]);
      } else {
        return Container();
      }
    });
  }

  NetworkErrorWidget _buildNetworkError(
      UAEStatesErrorState state, BuildContext context) {
    return NetworkErrorWidget(
      message: state.message,
      onPressed: () {
        BlocProvider.of<UaeStatesBloc>(context).add(FetchUaeStatesEvent());
      },
    );
  }

  NoConnectionWidget _buildOffline(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<UaeStatesBloc>(context).add(FetchUaeStatesEvent());
      },
    );
  }

  LoadingWidget _buildLoading() {
    return const LoadingWidget();
  }

  Padding _buildBottomBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        child: Column(
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    EvaIcons.infoOutline,
                    size: 14.0,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: AppText(
                      "${AppLocalizations.of(context)!.youHaveMessage} ${context.read<AuthRepo>().getUserData()!.walletBalance ?? ""} ${AppLocalizations.of(context)?.availableBalanceMessage ?? ""} ",
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ]),
            const SizedBox(
              height: 6,
            ),
            BlocBuilder<UserCreateRequestBloc, UserCreateRequestState>(
              builder: (context, state) {
                return AppButton(
                  title: AppLocalizations.of(context)!.continueRequestService,
                  isDisabled: (state.paymentMethod == null &&
                      serviceInfoEntity.paymentStatus !=
                          ServicePaymentType.free),
                  onTap: () {
                    changeCurrentTab(1);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCode(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          AppLocalizations.of(context)?.promoCodeLabel ?? "",
          fontWeight: FontWeight.w600,
        ),
        InkWell(
          onTap: () {
            showCustomBottomSheet(
              context: context,
              child: BlocProvider.value(
                value: BlocProvider.of<UserCreateRequestBloc>(context),
                child: const UserSelectPromoCode(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<UserCreateRequestBloc, UserCreateRequestState>(
                    builder: (context, state) {
                      return AppText(
                        state.promoCode == null
                            ? AppLocalizations.of(context)!.selectPromoCode
                            : state.promoCode!.promocode!.promoCode!,
                        color: state.promoCode == null
                            ? Colors.grey
                            : Colors.black,
                      );
                    },
                  ),
                  const Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(BuildContext context) {
    return BlocBuilder<UserCreateRequestBloc, UserCreateRequestState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(AppLocalizations.of(context)!.distanceLabel),
              AppText(
                '${state.distance} KM',
                fontSize: 14,
              )
            ],
          ),
          SizedBox(
              width: double.infinity,
              child: Slider(
                value: state.distance,
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).primaryColor.withOpacity(0.25),
                max: 100,
                min: 10,
                divisions: 9,
                label: state.distance.round().toString(),
                onChanged: (double value) {
                  BlocProvider.of<UserCreateRequestBloc>(context)
                      .add(DistanceChangedEvent(distance: value));
                },
              )),
        ],
      ),
    );
  }

  Widget _buildPayementMethod(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            AppLocalizations.of(context)!.paymentTypeLabel,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              showCustomBottomSheet(
                context: context,
                child: BlocProvider.value(
                  value: BlocProvider.of<UserCreateRequestBloc>(context),
                  child: const UserSelectPaymentMethod(),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<UserCreateRequestBloc, UserCreateRequestState>(
                      builder: (context, state) {
                        return AppText(
                          state.paymentMethod == null
                              ? AppLocalizations.of(context)!
                                  .selectPaymentMethod
                              : state.paymentMethod!.getText(),
                          color: state.paymentMethod == null
                              ? Colors.grey
                              : Colors.black,
                        );
                      },
                    ),
                    const Icon(Icons.keyboard_arrow_down)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildType(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(AppLocalizations.of(context)!.serviceTypeLabel),
        AppText(
          serviceInfoEntity.paymentStatus!.getText(),
          fontSize: 15,
        ),
      ],
    );
  }

  Row _buildHourlyPrice(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(AppLocalizations.of(context)!.hourlyPriceLabel),
        AppText(
          "${serviceInfoEntity.hourlyPrice ?? ""} ${AppLocalizations.of(context)?.uadLabel ?? ""}",
          fontSize: 15,
        ),
      ],
    );
  }

  Row _buildPrice(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(AppLocalizations.of(context)!.priceLabel),
        AppText(
          "${serviceInfoEntity.basicPrice ?? ""} ${AppLocalizations.of(context)?.uadLabel ?? ""}",
          fontSize: 15,
        ),
      ],
    );
  }

  Center _buildImage() {
    return Center(
        child: Image.network(
      Helpers.getImage(serviceInfoEntity.image),
      height: 130,
    ));
  }

  BlocBuilder<LacalizationCubit, LacalizationState> _buildName() {
    return BlocBuilder<LacalizationCubit, LacalizationState>(
      builder: (context, state) {
        return Center(
          child: AppText(
            state.locale.languageCode == LanguagesManager.Arabic
                ? serviceInfoEntity.nameAr ?? ""
                : serviceInfoEntity.name ?? "",
            textAlign: TextAlign.center,
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  Widget _buildStateDropDown(
    BuildContext context,
    LoadedUaeStates uaeState,
  ) {
    return BlocBuilder<UserCreateRequestBloc, UserCreateRequestState>(
      builder: (context, state) {
        UAEStateEntity currentState = state.stateId == 0
            ? uaeState.states.firstWhere((element) =>
                element.id == context.read<AuthRepo>().getUserData()!.stateId)
            : uaeState.states
                .firstWhere((element) => element.id == state.stateId);
        if (state.stateName == '') {
          BlocProvider.of<UserCreateRequestBloc>(context).add(
            StateChangedEvent(
              stateName: currentState.state,
              state: currentState.id,
            ),
          );
        }
        return AppDropDown<UAEStateEntity>(
          hintText: AppLocalizations.of(context)!.choose_your_emirate,
          items: uaeState.states
              .map((e) => _buildDropMenuItem(context, e))
              .toList(),
          onChanged: (value) {
            BlocProvider.of<ServiceDetailsBloc>(context).add(FetchInfoEvent(
              serviceId: serviceInfoEntity.id!,
              stateId: value.id,
            ));
            BlocProvider.of<UserCreateRequestBloc>(context).add(
              StateChangedEvent(
                stateName: value.state,
                state: value.id,
              ),
            );
          },
          initSelectedValue: currentState,
        );
      },
    );
  }

  DropdownMenuItem<UAEStateEntity> _buildDropMenuItem(
      BuildContext context, UAEStateEntity e) {
    return DropdownMenuItem<UAEStateEntity>(
      value: e,
      child: Text(
        e.state,
      ),
    );
  }

  Widget _buildAttributes(
      BuildContext context, ServiceInfoEntity serviceInfoEntity) {
    return BlocBuilder<UserCreateRequestBloc, UserCreateRequestState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              ...serviceInfoEntity.attributes!.map((e) {
                if (e.autoComplete.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(e.name),
                      const SizedBox(
                        height: 4,
                      ),
                      AppDropDown<String>(
                        hintText: e.name,
                        items: e.autoComplete
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        initSelectedValue: state.selectedAttributes[e.id],
                        onChanged: (value) {
                          BlocProvider.of<UserCreateRequestBloc>(context).add(
                            AddAtributeChanged(
                              id: e.id,
                              value: value,
                            ),
                          );
                        },
                      ),
                      // Autocomplete<String>(
                      //   initialValue: TextEditingValue(
                      //       text: state.selectedAttributes[e] ?? ''),
                      //   fieldViewBuilder: (context, textEditingController,
                      //       focusNode, onFieldSubmitted) {
                      //     return TextFormField(
                      //       onChanged: (value) {
                      //         BlocProvider.of<UserCreateRequestBloc>(context)
                      //             .add(RemoveAtributeChanged(id: e.id));
                      //       },
                      //       cursorColor: Colors.white,
                      //       decoration: InputDecoration(
                      //         contentPadding: const EdgeInsets.all(8),
                      //         filled: true,
                      //         fillColor: Colors.white,
                      //         focusedBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //             width: 2,
                      //             color: Colors.grey.withOpacity(.3),
                      //           ),
                      //         ),
                      //         border: OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //             width: 2,
                      //             color: Colors.grey.withOpacity(.3),
                      //           ),
                      //         ),
                      //       ),
                      //       controller: textEditingController,
                      //       focusNode: focusNode,
                      //     );
                      //   },
                      //   optionsBuilder: (textEditingValue) {
                      //     if (textEditingValue.text.isEmpty) {
                      //       return const Iterable<String>.empty();
                      //     }
                      //     return e.autoComplete.where(
                      //       (element) => element.toLowerCase().contains(
                      //             textEditingValue.text.toLowerCase(),
                      //           ),
                      //     );
                      //   },
                      //   onSelected: (option) {
                      //     BlocProvider.of<UserCreateRequestBloc>(context).add(
                      //       AddAtributeChanged(
                      //         id: e.id,
                      //         value: option,
                      //       ),
                      //     );
                      //   },
                      // ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }).toList()
            ],
          ),
        );
      },
    );
  }
}
