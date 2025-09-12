import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

// A simple data class to hold the coordinates for the two lines.
// These would typically be saved to your database.
// Storing points as relative offsets (0.0 to 1.0) makes them
// independent of the screen or image resolution.
class CobbMeasurement {
  final Offset p1;
  final Offset p2;
  final Offset p3;
  final Offset p4;

  CobbMeasurement({
    required this.p1,
    required this.p2,
    required this.p3,
    required this.p4,
  });
}

class CobbAngleToolScreen extends StatefulWidget {
  final String imageUrl;
  // Pass an existing measurement to load and display it.
  final CobbMeasurement? initialMeasurement;
  // Callback to save the measurement data.
  final ValueChanged<CobbMeasurement> onSave;

  const CobbAngleToolScreen({
    super.key,
    required this.imageUrl,
    this.initialMeasurement,
    required this.onSave,
  });

  @override
  State<CobbAngleToolScreen> createState() => _CobbAngleToolScreenState();
}

class _CobbAngleToolScreenState extends State<CobbAngleToolScreen> {
  // The four points that define the two lines for the Cobb angle.
  // p1, p2 define the first line. p3, p4 define the second.
  final List<Offset?> _points = List.filled(4, null);

  // The index of the point currently being dragged by the user.
  int? _draggedPointIndex;

  // The calculated Cobb angle.
  double? _cobbAngle;

  // Controller for InteractiveViewer to manage zoom/pan.
  final TransformationController _transformationController =
      TransformationController();

  // The size of the displayed image, needed to convert between
  // gesture coordinates and relative image coordinates.
  Size? _imageSize;
  // The loaded image object.
  ui.Image? _loadedImage;

  @override
  void initState() {
    super.initState();
    // If an initial measurement is provided, load the points.
    if (widget.initialMeasurement != null) {
      _points[0] = widget.initialMeasurement!.p1;
      _points[1] = widget.initialMeasurement!.p2;
      _points[2] = widget.initialMeasurement!.p3;
      _points[3] = widget.initialMeasurement!.p4;
      _calculateCobbAngle();
    }
    // Asynchronously get the image and its size to correctly map coordinates.
    _loadImageAndSize();
  }

