import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

// Enum to keep track of the user's drawing progress.
enum DrawingStep { line1Start, line1End, line2Start, line2End, done }

class CobbAngleToolScreen extends HookWidget {
  final String imageUrl;

  const CobbAngleToolScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // --- STATE MANAGEMENT ---
    final step = useState(DrawingStep.line1Start);
    final line1Start = useState<Offset?>(null);
    final line1End = useState<Offset?>(null);
    final line2Start = useState<Offset?>(null);
    final line2End = useState<Offset?>(null);
    final cobbAngle = useState<double?>(null);

    final draggedPointIndex = useState<int?>(null);
    final points = [
      line1Start.value,
      line1End.value,
      line2Start.value,
      line2End.value,
    ];

    // --- LOGIC FUNCTIONS ---
    void calculateCobbAngle() {
      if (line1Start.value != null &&
          line1End.value != null &&
          line2Start.value != null &&
          line2End.value != null) {
        final vec1 = vector.Vector2(
          line1End.value!.dx - line1Start.value!.dx,
          line1End.value!.dy - line1Start.value!.dy,
        );
        final vec2 = vector.Vector2(
          line2End.value!.dx - line2Start.value!.dx,
          line2End.value!.dy - line2Start.value!.dy,
        );
        final angleInRadians = vec1.angleTo(vec2);
        final angleInDegrees = vector.degrees(angleInRadians);
        cobbAngle.value = min(angleInDegrees, 180 - angleInDegrees);
      }
    }

    void reset() {
      step.value = DrawingStep.line1Start;
      line1Start.value = null;
      line1End.value = null;
      line2Start.value = null;
      line2End.value = null;
      cobbAngle.value = null;
      draggedPointIndex.value = null;
    }

    // --- GESTURE HANDLERS ---
    void handleTap(TapUpDetails details) {
      if (step.value == DrawingStep.done) return;
      final tapPosition = details.localPosition;
      switch (step.value) {
        case DrawingStep.line1Start:
          line1Start.value = tapPosition;
          step.value = DrawingStep.line1End;
          break;
        case DrawingStep.line1End:
          line1End.value = tapPosition;
          step.value = DrawingStep.line2Start;
          break;
        case DrawingStep.line2Start:
          line2Start.value = tapPosition;
          step.value = DrawingStep.line2End;
          break;
        case DrawingStep.line2End:
          line2End.value = tapPosition;
          calculateCobbAngle();
          step.value = DrawingStep.done;
          break;
        case DrawingStep.done:
          break;
      }
    }

    void onPanStart(DragStartDetails details) {
      if (step.value != DrawingStep.done) return;
      const double hitSlop = 30.0;
      final tapPosition = details.localPosition;
      for (int i = 0; i < points.length; i++) {
        final point = points[i];
        if (point != null && (point - tapPosition).distance < hitSlop) {
          draggedPointIndex.value = i;
          return;
        }
      }
    }

    void onPanUpdate(DragUpdateDetails details) {
      if (draggedPointIndex.value == null) return;
      final newPosition = details.localPosition;
      switch (draggedPointIndex.value) {
        case 0:
          line1Start.value = newPosition;
          break;
        case 1:
          line1End.value = newPosition;
          break;
        case 2:
          line2Start.value = newPosition;
          break;
        case 3:
          line2End.value = newPosition;
          break;
      }
      calculateCobbAngle();
    }

    void onPanEnd(DragEndDetails details) {
      draggedPointIndex.value = null;
    }

    // --- UI HELPER ---
    String getInstructionText() {
      switch (step.value) {
        case DrawingStep.line1Start:
          return 'Tap to mark the start of the first line.';
        case DrawingStep.line1End:
          return 'Tap to mark the end of the first line.';
        case DrawingStep.line2Start:
          return 'Tap to mark the start of the second line.';
        case DrawingStep.line2End:
          return 'Tap to mark the end of the second line.';
        case DrawingStep.done:
          return 'Drag points to adjust. Press Reset to start over.';
      }
    }

