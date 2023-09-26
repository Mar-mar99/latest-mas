// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class ProviderNumberPickerWidget extends StatefulWidget {
  final int value;
  final Function okHandler;
  final Function cancelHandler;
  const ProviderNumberPickerWidget({
    Key? key,
    required this.value,
    required this.okHandler,
    required this.cancelHandler,
  }) : super(key: key);

  @override
  State<ProviderNumberPickerWidget> createState() => _ProviderNumberPickerWidgetState();
}

class _ProviderNumberPickerWidgetState extends State<ProviderNumberPickerWidget> {
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
