// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/utils/helpers/helpers.dart';

import '../../../company_services/domain/entities/company_service_entity.dart';
import '../../domain/entities/services_prices_entity.dart';
import '../bloc/update_prices_bloc.dart';
import 'edit_dialog.dart';

class PricesTable extends StatelessWidget {
  final List<ServicePriceEntity> prices;
  final CompanyServiceEntity serviceEntity;
  const PricesTable({
    Key? key,
    required this.prices,
    required this.serviceEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      horizontalMargin: 0,
      columns: getColumns(context),
      rows: getRows(context, prices),
    );
  }

  List<DataColumn> getColumns(BuildContext context) {
    var columns = [
      AppLocalizations.of(context)!.state,
      AppLocalizations.of(context)!.fixed_price,
      AppLocalizations.of(context)!.hourly_price,
    ];
    return columns
        .map(
          (e) => DataColumn(
            label: Text(
              e,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        )
        .toList();
  }

  List<DataRow> getRows(BuildContext context, List<ServicePriceEntity> prices) {
    return prices.map((priceRow) {
      List cells = [
        priceRow.stateName,
        priceRow.fixedPrice,
        priceRow.hourlyPrice
      ];

      return DataRow(
        cells: Helpers.modelBuilder(
          cells,
          (index, cell) {
            return DataCell(
                Text(
                  '$cell',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                showEditIcon: index > 0, onTap: () async {
              switch (index) {
                case 1:
                  await editFixedPrice(context, priceRow);
                  break;
                case 2:
                  await editHourlyPrice(context, priceRow);
                  break;
              }
            });
          },
        ),
      );
    }).toList();
  }

  Future editFixedPrice(
      BuildContext context, ServicePriceEntity editablePriceRow) async {
    final newFixedPrice = await showDialog(
      context: context,
      builder: (context) => EditDialog(
        title:
           AppLocalizations.of(context)!.edit_fixed_price(serviceEntity.name,editablePriceRow.stateName),
        value: editablePriceRow.fixedPrice.toString(),
      ),
    );
    if (newFixedPrice != null) {
      BlocProvider.of<UpdatePricesBloc>(context).add(
        UpdateEvent(
          serviceId: serviceEntity.id,
          stateId: editablePriceRow.stateid,
          fixed: double.parse(newFixedPrice),
          hourly: double.parse(editablePriceRow.hourlyPrice.toString()),
        ),
      );
    }
  }

  Future editHourlyPrice(
      BuildContext context, ServicePriceEntity editablePriceRow) async {
    final newHourlyPrice = await showDialog(
      context: context,
      builder: (context) => EditDialog(
        title:AppLocalizations.of(context)!.edit_hourly_price(serviceEntity.name,editablePriceRow.stateName),

        value: editablePriceRow.hourlyPrice.toString(),
      ),
    );
    if (newHourlyPrice != null) {
      BlocProvider.of<UpdatePricesBloc>(context).add(
        UpdateEvent(
          serviceId: serviceEntity.id,
          stateId: editablePriceRow.stateid,
          fixed: double.parse(editablePriceRow.fixedPrice.toString()),
          hourly: double.parse(newHourlyPrice),
        ),
      );
    }
  }
}
