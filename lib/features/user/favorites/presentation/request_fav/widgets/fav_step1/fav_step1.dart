import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/utils/extensions/extensions.dart';
import 'package:masbar/features/user/favorites/presentation/request_fav/widgets/fav_step1/select_payment_mode_fav.dart';
import 'package:masbar/features/user/favorites/presentation/request_fav/widgets/fav_step1/select_promo_code_fav.dart';
import '../../../../../../../core/managers/languages_manager.dart';
import '../../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../../core/ui/widgets/app_drop_down.dart';
import '../../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../../../core/utils/enums/enums.dart';
import '../../../../../../../core/utils/helpers/helpers.dart';
import '../../../../../../../core/utils/helpers/show_custom_bottom_sheet.dart';
import '../../../../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../../../../../../localization/cubit/lacalization_cubit.dart';
import '../../../../../../user_emirate/bloc/uae_states_bloc.dart';
import '../../../../../../user_emirate/domain/entities/uae_state_entity.dart';
import '../../../../../services/domain/entities/service_info_entity.dart';
import '../../../../../services/presentation/request_service/masbar_choosen/bloc/service_details_bloc.dart';
import '../../bloc/request_fav_provider_bloc.dart';

class FavStep1 extends StatelessWidget {
  final ServiceInfoEntity serviceInfoEntity;
  final Function changeCurrentTab;
  FavStep1({
    Key? key,
    required this.serviceInfoEntity,
    required this.changeCurrentTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UaeStatesBloc, UaeStatesState>(
        builder: (context, state) {
      if (state is LoadingUaeStates) {
        return const LoadingWidget();
      } else if (state is UAEStatesOfflineState) {
        return NoConnectionWidget(
          onPressed: () {
            BlocProvider.of<UaeStatesBloc>(context).add(FetchUaeStatesEvent());
          },
        );
      } else if (state is UAEStatesErrorState) {
        return NetworkErrorWidget(
          message: state.message,
          onPressed: () {
            BlocProvider.of<UaeStatesBloc>(context).add(FetchUaeStatesEvent());
          },
        );
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
                      height: 14,
                    ),
                    _buildSlider(context),
                    const SizedBox(
                      height: 14,
                    ),
                    // if (serviceInfoEntity.attributes != null)
                    //   _buildAttributes(context, serviceInfoEntity)
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
            BlocBuilder<RequestFavProviderBloc, RequestFavProviderState>(
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
                value: BlocProvider.of<RequestFavProviderBloc>(context),
                child: const SelectPromoCodeFav(),
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
                 BlocBuilder<RequestFavProviderBloc, RequestFavProviderState>(
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
                  value: BlocProvider.of<RequestFavProviderBloc>(context),
                  child: const SelectPaymentMethodFav(),
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
                   BlocBuilder<RequestFavProviderBloc, RequestFavProviderState>(

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

  Widget _buildSlider(BuildContext context) {
    return   BlocBuilder<RequestFavProviderBloc, RequestFavProviderState>(
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
                  BlocProvider.of<RequestFavProviderBloc>(context)
                      .add(DistanceChangedEvent(distance: value));
                },
              )),
        ],
      ),
    );
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
    return  BlocBuilder<RequestFavProviderBloc, RequestFavProviderState>(

      builder: (context, state) {
        UAEStateEntity currentState = state.stateId == 0
            ? uaeState.states.firstWhere((element) =>
                element.id == context.read<AuthRepo>().getUserData()!.stateId)
            : uaeState.states
                .firstWhere((element) => element.id == state.stateId);
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
            BlocProvider.of<RequestFavProviderBloc>(context).add(
              StateChangedEvent(
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
}
