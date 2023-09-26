import 'package:flutter/material.dart';
import '../../managers/color_manager.dart';
class CustomTextField extends StatelessWidget {
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final String hintText;
  final IconData? iconData;
  final Color backgroundColor;
  final bool isObscure;
  final bool? isNumber;
  final String? initalValue;
  final TextEditingController? textEditingController;
  final Function? onChanged;
  final Function(String?) validator;

  const CustomTextField(
      {Key? key,
      required this.textInputAction,
      required this.textInputType,
      required this.hintText,
      this.iconData,
      this.backgroundColor = Colors.white,
      this.textEditingController,
      this.initalValue,
      this.onChanged,
      this.isNumber,
      required this.validator,
      required this.isObscure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: TextFormField(
        textInputAction: textInputAction,
        keyboardType: textInputType,
        cursorColor: ColorManager.primary,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        textAlignVertical: TextAlignVertical.center,
        controller: textEditingController,
        decoration: __buildFieldDecoration(
          hint: hintText,
          icon: iconData,
        ),
        initialValue: initalValue,
        onChanged: (value) {
          if (onChanged != null) {
            onChanged!(value);
          }
        },
        obscureText: isObscure,
        validator: (value) {
          return validator(value);
        },
      ),
    );
  }

  InputDecoration __buildFieldDecoration(
      {required String hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null
          ? Icon(
              icon,
            )
          : null,
    );
  }
}
