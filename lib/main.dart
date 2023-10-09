//
//  ClockFlutterUI
//
//  Created by Abubakir Ro'ziboyev on 06/10/23.
//
//  MARK: Instagram
//  AppMaster
//  MARK: appmaster3101
//
//
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Clock',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: ClockAnimation(),
      ),
    );
  }
}

class ClockAnimation extends StatefulWidget {
  const ClockAnimation({super.key});

  @override
  State<ClockAnimation> createState() => _ClockAnimationState();
}

class _ClockAnimationState extends State<ClockAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ClockPainter(),
          child: const SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
          ),
        );
      },
    );
  }
}

class ClockPainter extends CustomPainter {
  final secondCircleR = 98;
  final minuteCircleR = 80;
  final hourCircleR = 62;
  final clockIndicatorR = 46.0;
  final clockIndicatorL = 6.0;

  final centerCircleR = 3.0;

  final centerCircleP = Paint()
    ..color = Colors.green
    ..style = PaintingStyle.fill;
  final clockIndicatorP = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  final secondLineP = Paint()
    ..color = Colors.green
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  final minuteLineP = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  final hourLineP = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  final hourCircleP = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round;
  final minuteCircleP = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round;
  final secundCircleP = Paint()
    ..color = Colors.green
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round;

  static const _minSweepAngle = pi / 256;

  @override
  void paint(Canvas canvas, Size size) {
    final date = DateTime.now();
    final center = Offset(size.width / 2, size.height / 2);
    final secondAngle =
        (date.second * 1000 + date.millisecond) * pi / 30000 - pi / 2;
    final minuteAngle = (date.minute * 60 + date.second) * pi / 1800 - pi / 2;
    final hourAngle = ((date.hour % 12) * 60 + date.minute) * pi / 360 - pi / 2;
    canvas.drawCircle(
      center,
      centerCircleR,
      centerCircleP,
    );
    canvas.drawLine(
      center.translate(cos(secondAngle) * 5, sin(secondAngle) * 5),
      center.translate(cos(secondAngle) * 37, sin(secondAngle) * 37),
      secondLineP,
    );
    canvas.drawLine(
      center.translate(cos(minuteAngle) * 5, sin(minuteAngle) * 5),
      center.translate(cos(minuteAngle) * 37, sin(minuteAngle) * 37),
      minuteLineP,
    );
    canvas.drawLine(
      center.translate(cos(hourAngle) * 5, sin(hourAngle) * 5),
      center.translate(cos(hourAngle) * 37, sin(hourAngle) * 37),
      hourLineP,
    );
    _drawClockIndicators(
      canvas,
      center,
      clockIndicatorP,
      clockIndicatorL,
      clockIndicatorR,
    );
    _drawOutlineCircle(
        canvas,
        hourCircleP,
        Rect.fromCenter(
          center: center,
          width: hourCircleR * 2,
          height: hourCircleR * 2,
        ),
        ((date.hour % 12) * 60 + date.minute) * pi / 360);
    _drawOutlineCircle(
        canvas,
        minuteCircleP,
        Rect.fromCenter(
          center: center,
          width: minuteCircleR * 2,
          height: minuteCircleR * 2,
        ),
        (date.minute * 60 + date.second) * pi / 1800);
    _drawOutlineCircle(
        canvas,
        secundCircleP,
        Rect.fromCenter(
          center: center,
          width: secondCircleR * 2,
          height: secondCircleR * 2,
        ),
        (date.second * 1000 + date.millisecond) * pi / 30000);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawClockIndicators(
    Canvas canvas,
    Offset center,
    Paint p,
    double length,
    double radius,
  ) {
    for (var i = 0; i < 12; i++) {
      final angle = i * pi / 6;
      final diffX = sin(angle);
      final diffY = cos(angle);
      final p1 = center.translate(diffX * radius, diffY * radius);
      final p2 = center.translate(
          diffX * (radius + length), diffY * (radius + length));
      canvas.drawLine(p1, p2, p);
    }
  }

  void _drawOutlineCircle(
      Canvas canvas, Paint paint, Rect rect, double sweepAngle) {
    if (sweepAngle < _minSweepAngle) {
      sweepAngle = _minSweepAngle;
    }
    canvas.drawArc(rect, -pi / 2, sweepAngle, false, paint);
  }
}
