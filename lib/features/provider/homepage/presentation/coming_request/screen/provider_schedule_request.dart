import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../bloc/suggest_time_bloc.dart';

class ProviderScheduleRequest extends StatefulWidget {
  final int requestId;
  const ProviderScheduleRequest({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  State<ProviderScheduleRequest> createState() =>
      _ProviderScheduleRequestState();
}

class _ProviderScheduleRequestState extends State<ProviderScheduleRequest> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<SuggestTimeBloc>(),
      child: Column(
        children: [
          Text('Suggest another Time', textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
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
  }

  TextButton _buildDoneBtn(BuildContext context) {
    return TextButton(
      onPressed: () {
        BlocProvider.of<SuggestTimeBloc>(context).add(
          SuggestAnotherTimeEvent(
            date: selectedDate,
            time: selectedDate,
            requestId: widget.requestId,
          ),
        );
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
