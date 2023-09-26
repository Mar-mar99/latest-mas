import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum ButtonColor {
  primary,
  blue,
  withe,
  transparent,
  transparentBorderPrimary,
  green
}

class AppButton extends StatefulWidget {
  const AppButton(
      {Key? key,
      this.title = "",
      this.icon,
      this.width = 0,
      this.height = 0,
      this.onTap,
      this.isLoading = false,
      this.buttonColor = ButtonColor.primary,
      this.isDisabled = false,
      this.loadingTitle = "",
      this.isSmall = false})
      : super(key: key);

  final String title;
  final Widget? icon;
  final VoidCallback? onTap;
  final bool isLoading;
  final ButtonColor buttonColor;
  final bool isDisabled;
  final String loadingTitle;
  final double width;
  final double height;
  final bool isSmall;

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with TickerProviderStateMixin {
  double _buttonSize = 1.0;
  late AnimationController _animationController;
  late Animation<dynamic> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        lowerBound: 0.7,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 120));
    _animation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuad,
        reverseCurve: Curves.easeOutQuad);
    _animation.addListener(() {
      setState(() {
        _buttonSize = _animation.value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Gradient? _buildGradient() {
    switch (widget.buttonColor) {
      case ButtonColor.primary:
        return const LinearGradient(
          colors: <Color>[
            Color(0xffff3939),
            Color(0xffffa4a4),
          ],
          begin: Alignment(1, -1),
          end: Alignment(-1.2, 2),
        );
      case ButtonColor.blue:
        return const LinearGradient(
          colors: <Color>[
            Color(0xff007bc0),
            Color(0xff43bbff),
          ],
          begin: Alignment(1, -1),
          end: Alignment(-1.2, 2),
        );
      case ButtonColor.transparent:
      case ButtonColor.withe:
      case ButtonColor.green:
      case ButtonColor.transparentBorderPrimary:
        return null;
    }
  }

  Widget _buildIcon() {
    if (widget.icon != null && (widget.title != "")) {
      return Container(
        margin: const EdgeInsets.only(right: 12.0),
        height: 24.0,
        child: widget.icon,
      );
    } else if (widget.icon != null) {
      return SizedBox(
        height: 18.0,
        width: 18.0,
        child: widget.icon,
      );
    } else {
      return Container();
    }
  }

  Color _buttonColor() {
    switch (widget.buttonColor) {
      case ButtonColor.primary:
        return widget.isDisabled
            ? Theme.of(context).primaryColor.withOpacity(.3)
            : Theme.of(context).primaryColor;
      case ButtonColor.blue:
        return widget.isDisabled
            ? const Color(0xffff3939)
            : const Color(0xffff3939).withOpacity(0.30);
      case ButtonColor.withe:
        return Colors.white;
      case ButtonColor.transparent:
        return Colors.white;
      case ButtonColor.transparentBorderPrimary:
        return Colors.transparent;
      case ButtonColor.green:
        return Colors.green;
    }
  }

  Color fontColor() {
    switch (widget.buttonColor) {
      case ButtonColor.withe:
        return Theme.of(context).primaryColor;
      case ButtonColor.transparent:
      case ButtonColor.primary:
      case ButtonColor.blue:
      case ButtonColor.green:
        return Colors.white;
      case ButtonColor.transparentBorderPrimary:
        return Color(0xffff3939);
    }
  }

  List<BoxShadow>? boxShadow() {
    switch (widget.buttonColor) {
      case ButtonColor.primary:
      case ButtonColor.blue:
      case ButtonColor.withe:
        return !widget.isDisabled
            ? <BoxShadow>[
                BoxShadow(
                    color: const Color(0xff290000).withOpacity(0.3),
                    spreadRadius:
                        _buttonSize < 1.0 ? -(1 - _buttonSize) * 50 : 0.0,
                    offset: const Offset(0, 2.0),
                    blurRadius: 3.0)
              ]
            : null;

      case ButtonColor.transparent:
      case ButtonColor.transparentBorderPrimary:
      case ButtonColor.green:
        return null;
    }
  }

  BoxBorder? boxBorder() {
    switch (widget.buttonColor) {
      case ButtonColor.primary:
      case ButtonColor.blue:
      case ButtonColor.withe:
      case ButtonColor.green:
        return null;
      case ButtonColor.transparent:
        return Border.all(color: Colors.white, width: 1);
      case ButtonColor.transparentBorderPrimary:
        return Border.all(color: Color(0xffff3939), width: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.isDisabled || widget.isLoading,
      child: GestureDetector(
        onTapDown: (TapDownDetails tap) {
          _animationController.reverse(from: 1.0);
        },
        onTapUp: (TapUpDetails tap) {
          _animationController.forward();
        },
        onTapCancel: () {
          _animationController.forward();
        },
        onTap: Feedback.wrapForTap(widget.onTap, context),
        behavior: HitTestBehavior.opaque,
        child: Transform.scale(
            scale: _buttonSize,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              // margin: EdgeInsets.only(
              //     bottom: widget.isSmall
              //         ? 0
              //         : widget.title.isNotEmpty
              //             ? 12.0
              //             : 0.0),
              padding: EdgeInsets.symmetric(
                  vertical: widget.isSmall
                      ? 0
                      : widget.title.isNotEmpty
                          ? 8.0
                          : 10.0,
                  horizontal: widget.isSmall
                      ? 0
                      : widget.title.isNotEmpty
                          ? 20.0
                          : 17),
              decoration: BoxDecoration(
                  border: boxBorder(),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  color: _buttonColor(),
                  gradient: _buildGradient(),
                  boxShadow: boxShadow()),
              child: SizedBox(
                height: widget.isSmall
                    ? 25
                    : widget.height > 0
                        ? widget.height
                        : 35,
                width: widget.isSmall
                    ? 100
                    : widget.width > 0
                        ? widget.width
                        : double.maxFinite,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildIcon(),
                    widget.isLoading
                        ? Padding(
                            padding: EdgeInsets.all(widget.isSmall ? 4 : 2.7),
                            child: SizedBox(
                              height: widget.isSmall ? 10 : 19.0,
                              child: Row(
                                children: <Widget>[
                                  SpinKitCircle(
                                    color: widget.buttonColor ==
                                            ButtonColor.transparentBorderPrimary
                                        ? Theme.of(context).primaryColor
                                        : Colors
                                            .white, //Theme.of(context).backgroundColor,
                                    size: 22,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    widget.loadingTitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: fontColor(),
                                      fontSize: widget.isSmall ? 12 : 17.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Flexible(
                          child: Center(
                            child: Text(
                                widget.title,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: fontColor(),
                                  fontSize: widget.isSmall ? 12 : 17.0,
                                  //  fontFamily: "OpenSans",
                                ),
                              ),
                          ),
                        )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