  Future<void> _loadImageAndSize() async {
    final imageProvider = NetworkImage(widget.imageUrl);
    final completer = Completer<ui.Image>();
    final stream = imageProvider.resolve(const ImageConfiguration());

    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo info, bool syncCall) {
        stream.removeListener(listener);
        completer.complete(info.image);
      },
      onError: (exception, stackTrace) {
        stream.removeListener(listener);
        completer.completeError(exception, stackTrace);
      },
    );

    stream.addListener(listener);

    try {
      final img = await completer.future;
      if (mounted) {
        setState(() {
          _loadedImage = img;
          _imageSize = Size(img.width.toDouble(), img.height.toDouble());
        });
      } else {
        // If the widget was disposed while the image was loading, dispose the image too.
        img.dispose();
      }
    } catch (e) {
      if (mounted) {
        // Handle image loading error, e.g., show a snackbar or an error icon.
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load image: $e')));
      }
    }
  }

  void _calculateCobbAngle() {
    if (_points.contains(null) || _points.length < 4) {
      setState(() => _cobbAngle = null);
      return;
    }

    final p1 = _points[0]!;
    final p2 = _points[1]!;
    final p3 = _points[2]!;
    final p4 = _points[3]!;

    // Calculate slopes (m = dy / dx)
    // Handle vertical lines to avoid division by zero.
    final bool isLine1Vertical = (p2.dx - p1.dx).abs() < 0.0001;
    final bool isLine2Vertical = (p4.dx - p3.dx).abs() < 0.0001;

    double m1 = isLine1Vertical
        ? double.infinity
        : (p2.dy - p1.dy) / (p2.dx - p1.dx);
    double m2 = isLine2Vertical
        ? double.infinity
        : (p4.dy - p3.dy) / (p4.dx - p3.dx);

    // If both lines are vertical, angle is 0
    if (isLine1Vertical && isLine2Vertical) {
      setState(() => _cobbAngle = 0.0);
      return;
    }

    // If slopes are identical, angle is 0
    if ((m1 - m2).abs() < 0.0001) {
      setState(() => _cobbAngle = 0.0);
      return;
    }

    // Formula for angle between two lines
    final double angleRad = atan(((m2 - m1) / (1 + m1 * m2)).abs());

    // Convert radians to degrees
    final double angleDeg = angleRad * 180 / pi;

    setState(() {
      _cobbAngle = angleDeg;
    });
  }

  // Converts a global screen tap position to a relative offset on the image.
  Offset _globalToRelative(Offset globalPosition, BuildContext context) {
    // This is the widget that receives the tap events.
    final RenderBox box = context.findRenderObject() as RenderBox;
    // This converts the global screen coordinate to a coordinate local to the InteractiveViewer.
    final Offset localPosition = box.globalToLocal(globalPosition);
    // This matrix represents the current zoom and pan of the InteractiveViewer.
    final Matrix4 matrix = _transformationController.value;
    // We invert the matrix to transform the local tap coordinate into a coordinate
    // on the child (the CustomPaint canvas), accounting for the current pan and zoom.
    final Offset transformedPosition = MatrixUtils.transformPoint(
      matrix.clone()..invert(),
      localPosition,
    );
    return transformedPosition;
  }

  void _onPanStart(DragStartDetails details, BuildContext context) {
    if (_imageSize == null) return;

    final tappedPoint = _globalToRelative(details.globalPosition, context);
    double minDistance = double.infinity;
    int? closestPointIndex;

    // The touchable radius around a point handle.
    // This is in image pixels, not screen pixels.
    const double touchRadius = 25.0;

    for (int i = 0; i < _points.length; i++) {
      final point = _points[i];
      if (point != null) {
        final distance = (tappedPoint - point).distance;
        if (distance < minDistance && distance < touchRadius) {
          minDistance = distance;
          closestPointIndex = i;
        }
      }
    }

    if (closestPointIndex != null) {
      // User tapped on an existing point, start dragging it.
      setState(() {
        _draggedPointIndex = closestPointIndex;
      });
    } else {
      // User is drawing a new line by dragging.
      if (_points[0] == null) {
        // Drawing the first line.
        setState(() {
          _points[0] = tappedPoint;
          _points[1] = tappedPoint; // Start and end at the same spot initially.
          _draggedPointIndex = 1; // We will drag the second point of the line.
        });
      } else if (_points[2] == null) {
        // Drawing the second line.
        setState(() {
          _points[2] = tappedPoint;
          _points[3] = tappedPoint;
          _draggedPointIndex = 3; // We will drag the fourth point.
        });
      }
    }
  }

  void _onPanUpdate(DragUpdateDetails details, BuildContext context) {
    if (_draggedPointIndex != null && _imageSize != null) {
      final newPoint = _globalToRelative(details.globalPosition, context);
      setState(() {
        _points[_draggedPointIndex!] = newPoint;
        _calculateCobbAngle();
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _draggedPointIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cobb Angle Tool'),
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.black87,
        actions: [
          // Button to reset all points
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _points.fillRange(0, 4, null);
                _cobbAngle = null;
              });
            },
          ),
          // Save button
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _points.contains(null)
                ? null // Disable save if not all points are set
                : () {
                    final measurement = CobbMeasurement(
                      p1: _points[0]!,
                      p2: _points[1]!,
                      p3: _points[2]!,
                      p4: _points[3]!,
                    );
                    widget.onSave(measurement);
                    Navigator.of(context).pop();
                  },
          ),
        ],
      ),
      body: _imageSize == null || _loadedImage == null
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onPanStart: (details) => _onPanStart(details, context),
                  onPanUpdate: (details) => _onPanUpdate(details, context),
                  onPanEnd: _onPanEnd,
                  child: CustomPaint(
                    size: _imageSize!,
                    painter: ImagePainter(image: _loadedImage!),
                    foregroundPainter: CobbAnglePainter(
                      points: _points,
                      cobbAngle: _cobbAngle,
                      draggedPointIndex: _draggedPointIndex,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Custom painter to draw the lines, points, and angle text.
class CobbAnglePainter extends CustomPainter {
  final List<Offset?> points;
  final double? cobbAngle;
  final int? draggedPointIndex;

  CobbAnglePainter({
    required this.points,
    required this.cobbAngle,
    required this.draggedPointIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final draggedPointPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    // Draw first line
    if (points[0] != null && points[1] != null) {
      canvas.drawLine(points[0]!, points[1]!, linePaint);
    }
    // Draw second line
    if (points[2] != null && points[3] != null) {
      canvas.drawLine(points[2]!, points[3]!, linePaint);
    }

    // Draw handles for each point
    for (int i = 0; i < points.length; i++) {
      if (points[i] != null) {
        final paint = (i == draggedPointIndex) ? draggedPointPaint : pointPaint;
        canvas.drawCircle(points[i]!, 10.0, paint);
      }
    }

    // Draw the Cobb angle text
    if (cobbAngle != null) {
      final textSpan = TextSpan(
        text: '${cobbAngle!.toStringAsFixed(1)}°',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          backgroundColor: Color(0xB3FFFFFF), // White with transparency
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // Position the text in the top-left corner of the image viewport
      textPainter.paint(canvas, const Offset(20, 20));
    }
  }

  @override
  bool shouldRepaint(covariant CobbAnglePainter oldDelegate) {
    // Repaint whenever the points, angle, or dragged index change.
    return oldDelegate.points != points ||
        oldDelegate.cobbAngle != cobbAngle ||
        oldDelegate.draggedPointIndex != draggedPointIndex;
  }
}

// This painter is used to draw the actual image on the canvas.
// It's separated to ensure it doesn't repaint unnecessarily when lines are drawn.
class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the image to fill the canvas size.
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, size.width, size.height),
      image: image,
      fit: BoxFit.contain,
    );
  }

  @override
  bool shouldRepaint(covariant ImagePainter oldDelegate) {
    // Repaint only if the image object itself changes.
    return oldDelegate.image != image;
  }
}
