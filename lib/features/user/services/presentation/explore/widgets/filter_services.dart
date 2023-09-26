// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../domain/entities/category_entity.dart';
import '../bloc/search_services_bloc.dart';

class FilterServices extends StatelessWidget {
  final CategoryEntity? categoryEntity;
  const FilterServices({
    Key? key,
    required this.categoryEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: AppText(AppLocalizations.of(context)!.filterLabel,
                    bold: true, color: Colors.black),
              ),
              _buildType(context),
              const SizedBox(
                height: 8,
              ),
              _buildSlider(context),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCancelBtn(context),
                  const SizedBox(
                    width: 20,
                  ),
                  _buildFilterBtn(context),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildType(BuildContext context) {
    return BlocBuilder<SearchServicesBloc, SearchServicesState>(
        builder: (context, state) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppText(
                  AppLocalizations.of(context)!.typeLabel,
                ),
                Theme(
                  data: ThemeData.light(),
                  child: RadioListTile(
                      title: Text(
                        AppLocalizations.of(context)!.paidLabel,
                      ),
                      value: AppLocalizations.of(context)!.paidLabel,
                      groupValue: state.type,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) {

                        BlocProvider.of<SearchServicesBloc>(context)
                            .add(TypeChangedEvent(type: value!));

                      }),
                ),
                Theme(
                  data: ThemeData.light(),
                  child: RadioListTile(
                      title: Text(AppLocalizations.of(context)!.freeLabel),
                      value: AppLocalizations.of(context)!.freeLabel,
                      groupValue: state.type,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) {

                        BlocProvider.of<SearchServicesBloc>(context)
                            .add(TypeChangedEvent(type: value!));
                          
                      }),
                ),
              ],
            ));
  }

  Widget _buildSlider(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(AppLocalizations.of(context)!.distanceLabel),
        BlocBuilder<SearchServicesBloc, SearchServicesState>(
          builder: (context, state) => SizedBox(
              width: double.infinity,
              child: Slider(
                value: state.distance,
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).primaryColor.withOpacity(0.25),
                max: 100,
                divisions: 10,
                label: state.distance.round().toString(),
                onChanged: (double value) {
                  BlocProvider.of<SearchServicesBloc>(context)
                      .add(DistanceChangedEvent(distance: value));
                },
              )),
        )
      ],
    );
  }

  Expanded _buildFilterBtn(BuildContext context) {
    return Expanded(
      child: AppButton(
        title: AppLocalizations.of(context)!.filterLabel,
        onTap: () {
          BlocProvider.of<SearchServicesBloc>(context).add(FilterEvent(
              categoryId: categoryEntity == null ? null : categoryEntity?.id));
          Navigator.pop(context);
        },
      ),
    );
  }

  Expanded _buildCancelBtn(BuildContext context) {
    return Expanded(
      child: AppButton(
        title: AppLocalizations.of(context)!.cancelLabel,
        buttonColor: ButtonColor.transparentBorderPrimary,
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
