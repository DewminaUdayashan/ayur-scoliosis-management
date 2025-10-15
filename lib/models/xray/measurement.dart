import 'dart:convert';
import 'dart:math' show min;
import 'dart:ui' show Offset;

import 'package:vector_math/vector_math_64.dart' as vector;

class Measurement {
  Offset? line1Start;
  Offset? line1End;
  Offset? line2Start;
  Offset? line2End;
  double? cobbAngle;

  Measurement({
    this.line1Start,
    this.line1End,
    this.line2Start,
    this.line2End,
    this.cobbAngle,
  });

  /// Returns a list of the four points defining the measurement lines.
  List<Offset?> get points => [line1Start, line1End, line2Start, line2End];

  /// Checks if the measurement is fully defined with four points.
  bool get isComplete =>
      line1Start != null &&
      line1End != null &&
      line2Start != null &&
      line2End != null;

  /// Calculates the Cobb angle based on the current line points.
  void calculateCobbAngle() {
    if (isComplete) {
      final vec1 = vector.Vector2(
        line1End!.dx - line1Start!.dx,
        line1End!.dy - line1Start!.dy,
      );
      final vec2 = vector.Vector2(
        line2End!.dx - line2Start!.dx,
        line2End!.dy - line2Start!.dy,
      );
      final angleInRadians = vec1.angleTo(vec2);
      final angleInDegrees = vector.degrees(angleInRadians);
      // Cobb angle is the smaller angle between the two lines.
      cobbAngle = min(angleInDegrees, 180 - angleInDegrees);
    } else {
      cobbAngle = null;
    }
  }

  Measurement copyWith({
    Offset? line1Start,
    Offset? line1End,
    Offset? line2Start,
    Offset? line2End,
    double? cobbAngle,
  }) {
    return Measurement(
      line1Start: line1Start ?? this.line1Start,
      line1End: line1End ?? this.line1End,
      line2Start: line2Start ?? this.line2Start,
      line2End: line2End ?? this.line2End,
      cobbAngle: cobbAngle ?? this.cobbAngle,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'line1Start': {'x': line1Start?.dx, 'y': line1Start?.dy},
      'line1End': {'x': line1End?.dx, 'y': line1End?.dy},
      'line2Start': {'x': line2Start?.dx, 'y': line2Start?.dy},
      'line2End': {'x': line2End?.dx, 'y': line2End?.dy},
      'cobbAngle': cobbAngle,
    };
  }

  factory Measurement.fromMap(Map<String, dynamic> map) {
    return Measurement(
      line1Start: map['line1Start'] != null
          ? Offset(
              double.parse(map['line1Start']['x'].toString()),
              double.parse(map['line1Start']['y'].toString()),
            )
          : null,
      line1End: map['line1End'] != null
          ? Offset(
              double.parse(map['line1End']['x'].toString()),
              double.parse(map['line1End']['y'].toString()),
            )
          : null,
      line2Start: map['line2Start'] != null
          ? Offset(
              double.parse(map['line2Start']['x'].toString()),
              double.parse(map['line2Start']['y'].toString()),
            )
          : null,
      line2End: map['line2End'] != null
          ? Offset(
              double.parse(map['line2End']['x'].toString()),
              double.parse(map['line2End']['y'].toString()),
            )
          : null,
      cobbAngle: map['cobbAngle'] != null
          ? double.parse(map['cobbAngle'].toString())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Measurement.fromJson(String source) =>
      Measurement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Measurement(line1Start: $line1Start, line1End: $line1End, line2Start: $line2Start, line2End: $line2End, cobbAngle: $cobbAngle)';
  }

  @override
  bool operator ==(covariant Measurement other) {
    if (identical(this, other)) return true;

    return other.line1Start == line1Start &&
        other.line1End == line1End &&
        other.line2Start == line2Start &&
        other.line2End == line2End &&
        other.cobbAngle == cobbAngle;
  }

  @override
  int get hashCode {
    return line1Start.hashCode ^
        line1End.hashCode ^
        line2Start.hashCode ^
        line2End.hashCode ^
        cobbAngle.hashCode;
  }
}
