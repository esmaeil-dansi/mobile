import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final double animationRange;
  final ShakeWidgetController controller;
  final Duration animationDuration;

  const ShakeWidget({
    super.key,
    required this.child,
    this.animationRange = 24,
    required this.controller,
    this.animationDuration = const Duration(milliseconds: 400),
  });

  @override
  ShakeWidgetState createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: widget.animationDuration, vsync: this);

    widget.controller.setState(this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final offsetAnimation = Tween(begin: 0.0, end: widget.animationRange)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        }
      });

    return AnimatedBuilder(
      animation: offsetAnimation,
      builder: (context, child) {
        return Container(
          transform: Matrix4.translationValues(offsetAnimation.value, 0, 0),
          // padding: EdgeInsetsDirectional.only(
          //   start: offsetAnimation.value + widget.horizontalPadding,
          //   end: widget.horizontalPadding - offsetAnimation.value,
          // ),
          child: widget.child,
        );
      },
    );
  }
}

class ShakeWidgetController {
  late ShakeWidgetState _state;

  void setState(ShakeWidgetState state) {
    _state = state;
  }

  Future<void> shake() {
    return _state.animationController.forward(from: 0.0);
  }
}
