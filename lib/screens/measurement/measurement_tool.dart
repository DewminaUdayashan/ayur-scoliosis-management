import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../models/xray/measurement.dart';

/// Enum to track the progress of drawing a *new* measurement.
enum DrawingStep { line1Start, line1End, line2Start, line2End }

class CobbAngleToolScreen extends HookWidget {
  const CobbAngleToolScreen({
    super.key,
    required this.imageUrl,
    this.initialMeasurements,
    this.readOnly = false,
    this.onSaved,
  });

  final String imageUrl;
  final List<Measurement>? initialMeasurements;
  final bool readOnly;
  final void Function(List<Measurement>)? onSaved;

  @override
  Widget build(BuildContext context) {
    // --- STATE MANAGEMENT ---
    /// Manages the list of all completed and in-progress measurements.
    final measurements = useState<List<Measurement>>(initialMeasurements ?? []);

    /// Tracks the drawing progress for the next measurement.
    final step = useState(DrawingStep.line1Start);

    /// State to keep track of which point from which measurement is being dragged.
    final draggedMeasurementIndex = useState<int?>(null);
    final draggedPointIndex = useState<int?>(null);

    useEffect(() {
      // Reset state when initialMeasurements change
      measurements.value = initialMeasurements ?? [];
      step.value = DrawingStep.line1Start;
      draggedMeasurementIndex.value = null;
      draggedPointIndex.value = null;
      return null;
    }, [initialMeasurements]);

    // --- LOGIC FUNCTIONS ---
    void reset() {
      measurements.value = [];
      step.value = DrawingStep.line1Start;
      draggedMeasurementIndex.value = null;
      draggedPointIndex.value = null;
    }

    // --- GESTURE HANDLERS ---
    void handleTap(TapUpDetails details) {
      final tapPosition = details.localPosition;
      final newMeasurements = List<Measurement>.from(measurements.value);

      switch (step.value) {
        case DrawingStep.line1Start:
          // Start a new measurement
          final newMeasurement = Measurement()..line1Start = tapPosition;
          newMeasurements.add(newMeasurement);
          step.value = DrawingStep.line1End;
          break;
        case DrawingStep.line1End:
          // Set the end of the first line for the current measurement
          newMeasurements.last.line1End = tapPosition;
          step.value = DrawingStep.line2Start;
          break;
        case DrawingStep.line2Start:
          // Set the start of the second line for the current measurement
          newMeasurements.last.line2Start = tapPosition;
          step.value = DrawingStep.line2End;
          break;
        case DrawingStep.line2End:
          // Complete the current measurement
          newMeasurements.last.line2End = tapPosition;
          newMeasurements.last.calculateCobbAngle();
          // Reset step to allow for a new measurement to be drawn
          step.value = DrawingStep.line1Start;
          break;
      }
      measurements.value = newMeasurements;
    }

    void onPanStart(DragStartDetails details) {
      // Allow panning only when not in the middle of drawing a new line.
      if (step.value != DrawingStep.line1Start) return;

      const double hitSlop = 30.0;
      final tapPosition = details.localPosition;

      // Check if the tap is near any point of any measurement.
      for (int i = 0; i < measurements.value.length; i++) {
        final measurement = measurements.value[i];
        final points = measurement.points;
        for (int j = 0; j < points.length; j++) {
          final point = points[j];
          if (point != null && (point - tapPosition).distance < hitSlop) {
            draggedMeasurementIndex.value = i;
            draggedPointIndex.value = j;
            return;
          }
        }
      }
    }

    void onPanUpdate(DragUpdateDetails details) {
      if (draggedMeasurementIndex.value == null ||
          draggedPointIndex.value == null) {
        return;
      }

      final newPosition = details.localPosition;
      final newMeasurements = List<Measurement>.from(measurements.value);
      final measurementToUpdate =
          newMeasurements[draggedMeasurementIndex.value!];

      switch (draggedPointIndex.value) {
        case 0:
          measurementToUpdate.line1Start = newPosition;
          break;
        case 1:
          measurementToUpdate.line1End = newPosition;
          break;
        case 2:
          measurementToUpdate.line2Start = newPosition;
          break;
        case 3:
          measurementToUpdate.line2End = newPosition;
          break;
      }
      measurementToUpdate.calculateCobbAngle();
      measurements.value = newMeasurements;
    }

    void onPanEnd(DragEndDetails details) {
      draggedMeasurementIndex.value = null;
      draggedPointIndex.value = null;
    }

    // --- UI HELPER ---
    String getInstructionText() {
      // If in read-only mode, show view-only message
      if (readOnly) {
        return measurements.value.isEmpty
            ? 'No measurements available.'
            : 'Viewing ${measurements.value.length} measurement${measurements.value.length > 1 ? 's' : ''}.';
      }

      // If a measurement is complete, you can drag points or start a new one.
      if (step.value == DrawingStep.line1Start) {
        return measurements.value.isNotEmpty
            ? 'Drag points to adjust or tap to start a new measurement.'
            : 'Tap to mark the start of the first line.';
      }
      // Otherwise, guide the user through the current drawing process.
      switch (step.value) {
        case DrawingStep.line1Start: // Already handled above
          return '';
        case DrawingStep.line1End:
          return 'Tap to mark the end of the first line.';
        case DrawingStep.line2Start:
          return 'Tap to mark the start of the second line.';
        case DrawingStep.line2End:
          return 'Tap to mark the end of the second line.';
      }
    }

    // --- WIDGET BUILD ---
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cobb Angle Measurement'),
        actions: [
          if (!readOnly) ...[
            if (onSaved != null && measurements.value.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.save),
                tooltip: 'Save Measurements',
                onPressed: () => onSaved!(measurements.value),
              ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset',
              onPressed: reset,
            ),
          ],
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.grey.shade800,
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 8.0,
            ),
            child: Text(
              getInstructionText(),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTapUp: readOnly ? null : handleTap,
              onPanStart: readOnly ? null : onPanStart,
              onPanUpdate: readOnly ? null : onPanUpdate,
              onPanEnd: readOnly ? null : onPanEnd,
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
                        measurements: measurements.value,
                        draggedMeasurementIndex: draggedMeasurementIndex.value,
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
  final List<Measurement> measurements;
  final int? draggedMeasurementIndex;
  final int? draggedPointIndex;

  CobbAnglePainter({
    required this.measurements,
    required this.draggedMeasurementIndex,
    required this.draggedPointIndex,
  });

  /// Calculates the intersection point of two lines defined by four points.
  /// Returns null if the lines are parallel.
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
    // Define paints for drawing
    final linePaint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final extendedLinePaint = Paint()
      ..color = Colors.amber.withAlpha(80)
      ..strokeWidth = 1.5;
    final pointPaint = Paint()..color = Colors.redAccent;
    final draggedPointPaint = Paint()..color = Colors.lightGreenAccent;
    final arcPaint = Paint()
      ..color = Colors.cyan.withAlpha(200)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Iterate through each measurement and draw it on the canvas
    for (int i = 0; i < measurements.length; i++) {
      final measurement = measurements[i];
      final line1Start = measurement.line1Start;
      final line1End = measurement.line1End;
      final line2Start = measurement.line2Start;
      final line2End = measurement.line2End;
      final cobbAngle = measurement.cobbAngle;

      // Find the intersection point if the measurement is complete
      final intersection = measurement.isComplete
          ? _getLinesIntersection(
              line1Start!,
              line1End!,
              line2Start!,
              line2End!,
            )
          : null;

      // Draw extended lines that meet at the intersection
      if (intersection != null) {
        final line1Dir = (line1End! - line1Start!).direction;
        final line2Dir = (line2End! - line2Start!).direction;
        final p1Far = intersection + Offset.fromDirection(line1Dir, 2000);
        final p1Near = intersection + Offset.fromDirection(line1Dir, -2000);
        final p2Far = intersection + Offset.fromDirection(line2Dir, 2000);
        final p2Near = intersection + Offset.fromDirection(line2Dir, -2000);
        canvas.drawLine(p1Far, p1Near, extendedLinePaint);
        canvas.drawLine(p2Far, p2Near, extendedLinePaint);
      }

      // Draw the main line segments defined by the user
      if (line1Start != null && line1End != null) {
        canvas.drawLine(line1Start, line1End, linePaint);
      }
      if (line2Start != null && line2End != null) {
        canvas.drawLine(line2Start, line2End, linePaint);
      }

      // Draw the angle arc and text if the angle is calculated
      if (cobbAngle != null && intersection != null) {
        final v1 = line1End! - intersection;
        final v2 = line2End! - intersection;

        double angle1 = atan2(v1.dy, v1.dx);
        double angle2 = atan2(v2.dy, v2.dx);

        if (angle1 > angle2) {
          final temp = angle1;
          angle1 = angle2;
          angle2 = temp;
        }

        double sweepAngle = angle2 - angle1;
        if (sweepAngle > pi) {
          sweepAngle = 2 * pi - sweepAngle;
          angle1 = angle2;
        }

        const arcRadius = 40.0;
        final arcRect = Rect.fromCircle(
          center: intersection,
          radius: arcRadius,
        );
        canvas.drawArc(arcRect, angle1, sweepAngle, false, arcPaint);

        // Prepare and draw the angle value text
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${cobbAngle.toStringAsFixed(1)}°',
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

        final midAngle = angle1 + sweepAngle / 2;
        final textRadius = arcRadius + 15;
        final textCenter =
            intersection +
            Offset(cos(midAngle) * textRadius, sin(midAngle) * textRadius);
        textPainter.paint(
          canvas,
          textCenter - Offset(textPainter.width / 2, textPainter.height / 2),
        );
      }

      // Draw draggable points on top of the lines
      final points = measurement.points;
      for (int j = 0; j < points.length; j++) {
        if (points[j] != null) {
          final isDragged =
              (i == draggedMeasurementIndex) && (j == draggedPointIndex);
          canvas.drawCircle(
            points[j]!,
            isDragged ? 12.0 : 8.0,
            isDragged ? draggedPointPaint : pointPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CobbAnglePainter oldDelegate) => true;
}
