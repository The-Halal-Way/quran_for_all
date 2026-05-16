import 'package:flutter/material.dart';
import 'package:quran_for_all/services/permission_helper.dart';

class CompassView extends StatefulWidget {
  const CompassView({super.key});
  @override
  State<CompassView> createState() => _CompassViewState();
}

class _CompassViewState extends State<CompassView> {
  double _heading = 0.0;
  String _direction = 'North';
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initCompass();
  }

  Future<void> _initCompass() async {
    await PermissionHelper().startCompassWithPermission(
      onHeadingChanged: (heading) {
        if (mounted) {
          setState(() {
            _heading = heading;
          });
        }
      },
      onDirectionChanged: (direction) {
        if (mounted) {
          setState(() {
            _direction = direction;
          });
        }
      },
    );
    setState(() => _isListening = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isListening) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 280, height: 280, child: _buildCompassDial(_heading)),
            const SizedBox(height: 40),
            Text(
              '${_heading.toStringAsFixed(0)}°',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: (_direction == 'East' || _direction == 'West')
                    ? Colors.amber.shade700
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                _direction,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompassDial(double headingDegrees) {
    final rotationRadians = -headingDegrees * (3.14159 / 180);

    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: rotationRadians,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54, width: 2),
              color: Colors.grey.shade900,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _cardinalLabel('N', Alignment.topCenter),
                _cardinalLabel('E', Alignment.centerRight),
                _cardinalLabel('S', Alignment.bottomCenter),
                _cardinalLabel('W', Alignment.centerLeft),
                _intercardinalMark(Alignment(0.707, -0.707)), // NE
                _intercardinalMark(Alignment(0.707, 0.707)), // SE
                _intercardinalMark(Alignment(-0.707, 0.707)), // SW
                _intercardinalMark(Alignment(-0.707, -0.707)), // NW
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: SizedBox(
            width: 20,
            height: 20,
            child: CustomPaint(painter: _TrianglePainter()),
          ),
        ),
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _cardinalLabel(String text, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          text,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _intercardinalMark(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white38,
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
