import 'package:flutter/material.dart';

/// Extension on [BuildContext] to provide convenient access to theme-related properties.
///
/// This extension simplifies accessing theme data, colors, and text styles
/// throughout the application by providing direct getters on the build context.
///
/// Example usage:
/// ```dart
/// Widget build(BuildContext context) {
///   return Container(
///     color: context.primaryColor,
///     child: Text(
///       'Hello World',
///       style: context.textTheme.headlineMedium,
///     ),
///   );
/// }
/// ```
extension ThemeExtension on BuildContext {
  /// Returns the current [ThemeData] for this build context.
  ///
  /// This is equivalent to calling `Theme.of(context)`.
  ThemeData get theme => Theme.of(this);

  /// Returns the current [ColorScheme] for this build context.
  ///
  /// This is equivalent to calling `Theme.of(context).colorScheme`.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Returns the primary color from the current theme.
  ///
  /// This is a convenience getter for accessing the theme's primary color
  /// without having to call `Theme.of(context).primaryColor`.
  Color get primaryColor => theme.primaryColor;

  /// Returns the secondary color from the current theme's color scheme.
  ///
  /// This is a convenience getter for accessing the theme's secondary color
  /// without having to call `Theme.of(context).colorScheme.secondary`.
  Color get secondaryColor => theme.colorScheme.secondary;

  /// Returns the text theme from the current theme.
  ///
  /// This is a convenience getter for accessing text styles defined in the theme
  /// without having to call `Theme.of(context).textTheme`.
  ///
  /// Example:
  /// ```dart
  /// Text(
  ///   'Title',
  ///   style: context.textTheme.headlineLarge,
  /// )
  /// ```
  TextTheme get textTheme => theme.textTheme;
}
