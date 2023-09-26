import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final AsyncCallback onChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  const CustomSwitch(
      {Key? key,
      required this.value,
      required this.onChanged,
      this.activeColor,
      this.inactiveColor})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late Animation _circleAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _circleAnimation = Tween(begin: 0.0, end: 30.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuint,
        reverseCurve: Curves.easeInQuint));
    if (widget.value) {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: Feedback.wrapForTap(() async {
            if (widget.value) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            await widget.onChanged();
          }, context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 60.0,
            height: 30.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: _circleAnimation.status == AnimationStatus.dismissed ||
                        _circleAnimation.status == AnimationStatus.reverse
                    ? widget.inactiveColor
                    : widget.activeColor),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 6.0, bottom: 6.0, right: 6.0, left: 6.0),
              child: Row(
                children: <Widget>[
                  Container(width: _circleAnimation.value),
                  Container(
                    width: 16.0,
                    height: 16.0,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.grey[800]!.withOpacity(0.15),
                          offset: const Offset(0, 4.0),
                          blurRadius: 5.0)
                    ], shape: BoxShape.circle, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

