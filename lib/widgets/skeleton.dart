import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({required this.builder, super.key});
  final Widget Function(BoxDecoration decoration) builder;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withAlpha(30),
      highlightColor: Colors.grey.shade400.withAlpha(20),
      child: builder(
        BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
