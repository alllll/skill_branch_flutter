import 'dart:math';

import 'package:flutter/material.dart';

class TrinityCircularProgress extends StatefulWidget {
  final double percentage = 0;
  TrinityCircularProgress(
      {Key key,
      this.color1 = Colors.blue,
      this.color2 = Colors.lightBlue,
      this.color3 = Colors.lightBlueAccent})
      : super(key: key);
  final Color color1;
  final Color color2;
  final Color color3;
  @override
  _TrinityCircularProgressState createState() =>
      _TrinityCircularProgressState();
}

class _TrinityCircularProgressState extends State<TrinityCircularProgress>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  double oldPercentage;
  @override
  void initState() {
    oldPercentage = widget.percentage;
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.forward(from: 0);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.forward(from: 0);
    final dif = widget.percentage - oldPercentage;
    oldPercentage = widget.percentage;

    return Container(
      padding: EdgeInsets.all(50),
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: _Circle1(
                    color: widget.color1,
                    percentage:
                        (widget.percentage - dif) + (dif * controller.value),
                  ),
                )
              ],
            );
          }),
    );
  }
}

class _Circle1 extends CustomPainter {
  final Color color;
  final double percentage;

  _Circle1({@required this.percentage, @required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..color = color;

    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = min(size.width * 0.5, size.height * 0.5);

    double arcAngle = 2 * pi * (percentage / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
