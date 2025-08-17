import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/constants/size.dart';
import '../../core/extensions/theme.dart';
import '../../core/theme.dart';

class OutlinedAppButton extends StatefulWidget {
  const OutlinedAppButton({
    super.key,
    this.onPressed,
    required this.isLoading,
    required this.label,
    this.borderColor,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;
  final Color? borderColor;

  @override
  State<OutlinedAppButton> createState() => _OutlinedAppButtonState();
}

class _OutlinedAppButtonState extends State<OutlinedAppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color effectiveBorderColor = widget.borderColor ?? AppTheme.primary;

    return Stack(
      children: [
        OutlinedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: radiusFull),
            side: BorderSide(color: effectiveBorderColor, width: 2),
          ),
          child: Text(
            widget.label,
            style: context.textTheme.titleMedium?.copyWith(
              color: widget.isLoading ? Colors.grey : effectiveBorderColor,
            ),
          ),
        ),
        if (widget.isLoading)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: LoadingBorderPainter(
                  animation: _controller,
                  borderRadius: radiusFull,
                  color: effectiveBorderColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Reuse the same LoadingBorderPainter from PrimaryButton
class LoadingBorderPainter extends CustomPainter {
  LoadingBorderPainter({
    required this.animation,
    required this.borderRadius,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final BorderRadius borderRadius;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = color ?? AppTheme.primary;

    paint.shader = SweepGradient(
      center: Alignment.center.resolve(null),
      startAngle: 0.0,
      endAngle: 2 * pi,
      colors: [Colors.transparent, color ?? AppTheme.primary],
      stops: const [0.75, 1.0],
      transform: GradientRotation(animation.value * 2 * pi),
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final RRect rrect = borderRadius.toRRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant LoadingBorderPainter oldDelegate) => false;
}
