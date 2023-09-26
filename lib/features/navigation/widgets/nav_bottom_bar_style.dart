
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class StyleNavBottomBar extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 6;

  @override
  double get iconSize => 30;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(fontSize: 14, color: color, letterSpacing: 0,overflow: TextOverflow.ellipsis);
  }


}
