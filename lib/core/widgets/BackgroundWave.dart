import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WaveBackground extends StatelessWidget {
  final Widget child;
  final List<Color> colors;

  const WaveBackground({
    Key? key,
    required this.child,
    this.colors = const [
      Color(0xFF667EEA),
      Color(0xFF764BA2),
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ✅ Wave background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
            ),
          ),
        ),
        
        // ✅ Wave shapes
        Positioned.fill(
          child: CustomPaint(
            painter: WavePainter(),
          ),
        ),
        
        // ✅ Content
        child,
      ],
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // ✅ First wave
    final path1 = Path();
    path1.moveTo(0, size.height * 0.8);
    path1.quadraticBezierTo(
      size.width * 0.25, size.height * 0.7,
      size.width * 0.5, size.height * 0.8,
    );
    path1.quadraticBezierTo(
      size.width * 0.75, size.height * 0.9,
      size.width, size.height * 0.8,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    canvas.drawPath(path1, paint);

    // ✅ Second wave
    paint.color = Colors.white.withOpacity(0.05);
    final path2 = Path();
    path2.moveTo(0, size.height * 0.6);
    path2.quadraticBezierTo(
      size.width * 0.25, size.height * 0.5,
      size.width * 0.5, size.height * 0.6,
    );
    path2.quadraticBezierTo(
      size.width * 0.75, size.height * 0.7,
      size.width, size.height * 0.6,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}