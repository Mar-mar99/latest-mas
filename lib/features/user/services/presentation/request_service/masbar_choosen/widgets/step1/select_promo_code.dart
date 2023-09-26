import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../../../core/ui/widgets/app_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../../promo_code/data/data_source/promo_code_data_source.dart';
import '../../../../../../promo_code/data/repositories/promo_code_repo_impl.dart';
import '../../../../../../promo_code/domain/entities/promo_code_entity.dart';
import '../../../../../../promo_code/domain/use_cases/get_promos_use_case.dart';
import '../../../../../../promo_code/presentation/bloc/get_promos_bloc.dart';
import '../../../../../../promo_code/presentation/bloc/get_promos_event.dart';
import '../../../../../../promo_code/presentation/screens/promo_code_screen.dart';
import '../../bloc/create_request_bloc.dart';

class SelectPromoCode extends StatefulWidget {
  const SelectPromoCode({super.key});

  @override
  State<SelectPromoCode> createState() => _SelectPromoCodeState();
}

class _SelectPromoCodeState extends State<SelectPromoCode> {
  PromoCodeEntity? selected;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(),
      child: Builder(builder: (context) {
        return BlocBuilder<GetPromosBloc, GetPromosState>(
            builder: (context, state) {
          if (state is LoadingGetPromos) {
            return const LoadingWidget();
          } else if (state is GetPromosOfflineState) {
            return NoConnectionWidget(onPressed: () {
              BlocProvider.of<GetPromosBloc>(context).add(GetPromosDataEvent());
            });
          } else if (state is GetPromosErrorState) {
            return NetworkErrorWidget(
                message: state.message,
                onPressed: () {
                  BlocProvider.of<GetPromosBloc>(context)
                      .add(GetPromosDataEvent());
                });
          } else if (state is LoadedGetPromos) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Column(
                    children: [
                      _buildTitle(context),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildPromoList(state, context),
                      const SizedBox(
                        height: 15,
                      ),
                      _buildAddBtn(context),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildSelectBtn(context)
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
      }),
    );
  }

  Row _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          AppLocalizations.of(context)?.selectPromoCodeLabel ?? "",
          fontSize: 16,
          color: const Color(0xff343135),
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Container _buildPromoList(LoadedGetPromos state, BuildContext context) {
    return Container(
      // height: state.promos.isEmpty ? 0 : 200,
      child: Column(
        children:
            state.promos.map((e) => _buildItem(state, e, context)).toList(),
      ),
    );
  }

  AppButton _buildAddBtn(BuildContext context) {
    return AppButton(
      buttonColor: ButtonColor.transparentBorderPrimary,
      icon: Icon(
        Icons.add,
        color: Theme.of(context).primaryColor,
      ),
      title: AppLocalizations.of(context)?.add ?? "",
      onTap: () {
        Navigator.pushNamed(context, PromoCodeScreen.routeName);
      },
    );
  }

  AppButton _buildSelectBtn(BuildContext context) {
    return AppButton(
      title: AppLocalizations.of(context)!.select,
      // isDisabled: selected == null,
      onTap: () {
        if (selected == null) {
            BlocProvider.of<CreateRequestBloc>(context).add(
            WithPromoChangedEvent(
              withPromo: false,
            ),
          );
        } else {
          BlocProvider.of<CreateRequestBloc>(context).add(
            PromoCodeChangedEvent(
              promoCode: selected!,
            ),
          );
        }
        Navigator.pop(context);
      },
      buttonColor: ButtonColor.primary,
    );
  }

  Widget _buildItem(
      LoadedGetPromos state, PromoCodeEntity promo, BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              selected = promo;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: selected?.id == promo.id
                        ? Theme.of(context).primaryColor
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(promo.promocode?.promoCode ?? ""),
                  if (selected?.id == promo.id)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                    )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  GetPromosBloc _getBloc() {
    return GetPromosBloc(
      getPromosUseCase: GetPromosUseCase(
        getPromoCode: PromoCodeRepoImpl(
          promoCodeDataSource: PromoCodeDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetPromosDataEvent());
  }
}
