import 'dart:ui' show Size;

import 'package:flutter/material.dart' show MediaQuery, BuildContext;

extension SizeExtension on BuildContext {
  /// Returns the size of the screen.
  ///
  /// This is equivalent to calling `MediaQuery.of(context).size`.
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Returns the width of the screen.
  ///
  /// This is a convenience getter for accessing the width of the screen
  /// without having to call `MediaQuery.of(context).size.width`.
  double get width => screenSize.width;

  /// Returns the height of the screen.
  ///
  /// This is a convenience getter for accessing the height of the screen
  /// without having to call `MediaQuery.of(context).size.height`.
  double get height => screenSize.height;
}
