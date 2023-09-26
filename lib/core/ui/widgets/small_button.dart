import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:masbar/core/ui/widgets/app_text.dart';

class SmallButton extends StatelessWidget {
  const SmallButton({
    Key? key,
    this.title,
    this.onTap,
    this.color,
    this.textColor,
    this.loading = false,
    this.padding,
    this.width,
    this.icon,
  }) : super(key: key);
  final String? title;
  final void Function()? onTap;
  final Color? color;
  final Color? textColor;
  final bool? loading;
  final EdgeInsets? padding;
  final double? width;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: padding ?? const EdgeInsets.all(8),
        child: loading!
            ? Padding(
                padding: EdgeInsets.all(3),
                child: SpinKitThreeBounce(
                  size: 13,
                  color: textColor,
                ),
              )
            :
             Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      color: textColor,
                    ),
                  if (icon != null)
                   const SizedBox(
                      width: 8,
                    ),
                  Text(
                    title!,
                    style:TextStyle(   color: textColor,fontWeight: FontWeight.normal)
                 ,
                  ),
                ],
              ),
      ),
    );
  }
}