    // --- WIDGET BUILD ---
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cobb Angle Measurement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: reset,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Text(
                    getInstructionText(),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                // if (cobbAngle.value != null)
                //   Text(
                //     'Angle: ${cobbAngle.value!.toStringAsFixed(1)}°',
                //     style: Theme.of(context).textTheme.titleLarge?.copyWith(
                //       color: Colors.amber,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTapUp: handleTap,
              onPanStart: onPanStart,
              onPanUpdate: onPanUpdate,
              onPanEnd: onPanEnd,
              child: Container(
                color: Colors.black,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Center(child: Icon(Icons.error)),
                    ),
                    CustomPaint(
                      painter: CobbAnglePainter(
                        line1Start: line1Start.value,
                        line1End: line1End.value,
                        line2Start: line2Start.value,
                        line2End: line2End.value,
                        cobbAngle: cobbAngle.value,
                        draggedPointIndex: draggedPointIndex.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CobbAnglePainter extends CustomPainter {
  final Offset? line1Start, line1End, line2Start, line2End;
  final double? cobbAngle;
  final int? draggedPointIndex;

  CobbAnglePainter({
    required this.line1Start,
    required this.line1End,
    required this.line2Start,
    required this.line2End,
    required this.cobbAngle,
    required this.draggedPointIndex,
  });

  Offset? _getLinesIntersection(Offset p1, Offset p2, Offset p3, Offset p4) {
    double x1 = p1.dx, y1 = p1.dy;
    double x2 = p2.dx, y2 = p2.dy;
    double x3 = p3.dx, y3 = p3.dy;
    double x4 = p4.dx, y4 = p4.dy;

    double den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    if (den.abs() < 1e-3) return null; // Lines are parallel

    double t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den;
    return Offset(x1 + t * (x2 - x1), y1 + t * (y2 - y1));
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Paints
    final linePaint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final extendedLinePaint = Paint()
      ..color = Colors.amber.withOpacity(0.4)
      ..strokeWidth = 1.5;
    final pointPaint = Paint()..color = Colors.redAccent;
    final draggedPointPaint = Paint()..color = Colors.lightGreenAccent;
    final arcPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.8)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final points = [line1Start, line1End, line2Start, line2End];
    final intersection =
        (line1Start != null &&
            line1End != null &&
            line2Start != null &&
            line2End != null)
        ? _getLinesIntersection(line1Start!, line1End!, line2Start!, line2End!)
        : null;

    // Draw extended lines
    if (intersection != null) {
      final line1Dir = (line1End! - line1Start!).direction;
      final line2Dir = (line2End! - line2Start!).direction;
      // FIX: Manually create Offset from Vector2 direction for arithmetic
      final p1Far = intersection + Offset.fromDirection(line1Dir, 2000);
      final p1Near = intersection + Offset.fromDirection(line1Dir, -2000);
      final p2Far = intersection + Offset.fromDirection(line2Dir, 2000);
      final p2Near = intersection + Offset.fromDirection(line2Dir, -2000);
      canvas.drawLine(p1Far, p1Near, extendedLinePaint);
      canvas.drawLine(p2Far, p2Near, extendedLinePaint);
    }

    // Draw main lines
    if (line1Start != null && line1End != null)
      canvas.drawLine(line1Start!, line1End!, linePaint);
    if (line2Start != null && line2End != null)
      canvas.drawLine(line2Start!, line2End!, linePaint);

    // Draw angle arc and text
    if (cobbAngle != null && intersection != null) {
      // Create vectors from the intersection outwards, along the drawn lines
      final v1 = line1End! - intersection;
      final v2 = line2End! - intersection;

      // Calculate the angles of these vectors from the positive x-axis
      double angle1 = atan2(v1.dy, v1.dx);
      double angle2 = atan2(v2.dy, v2.dx);

      // Ensure startAngle is the smaller of the two
      if (angle1 > angle2) {
        final temp = angle1;
        angle1 = angle2;
        angle2 = temp;
      }

      double sweepAngle = angle2 - angle1;

      // If the angle is obtuse, we need to draw the other arc (the acute one)
      if (sweepAngle > pi) {
        sweepAngle = 2 * pi - sweepAngle;
        angle1 = angle2; // Start from the second angle and sweep backwards
      }

      const arcRadius = 40.0;
      final arcRect = Rect.fromCircle(center: intersection, radius: arcRadius);
      canvas.drawArc(arcRect, angle1, sweepAngle, false, arcPaint);

      // Draw text
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${cobbAngle!.toStringAsFixed(1)}°',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 5.0,
                color: Colors.black,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // Position text in the middle of the arc
      final midAngle = angle1 + sweepAngle / 2;
      final textRadius = arcRadius + 15; // Position text just outside the arc
      final textCenter =
          intersection +
          Offset(cos(midAngle) * textRadius, sin(midAngle) * textRadius);
      textPainter.paint(
        canvas,
        textCenter - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    // Draw draggable points on top
    for (int i = 0; i < points.length; i++) {
      if (points[i] != null) {
        final isDragged = (i == draggedPointIndex);
        canvas.drawCircle(
          points[i]!,
          isDragged ? 12.0 : 8.0,
          isDragged ? draggedPointPaint : pointPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CobbAnglePainter oldDelegate) => true;
}
