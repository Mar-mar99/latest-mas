import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  final FocusNode? focusNode;
  final String? validationError;
  final String? initialValue;
  final String? type;
  final IconData? suffixIcon;
  final GestureTapCallback? onSuffixTap;
  final Color? suffixIconColor;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final String? labelText;
  final FormFieldValidator<String>? validator;
  final bool autofocus;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final int? maxLines;
  final int? minLines;
  final GestureTapCallback? onTap;

  const AppTextField({
    Key? key,
    this.focusNode,
    this.validationError,
    this.initialValue,
    this.type,
    this.suffixIcon,
    this.onSuffixTap,
    this.suffixIconColor,
    this.prefix,
    this.readOnly = false,
    this.prefixIcon,
     this.controller,
    this.labelText,
    this.validator,
    this.suffix,
    this.autofocus = true,
    this.keyboardType,
    this.autofillHints,
    this.textInputAction,
    this.onSaved,
    this.maxLines = 1,
    this.onChanged,
    this.hintText,
    this.minLines = 1,
    this.onTap,
  }) : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool focus = false;
  bool view = false;

  get isValidationError =>
      widget.validationError != null && widget.validationError!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(() {
      if (mounted) {
        setState(() {
          focus = widget.focusNode!.hasFocus;
        });
      }
    });
  }

  Widget? _buildSuffixIcon() {
    switch (widget.type) {
      case "password":
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: view
              ? InkWell(
                  onTap: () {
                    setState(() {
                      view = false;
                    });
                  },
                  child: Icon(
                    EvaIcons.eye,
                    size: 24.0,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : InkWell(
                  onTap: () {
                    setState(() {
                      view = true;
                    });
                  },
                  child: Icon(
                    EvaIcons.eyeOff,
                    size: 24.0,
                    color: Colors.grey[500],
                  ),
                ),
        );
      default:
        if (widget.suffixIcon != null) {
          return InkWell(
              onTap: widget.onSuffixTap,
              child: Icon(widget.suffixIcon,
                  size: 22.0,
                  color: widget.suffixIconColor ?? Colors.grey[500]));
        } else {
          return null;
        }
    }
  }

  Widget? _buildOPrefixIcon() {
    switch (widget.type) {
      case "search":
        return Icon(EvaIcons.search, size: 20.0, color: Colors.grey[500]);
      default:
        if (widget.prefixIcon != null) {
          return Icon(widget.prefixIcon, size: 20.0, color: Colors.grey[500]);
        } else {
          return null;
        }
    }
  }

  bool _determineReadOnly() {
    if (widget.readOnly) {
      widget.focusNode?.unfocus();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: widget.autofillHints,
      onTap: widget.readOnly ? widget.onTap : () {},
      scrollPhysics: const BouncingScrollPhysics(),
      focusNode: widget.focusNode,
      readOnly: _determineReadOnly(),
      initialValue:widget. initialValue,
      keyboardType: widget.keyboardType,
      obscureText: (widget.type == "password" && !view),
      autofocus: widget.autofocus,
      validator: widget.validator,
      onSaved: widget.onSaved,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      onChanged: widget.onChanged,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        // fontFamily: 'OpenSans',
        color: Color(0xFF1a1a1a),
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        suffixIcon: _buildSuffixIcon(),
        prefix: widget.prefix,
        suffix: widget.suffix,
        prefixIcon: _buildOPrefixIcon(),
        // labelText: focus || widget.controller.text.isNotEmpty? widget.labelText: widget.hintText,
        hintText: widget.hintText,
        contentPadding: EdgeInsets.all(9),
        hintStyle: const TextStyle(
          fontSize: 14,
          // fontFamily: 'OpenSans',
          color: Color(
            0xff888888,
          ),
        ),
        labelStyle: const TextStyle(
          fontSize: 14,
          // fontFamily: 'OpenSans',
          color: Color(
            0xff1a1a1a,
          ),
        ),

        filled: true,
        prefixIconConstraints: BoxConstraints(minWidth: 30, minHeight: 30),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide:
              BorderSide(color: Colors.grey.withOpacity(.3), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide:
              BorderSide(color: Colors.grey.withOpacity(.3), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide:
              BorderSide(color: Colors.grey.withOpacity(.3), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide:
              BorderSide(color: Colors.grey.withOpacity(.3), width: 2),
        ),
      ),
    );
  }
}
