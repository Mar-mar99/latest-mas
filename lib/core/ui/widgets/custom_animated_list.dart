import 'package:flutter/material.dart';

class CustomAnimatedList extends StatelessWidget {
  final List<Widget> itemsWidgets;
  final GlobalKey<AnimatedListState> keyList;
  final Tween<Offset> offset;

  const CustomAnimatedList({
    Key? key,
    required this.itemsWidgets,
    required this.keyList,
    required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      key: keyList,
      initialItemCount: itemsWidgets.length,
      itemBuilder: (context, index, animation) {
        return SlideTransition(
          position: animation.drive(offset),
          child: itemsWidgets[index],
        );
      },
    );
  }
}
