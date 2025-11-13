import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/avatar_config.dart';

class AvatarPreview extends StatelessWidget {
  final AvatarConfig config;
  final double size;

  const AvatarPreview({super.key, required this.config, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _AvatarPainter(config: config)),
    );
  }
}

class _AvatarPainter extends CustomPainter {
  final AvatarConfig config;

  _AvatarPainter({required this.config});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final faceRadius = radius * 0.65;

    final backgroundPaint = Paint()
      ..color = _colorFromHex(config.backgroundColor)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, backgroundPaint);

    _drawHair(canvas, center, faceRadius, size);

    final facePaint = Paint()
      ..color = _colorFromHex(config.faceColor)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, faceRadius, facePaint);

    _drawEyes(canvas, center, faceRadius);
    _drawMouth(canvas, center, faceRadius);
  }

  void _drawHair(Canvas canvas, Offset center, double faceRadius, Size size) {
    final hairPaint = Paint()
      ..color = _colorFromHex(config.hairColor)
      ..style = PaintingStyle.fill;

    switch (config.hairStyle) {
      case AvatarHairStyle.none:
        return;
      case AvatarHairStyle.short:
        final rect = Rect.fromCircle(
          center: Offset(center.dx, center.dy - faceRadius * 0.6),
          radius: faceRadius * 1.2,
        );
        canvas.drawArc(rect, math.pi, math.pi, true, hairPaint);
        break;
      case AvatarHairStyle.wave:
        final path = Path()
          ..moveTo(center.dx - faceRadius * 1.1, center.dy - faceRadius * 0.9)
          ..quadraticBezierTo(
            center.dx - faceRadius * 0.8,
            center.dy - faceRadius * 1.4,
            center.dx - faceRadius * 0.2,
            center.dy - faceRadius * 1.2,
          )
          ..quadraticBezierTo(
            center.dx,
            center.dy - faceRadius * 1.15,
            center.dx + faceRadius * 0.2,
            center.dy - faceRadius * 1.3,
          )
          ..quadraticBezierTo(
            center.dx + faceRadius * 0.7,
            center.dy - faceRadius * 1.45,
            center.dx + faceRadius * 1.1,
            center.dy - faceRadius * 0.9,
          )
          ..lineTo(center.dx + faceRadius * 1.1, center.dy - faceRadius * 0.2)
          ..lineTo(center.dx - faceRadius * 1.1, center.dy - faceRadius * 0.2)
          ..close();
        canvas.drawPath(path, hairPaint);
        break;
      case AvatarHairStyle.bun:
        canvas.drawCircle(
          Offset(center.dx, center.dy - faceRadius * 1.4),
          faceRadius * 0.45,
          hairPaint,
        );
        final rect = Rect.fromCircle(
          center: Offset(center.dx, center.dy - faceRadius * 0.7),
          radius: faceRadius * 1.2,
        );
        canvas.drawArc(rect, math.pi, math.pi, true, hairPaint);
        break;
      case AvatarHairStyle.buzz:
        final clip = Path()
          ..addOval(Rect.fromCircle(center: center, radius: faceRadius));
        canvas.save();
        canvas.clipPath(clip);
        final oval = Rect.fromCircle(
          center: Offset(center.dx, center.dy - faceRadius * 0.5),
          radius: faceRadius * 1.3,
        );
        canvas.drawOval(oval, hairPaint);
        canvas.restore();
        break;
    }
  }

  void _drawEyes(Canvas canvas, Offset center, double faceRadius) {
    final eyePaint = Paint()
      ..color = const Color(0xFF1F1F1F)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFF1F1F1F)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = faceRadius * 0.12;

    final left = Offset(
      center.dx - faceRadius * 0.45,
      center.dy - faceRadius * 0.2,
    );
    final right = Offset(
      center.dx + faceRadius * 0.45,
      center.dy - faceRadius * 0.2,
    );
    final eyeRadius = faceRadius * 0.14;

    switch (config.eyeStyle) {
      case AvatarEyeStyle.round:
        canvas.drawCircle(left, eyeRadius, eyePaint);
        canvas.drawCircle(right, eyeRadius, eyePaint);
        break;
      case AvatarEyeStyle.happy:
        final rectLeft = Rect.fromCircle(center: left, radius: eyeRadius);
        final rectRight = Rect.fromCircle(center: right, radius: eyeRadius);
        canvas.drawArc(
          rectLeft,
          math.pi * 0.1,
          math.pi * 0.8,
          false,
          strokePaint,
        );
        canvas.drawArc(
          rectRight,
          math.pi * 0.1,
          math.pi * 0.8,
          false,
          strokePaint,
        );
        break;
      case AvatarEyeStyle.wink:
        canvas.drawCircle(left, eyeRadius, eyePaint);
        canvas.drawLine(
          Offset(right.dx - eyeRadius, right.dy),
          Offset(right.dx + eyeRadius, right.dy),
          strokePaint,
        );
        break;
    }
  }

  void _drawMouth(Canvas canvas, Offset center, double faceRadius) {
    final mouthPaint = Paint()
      ..color = const Color(0xFF1F1F1F)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = faceRadius * 0.12;

    final mouthCenter = Offset(center.dx, center.dy + faceRadius * 0.35);
    final mouthRadius = faceRadius * 0.5;

    switch (config.mouthStyle) {
      case AvatarMouthStyle.smile:
        final rect = Rect.fromCircle(center: mouthCenter, radius: mouthRadius);
        canvas.drawArc(rect, math.pi * 0.15, math.pi * 0.7, false, mouthPaint);
        break;
      case AvatarMouthStyle.grin:
        final linePaint = mouthPaint..strokeWidth = faceRadius * 0.16;
        canvas.drawLine(
          Offset(mouthCenter.dx - mouthRadius * 0.6, mouthCenter.dy),
          Offset(mouthCenter.dx + mouthRadius * 0.6, mouthCenter.dy),
          linePaint,
        );
        break;
      case AvatarMouthStyle.surprised:
        final fill = Paint()
          ..color = const Color(0xFF1F1F1F)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(mouthCenter, faceRadius * 0.18, fill);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _AvatarPainter oldDelegate) {
    return oldDelegate.config != config;
  }

  Color _colorFromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
