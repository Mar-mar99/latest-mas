// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppDropDown<T> extends StatefulWidget {
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final T? initSelectedValue;
  final Function(dynamic) onChanged;
  const AppDropDown({
    Key? key,
    required this.hintText,
    required this.items,
    required this.initSelectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<AppDropDown<T>> createState() => _AppDropDownState<T>();
}

class _AppDropDownState<T> extends State<AppDropDown<T>> {
  T? selectedValue;
  @override
  void initState() {
    super.initState();
    selectedValue = widget.initSelectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.withOpacity(.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          child: DropdownButton<T>(
            value: selectedValue,
            hint: Text(
              widget.hintText,
              style: const TextStyle(fontSize: 14, color: Color(0xff888888)),
            ),
            items: widget.items,
            onChanged: (value) {
              widget.onChanged(value);
              setState(() {
                selectedValue = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
