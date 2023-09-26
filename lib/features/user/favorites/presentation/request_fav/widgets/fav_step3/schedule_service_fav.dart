import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../../core/utils/helpers/show_custom_bottom_sheet.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../bloc/request_fav_provider_bloc.dart';

class ScheduleServiceFav extends StatefulWidget {
  const ScheduleServiceFav({super.key});

  @override
  State<ScheduleServiceFav> createState() => _ScheduleServiceFavState();
}

class _ScheduleServiceFavState extends State<ScheduleServiceFav> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
        onPressed: () {
          showCustomBottomSheet(
            context: context,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCancelBtn(context),
                      _buildDoneBtn(context),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    use24hFormat: true,
                    backgroundColor: Colors.white,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (value) {
                      setState(() {
                        selectedDate = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
        icon: Icon(
          EvaIcons.calendar,
          size: 24.0,
          color: Theme.of(context).primaryColor,
        ),
        label: _buildDateTimeText(context));
    // InkWell(
    //   onTap: () {
    //     showCustomBottomSheet(
    //       context: context,
    //       child: Column(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 _buildCancelBtn(context),
    //                 _buildDoneBtn(context),
    //               ],
    //             ),
    //           ),
    //           SizedBox(
    //             height: 200,
    //             child: CupertinoDatePicker(
    //               use24hFormat: true,
    //               backgroundColor: Colors.white,
    //               initialDateTime: DateTime.now(),
    //               onDateTimeChanged: (value) {
    //                 setState(() {
    //                   selectedDate = value;
    //                 });
    //               },
    //             ),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    //   child: Row(
    //     children: [
    //       Icon(
    //         EvaIcons.calendar,
    //         size: 30.0,
    //         color: Theme.of(context).primaryColor,
    //       ),
    //       const SizedBox(width: 8.0),
    //       _buildDateTimeText(context)
    //     ],
    //   ),
    // );
  }

  Widget _buildDateTimeText(BuildContext context) {
    return BlocBuilder<RequestFavProviderBloc, RequestFavProviderState>(
      builder: (context, state) {
        return AppText((state.scheduleDate != null &&
                state.scheduleTime != null)
            ? ("${DateFormat.yMMMMd().format(state.scheduleDate!)} ${DateFormat.Hm().format(
                state.scheduleTime!,
              )}")
            : AppLocalizations.of(context)!.selectDateMessage);
      },
    );
  }

  TextButton _buildDoneBtn(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedDate ??= DateTime.now();
        });
        BlocProvider.of<RequestFavProviderBloc>(context).add(
          DateChangedEvent(
            date: selectedDate!,
          ),
        );
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 16,
        ),
      ),
      child: Text(AppLocalizations.of(context)!.ok),
    );
  }

  TextButton _buildCancelBtn(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 16,
        ),
      ),
      child: Text(
        AppLocalizations.of(context)!.cancel,
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
