library widget_circular_animator;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class WidgetCircularAnimator extends StatefulWidget {
  final Color innerColor;
  final Color outerColor;
  final double innerIconsSize;
  final double size;
  final double outerIconsSize;
  final int innerAnimationSeconds;
  final int outerAnimationSeconds;
  final Widget child;

  const WidgetCircularAnimator({
    @required this.child,
    this.innerColor = Colors.deepOrange,
    this.outerColor = Colors.deepOrange,
    this.size = 200,
    this.innerIconsSize = 3,
    this.outerIconsSize = 3,
    this.innerAnimationSeconds = 30,
    this.outerAnimationSeconds = 30,
  }) : assert(child != null);

  @override
  _WidgetAnimatorState createState() => _WidgetAnimatorState();
}

class _WidgetAnimatorState extends State<WidgetCircularAnimator>
    with TickerProviderStateMixin {
  Animation<double> animation1;
  Animation<double> animation2;
  AnimationController controller2;
  AnimationController controller1;

  @override
  void initState() {
    super.initState();
    initAnimations();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          _firstArc(),
          _secondArc(),
          _child(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller2.dispose();
    controller1.dispose();
    super.dispose();
  }

  _child() {
    return Center(
      child: Container(
        width: widget.size * 0.7,
        height: widget.size * 0.7,
        child: widget.child,
      ),
    );
  }

  _secondArc() {
    return Center(
      child: RotationTransition(
        turns: animation2,
        child: CustomPaint(
          painter: Arc2Painter(
              color: widget.outerColor, iconsSize: widget.innerIconsSize),
          child: Container(
            width: widget.size,
            height: widget.size,
          ),
        ),
      ),
    );
  }

  _firstArc() {
    return Center(
      child: RotationTransition(
        turns: animation1,
        child: CustomPaint(
          painter: Arc1Painter(
              color: widget.innerColor, iconsSize: widget.outerIconsSize),
          child: Container(
            width: 0.85 * widget.size,
            height: 0.85 * widget.size,
          ),
        ),
      ),
    );
  }

  void initAnimations() {
    controller1 = AnimationController(
        duration: Duration(seconds: widget.innerAnimationSeconds), vsync: this);

    controller2 = AnimationController(
        duration: Duration(seconds: widget.outerAnimationSeconds), vsync: this);

    animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller1, curve: Interval(0.0, 1.0, curve: Curves.linear)));

    animation2 = ReverseAnimation(Tween<double>(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: controller2,
            curve: Interval(0.0, 1.0, curve: Curves.linear))));

    controller2.repeat();
    controller1.repeat();
  }
}

class Arc2Painter extends CustomPainter {
  final Color color;
  final double iconsSize;

  Arc2Painter({this.color, this.iconsSize = 3});

  @override
  void paint(Canvas canvas, Size size) {
    Paint p = new Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);

    canvas.drawArc(rect, 0.0, 0.67 * pi, false, p);
    canvas.drawArc(rect, 0.74 * pi, 0.65 * pi, false, p);
    canvas.drawArc(rect, 1.46 * pi, 0.47 * pi, false, p);

    //first shape
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.2 - iconsSize,
            size.width * 0.9 - iconsSize, iconsSize * 2, iconsSize * 2),
        p);

    //second shape
    //draw the inner cross
    var centerX = size.width * 0.385;
    var centerY = size.width * 0.015;
    var lineLength = iconsSize / 2;
    canvas.drawLine(new Offset(centerX - lineLength, centerY + lineLength),
        new Offset(centerX + lineLength, centerY - lineLength), p);
    canvas.drawLine(new Offset(centerX + lineLength, centerY + lineLength),
        new Offset(centerX - lineLength, centerY - lineLength), p);
    // the circle
    canvas.drawCircle(
        Offset(size.width * 0.385, size.width * 0.015), iconsSize + 1, p);

    // third shape
    canvas.drawOval(
        Rect.fromLTWH(size.width - iconsSize * 1.5,
            size.width * 0.445 - iconsSize, iconsSize * 3, iconsSize * 2),
        p);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Arc1Painter extends CustomPainter {
  final Color color;
  final double iconsSize;

  Arc1Painter({this.color, this.iconsSize = 3});

  @override
  void paint(Canvas canvas, Size size) {
    Paint p = new Paint()
      ..color = color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Rect rect = new Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawArc(rect, 0.15, 0.9 * pi, false, p);
    canvas.drawArc(rect, 1.05 * pi, 0.9 * pi, false, p);

    // draw the cross
    var centerY = size.width / 2;
    canvas.drawLine(new Offset(-iconsSize, centerY - iconsSize),
        new Offset(iconsSize, centerY + iconsSize), p);
    canvas.drawLine(new Offset(iconsSize, centerY - iconsSize),
        new Offset(-iconsSize, centerY + iconsSize), p);

    // draw the circle
    canvas.drawCircle(Offset(size.width, size.width / 2), iconsSize, p);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
