import 'package:flutter/material.dart';

class LinesBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1C4C9C).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // **Canto superior‐esquerdo** curva simples
    final path1 = Path()
      ..moveTo(0, size.height * 0.08)
      ..quadraticBezierTo(size.width * 0.1, 0, size.width * 0.3, 0)
      ..lineTo(size.width * 0.3, size.height * 0.12);
    canvas.drawPath(path1, paint);

    // **Linha diagonal**
    canvas.save();
    canvas.translate(-size.width * 0.2, size.height * 0.2);
    canvas.rotate(-0.15);
    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width * 1.5, 0),
      paint,
    );
    canvas.restore();

    // **Canto inferior‐direito**
    final path2 = Path()
      ..moveTo(size.width, size.height * 0.92)
      ..quadraticBezierTo(
          size.width * 0.9, size.height, size.width * 0.7, size.height)
      ..lineTo(size.width * 0.7, size.height * 0.88);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
