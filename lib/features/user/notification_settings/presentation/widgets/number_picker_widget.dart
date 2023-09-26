// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class NumberPickerWidget extends StatefulWidget {
  final int value;
  final Function okHandler;
  final Function cancelHandler;
  const NumberPickerWidget({
    Key? key,
    required this.value,
    required this.okHandler,
    required this.cancelHandler,
  }) : super(key: key);

  @override
  State<NumberPickerWidget> createState() => _NumberPickerWidgetState();
}

class _NumberPickerWidgetState extends State<NumberPickerWidget> {
  late int selectedValue;
  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      NumberPicker(
        value: selectedValue,
        minValue: 0,
        maxValue: 60,
        zeroPad: false,
        axis: Axis.vertical,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                widget.cancelHandler();
              },
              child: Text('cancel')),
          TextButton(
              onPressed: () {
                widget.okHandler(selectedValue);
              },
              child: Text('ok')),
        ],
      )
    ]);
  }
}
