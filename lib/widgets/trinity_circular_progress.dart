import 'dart:math';

import 'package:flutter/material.dart';

class TrinityCircularProgress extends StatefulWidget {
  final double percentage = 0;
  TrinityCircularProgress(
      {Key key,
      this.color1 = const Color.fromRGBO(22, 185, 253, 1),
      this.color2 = const Color.fromRGBO(80, 202, 253, 1),
      this.color3 = const Color.fromRGBO(145, 222, 254, 1),
      this.width = 50,
      this.height = 50})
      : super(key: key);
  final Color color1;
  final Color color2;
  final Color color3;
  final double width;
  final double height;
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
        AnimationController(vsync: this, duration: Duration(seconds: 2));

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
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.repeat();
      }
    });
    final dif = widget.percentage - oldPercentage;
    oldPercentage = widget.percentage;

    return Container(
      width: widget.width,
      height: widget.height,
      constraints: const BoxConstraints(
        minWidth: 36,
        minHeight: 36,
      ),
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: [
                CustomPaint(
                    size: Size(widget.width, widget.height),
                    painter: _Circle1(
                      color: widget.color1,
                      angle: controller.value,
                    )),
                CustomPaint(
                    size: Size(widget.width, widget.height),
                    painter: _Circle2(
                      color: widget.color2,
                      angle: controller.value,
                    )),
                CustomPaint(
                    size: Size(widget.width, widget.height),
                    painter: _Circle3(
                      color: widget.color3,
                      angle: controller.value,
                    ))
              ],
            );
          }),
    );
  }
}

class _Circle1 extends CustomPainter {
  final Color color;
  final double angle;

  _Circle1({@required this.angle, @required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = color;

    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = min(size.width * 0.2, size.height * 0.2);

    double arcAngle = -2 * pi * angle;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), arcAngle,
        5.5, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Circle2 extends CustomPainter {
  final Color color;
  final double angle;

  _Circle2({@required this.angle, @required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = color;

    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = min(size.width * 0.35, size.height * 0.35);

    double arcAngle = 2 * pi * angle + 2;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), arcAngle,
        5.5, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Circle3 extends CustomPainter {
  final Color color;
  final double angle;

  _Circle3({@required this.angle, @required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = color;

    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = min(size.width * 0.5, size.height * 0.5);

    double arcAngle = -2 * pi * angle + 4;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), arcAngle,
        5.5, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
