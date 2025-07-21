import 'dart:math';

import 'package:ayur_scoliosis_management/core/constants/size.dart';
import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    this.onPressed,
    required this.isLoading,
    required this.label,
  });
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Controls the speed of the loader
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FilledButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: radiusFull),
          ),
          child: Text(
            widget.label,
            style: context.textTheme.titleMedium?.copyWith(
              // Hide text when loading to avoid visual clutter
              color: widget.isLoading ? Colors.grey : Colors.white,
            ),
          ),
        ),
        // This is the animated border overlay
        if (widget.isLoading)
          Positioned.fill(
            child: IgnorePointer(
              // Prevents the overlay from capturing touch events
              child: CustomPaint(
                painter: LoadingBorderPainter(
                  animation: _controller,
                  borderRadius: radiusFull,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class LoadingBorderPainter extends CustomPainter {
  final Animation<double> animation;
  final BorderRadius borderRadius;

  LoadingBorderPainter({required this.animation, required this.borderRadius})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          2.5 // The thickness of the loading line
      ..color = AppTheme.primary; // The color of the loading line

    // Create the shader for the gradient effect
    paint.shader = SweepGradient(
      center: Alignment.center.resolve(null),
      startAngle: 0.0,
      endAngle: 2 * pi,
      // Define the colors for the "line". It fades from transparent to the main color.
      colors: const [Colors.transparent, AppTheme.primary],
      // Stops define where the colors are placed. This creates a line that is 1/4 of the circumference.
      stops: const [0.75, 1.0],
      // The transform rotates the gradient based on the animation controller's value
      transform: GradientRotation(animation.value * 2 * pi),
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create the rounded rectangle path
    final RRect rrect = borderRadius.toRRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );

    // Draw the path on the canvas
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant LoadingBorderPainter oldDelegate) {
    // We don't need to manually check for repainting since the `repaint`
    // argument in the constructor handles it based on the animation.
    return false;
  }
}
