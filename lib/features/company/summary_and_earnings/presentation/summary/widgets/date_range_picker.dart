import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../../core/ui/widgets/app_button.dart';

class DateRangePicker extends StatefulWidget {
  final DateTime? selectedFrom;
  final DateTime? selectedTo;
  final Function(DateTime from, DateTime to) select;

  const DateRangePicker(
      {Key? key, required this.select, this.selectedFrom, this.selectedTo})
      ;

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTime? startDate;
  DateTime? endDate;
  bool isHaveError = false;
  bool isHaveMaxDayError = false;
  List<DateTime> selectableDay = [];
  DateTime disabled = DateTime.now().add(const Duration(days: 10));
  PickerDateRange? initialSelectedRange;
  DateRangePickerController dateRangePickerController =
      DateRangePickerController();

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      startDate = args.value.startDate;
      endDate = args.value.endDate ?? args.value.startDate;
    });
  }

  @override
  void initState() {
    if (widget.selectedFrom != null && widget.selectedTo != null) {
      initialSelectedRange =
          PickerDateRange(widget.selectedFrom, widget.selectedTo);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.selectedDay)),
      body: Column(
        children: [
          Expanded(
            child: SfDateRangePicker(
              todayHighlightColor:
                  Theme.of(context).primaryColor.withOpacity(0.7),
              startRangeSelectionColor:
                  Theme.of(context).primaryColor.withOpacity(0.7),
              endRangeSelectionColor:
                  Theme.of(context).primaryColor.withOpacity(0.7),
              rangeSelectionColor:
                  Theme.of(context).primaryColor.withOpacity(0.1),
              controller: dateRangePickerController,
              navigationDirection: DateRangePickerNavigationDirection.vertical,
              onSelectionChanged: _onSelectionChanged,
              minDate: DateTime.now().subtract(const Duration(days: 60)),
              maxDate: DateTime.now().add(const Duration(days: 60)),
              selectionMode: DateRangePickerSelectionMode.range,
              enableMultiView: true,
              initialSelectedRange: initialSelectedRange,
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16),
        child: AppButton(
          title: AppLocalizations.of(context)?.selectedDayLabel ?? "",
          isDisabled: startDate == null || endDate == null,
          onTap: () {
            widget.select(startDate!, endDate!);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
