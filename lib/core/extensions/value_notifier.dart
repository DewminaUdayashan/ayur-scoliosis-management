import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart' show ValueListenableBuilder, Widget;

/// An extension on [ValueListenable] to simplify building widgets that depend on its value.
///
/// This extension provides a convenient method to build widgets by listening to changes
/// in the value of a [ValueListenable].
///
/// Example usage:
/// ```dart
/// final counter = useState(0);
///
/// counter.build((value) {
///   return Text('Counter: $value');
/// });
/// ```
///
/// [T] is the type of the value being listened to.
extension ValueListenableExtensions<T> on ValueListenable<T> {
  /// Builds a widget by listening to the value of the [ValueListenable].
  ///
  /// The [builder] function is called whenever the value changes, and it receives
  /// the current value of the [ValueListenable].
  ///
  /// - [builder]: A function that takes the current value and returns a widget.
  ///
  /// Returns a [ValueListenableBuilder] that listens to the [ValueListenable] and
  /// rebuilds the widget whenever the value changes.
  Widget build(Widget Function(T value) builder) {
    return ValueListenableBuilder<T>(
      valueListenable: this,
      builder: (context, value, child) {
        return builder(value);
      },
    );
  }
}
