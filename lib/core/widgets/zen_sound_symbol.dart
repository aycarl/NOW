import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Renders minimalist sacred geometry symbols representing different bell and
/// meditation sounds in the Tao UI/UX concept:
/// - `singing_bowl`: Enso open circle
/// - `default` / `gong` / `alarm`: Concentric ripple
/// - `chime` / `notification`: Dewdrop
/// - `nature` / `white_noise` / `ringtone`: Flowing wave
class ZenSoundSymbol extends StatelessWidget {
  final String soundKey;
  final double size;
  final Color? color;

  const ZenSoundSymbol({
    super.key,
    required this.soundKey,
    this.size = 18.0,
    this.color,
  });

  /// Returns a human-readable display name for a given sound key.
  static String labelFor(String key) {
    switch (key) {
      case 'singing_bowl':
        return 'Singing Bowl';
      case 'chime':
      case 'notification':
        return 'Pin Chime';
      case 'nature':
        return 'Bamboo Wind';
      case 'white_noise':
      case 'ringtone':
        return 'Misty Stream';
      case 'gong':
      case 'alarm':
        return 'Temple Shō';
      case 'default':
      default:
        return 'Default';
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? IconTheme.of(context).color ?? Colors.black87;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ZenSymbolPainter(
          soundKey: soundKey,
          color: effectiveColor,
        ),
      ),
    );
  }
}

class _ZenSymbolPainter extends CustomPainter {
  final String soundKey;
  final Color color;

  _ZenSymbolPainter({
    required this.soundKey,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.38;

    switch (soundKey) {
      case 'singing_bowl':
        // Enso open circle (approx 300 degrees arc)
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -math.pi * 0.15,
          math.pi * 1.68,
          false,
          paint,
        );
        break;

      case 'chime':
      case 'notification':
        // Dewdrop
        final path = Path();
        final top = Offset(center.dx, center.dy - radius * 1.05);
        path.moveTo(top.dx, top.dy);
        path.cubicTo(
          center.dx + radius * 1.05,
          center.dy - radius * 0.05,
          center.dx + radius * 0.95,
          center.dy + radius * 1.05,
          center.dx,
          center.dy + radius * 1.05,
        );
        path.cubicTo(
          center.dx - radius * 0.95,
          center.dy + radius * 1.05,
          center.dx - radius * 1.05,
          center.dy - radius * 0.05,
          top.dx,
          top.dy,
        );
        canvas.drawPath(path, paint);
        break;

      case 'nature':
      case 'white_noise':
      case 'ringtone':
        // Dual flowing waves
        for (final dyOffset in [-radius * 0.32, radius * 0.38]) {
          final wave = Path();
          final y = center.dy + dyOffset;
          final left = center.dx - radius;
          final right = center.dx + radius;
          final mid = center.dx;
          wave.moveTo(left, y);
          wave.quadraticBezierTo(
            (left + mid) / 2,
            y - radius * 0.35,
            mid,
            y,
          );
          wave.quadraticBezierTo(
            (mid + right) / 2,
            y + radius * 0.35,
            right,
            y,
          );
          canvas.drawPath(wave, paint);
        }
        break;

      case 'gong':
      case 'alarm':
      case 'default':
      default:
        // Concentric ripple (Temple Sho / Default Bell)
        final dotPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, radius * 0.25, dotPaint);
        canvas.drawCircle(center, radius, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _ZenSymbolPainter oldDelegate) {
    return oldDelegate.soundKey != soundKey || oldDelegate.color != color;
  }
}
