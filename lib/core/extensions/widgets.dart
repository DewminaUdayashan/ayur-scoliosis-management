import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  /// Converts the widget into a [SliverToBoxAdapter].
  /// This is useful for integrating a regular widget into a sliver-based layout.
  /// Example usage:
  /// ```dart
  /// CustomScrollView(
  ///   slivers: [
  ///     myWidget.sliverToBoxAdapter,
  ///   ],
  /// )
  /// ```
  SliverToBoxAdapter get sliverToBoxAdapter {
    return SliverToBoxAdapter(child: this);
  }
}
