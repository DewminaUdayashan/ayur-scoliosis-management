import 'dart:convert';

import 'package:ayur_scoliosis_management/models/xray/measurement.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Measurement', () {
    group('Constructor', () {
      test('should create measurement with all parameters', () {
        final measurement = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
          line2Start: const Offset(50, 60),
          line2End: const Offset(70, 80),
          cobbAngle: 45.5,
        );

        expect(measurement.line1Start, const Offset(10, 20));
        expect(measurement.line1End, const Offset(30, 40));
        expect(measurement.line2Start, const Offset(50, 60));
        expect(measurement.line2End, const Offset(70, 80));
        expect(measurement.cobbAngle, 45.5);
      });

      test('should create measurement with null parameters', () {
        final measurement = Measurement();

        expect(measurement.line1Start, isNull);
        expect(measurement.line1End, isNull);
        expect(measurement.line2Start, isNull);
        expect(measurement.line2End, isNull);
        expect(measurement.cobbAngle, isNull);
      });
    });

    group('points getter', () {
      test('should return list of four points', () {
        final measurement = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
          line2Start: const Offset(50, 60),
          line2End: const Offset(70, 80),
        );

        final points = measurement.points;

        expect(points.length, 4);
        expect(points[0], const Offset(10, 20));
        expect(points[1], const Offset(30, 40));
        expect(points[2], const Offset(50, 60));
        expect(points[3], const Offset(70, 80));
      });

      test(
        'should return list with null values for incomplete measurement',
        () {
          final measurement = Measurement(
            line1Start: const Offset(10, 20),
            line1End: const Offset(30, 40),
          );

          final points = measurement.points;

          expect(points.length, 4);
          expect(points[0], const Offset(10, 20));
          expect(points[1], const Offset(30, 40));
          expect(points[2], isNull);
          expect(points[3], isNull);
        },
      );
    });

    group('isComplete getter', () {
      test('should return true when all four points are set', () {
        final measurement = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
          line2Start: const Offset(50, 60),
          line2End: const Offset(70, 80),
        );

        expect(measurement.isComplete, true);
      });

      test('should return false when line1Start is null', () {
        final measurement = Measurement(
          line1End: const Offset(30, 40),
          line2Start: const Offset(50, 60),
          line2End: const Offset(70, 80),
        );

        expect(measurement.isComplete, false);
      });

      test('should return false when line1End is null', () {
        final measurement = Measurement(
          line1Start: const Offset(10, 20),
          line2Start: const Offset(50, 60),
          line2End: const Offset(70, 80),
        );

        expect(measurement.isComplete, false);
      });

      test('should return false when line2Start is null', () {
        final measurement = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
          line2End: const Offset(70, 80),
        );

        expect(measurement.isComplete, false);
      });

      test('should return false when line2End is null', () {
        final measurement = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
          line2Start: const Offset(50, 60),
        );

        expect(measurement.isComplete, false);
      });

      test('should return false when all points are null', () {
        final measurement = Measurement();

        expect(measurement.isComplete, false);
      });
    });

    group('calculateCobbAngle', () {
      test('should calculate angle for perpendicular lines (90 degrees)', () {
        final measurement = Measurement(
          line1Start: const Offset(0, 0),
          line1End: const Offset(100, 0),
          line2Start: const Offset(0, 0),
          line2End: const Offset(0, 100),
        );

        measurement.calculateCobbAngle();

        expect(measurement.cobbAngle, closeTo(90.0, 0.1));
      });

      test('should calculate angle for 45-degree lines', () {
        final measurement = Measurement(
          line1Start: const Offset(0, 0),
          line1End: const Offset(100, 0),
          line2Start: const Offset(0, 0),
          line2End: const Offset(100, 100),
        );

        measurement.calculateCobbAngle();

        expect(measurement.cobbAngle, closeTo(45.0, 0.1));
      });

      test('should calculate smaller angle between lines', () {
        final measurement = Measurement(
          line1Start: const Offset(0, 0),
          line1End: const Offset(100, 0),
          line2Start: const Offset(0, 0),
          line2End: const Offset(-50, 100),
        );

        measurement.calculateCobbAngle();

        // Should return the smaller of the two angles
        expect(measurement.cobbAngle, lessThan(90.0));
      });

      test('should set cobbAngle to null when measurement is incomplete', () {
        final measurement = Measurement(
          line1Start: const Offset(0, 0),
          line1End: const Offset(100, 0),
        );

        measurement.calculateCobbAngle();

        expect(measurement.cobbAngle, isNull);
      });

      test('should calculate angle for parallel lines (0 degrees)', () {
        final measurement = Measurement(
          line1Start: const Offset(0, 0),
          line1End: const Offset(100, 0),
          line2Start: const Offset(0, 50),
          line2End: const Offset(100, 50),
        );

        measurement.calculateCobbAngle();

        expect(measurement.cobbAngle, closeTo(0.0, 0.1));
      });

      test(
        'should calculate angle for opposite parallel lines (180 degrees -> 0)',
        () {
          final measurement = Measurement(
            line1Start: const Offset(0, 0),
            line1End: const Offset(100, 0),
            line2Start: const Offset(100, 0),
            line2End: const Offset(0, 0),
          );

          measurement.calculateCobbAngle();

          expect(measurement.cobbAngle, closeTo(0.0, 0.1));
        },
      );

      test('should recalculate angle when points change', () {
        final measurement = Measurement(
          line1Start: const Offset(0, 0),
          line1End: const Offset(100, 0),
          line2Start: const Offset(0, 0),
          line2End: const Offset(0, 100),
        );

        measurement.calculateCobbAngle();
        expect(measurement.cobbAngle, closeTo(90.0, 0.1));

        // Change line2End to make a 45-degree angle
        measurement.line2End = const Offset(100, 100);
        measurement.calculateCobbAngle();
        expect(measurement.cobbAngle, closeTo(45.0, 0.1));
      });
    });

    group('copyWith', () {
      test('should create copy with updated line1Start', () {
        final original = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
          line2Start: const Offset(50, 60),
          line2End: const Offset(70, 80),
          cobbAngle: 45.5,
        );

        final copy = original.copyWith(line1Start: const Offset(15, 25));

        expect(copy.line1Start, const Offset(15, 25));
        expect(copy.line1End, const Offset(30, 40));
        expect(copy.line2Start, const Offset(50, 60));
        expect(copy.line2End, const Offset(70, 80));
        expect(copy.cobbAngle, 45.5);
      });

      test('should create copy with multiple updated fields', () {
        final original = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
        );

        final copy = original.copyWith(
          line2Start: const Offset(50, 60),
          line2End: const Offset(70, 80),
        );

        expect(copy.line1Start, const Offset(10, 20));
        expect(copy.line1End, const Offset(30, 40));
        expect(copy.line2Start, const Offset(50, 60));
        expect(copy.line2End, const Offset(70, 80));
      });

      test('should create identical copy when no parameters provided', () {
        final original = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
          cobbAngle: 45.5,
        );

        final copy = original.copyWith();

        expect(copy.line1Start, original.line1Start);
        expect(copy.line1End, original.line1End);
        expect(copy.line2Start, original.line2Start);
        expect(copy.line2End, original.line2End);
        expect(copy.cobbAngle, original.cobbAngle);
      });
    });

    group('toMap', () {
      test('should convert measurement to map', () {
        final measurement = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
          line2Start: const Offset(50, 60),
          line2End: const Offset(70, 80),
          cobbAngle: 45.5,
        );

        final map = measurement.toMap();

        expect(map['line1Start']['x'], 10.0);
        expect(map['line1Start']['y'], 20.0);
        expect(map['line1End']['x'], 30.0);
        expect(map['line1End']['y'], 40.0);
        expect(map['line2Start']['x'], 50.0);
        expect(map['line2Start']['y'], 60.0);
        expect(map['line2End']['x'], 70.0);
        expect(map['line2End']['y'], 80.0);
        expect(map['cobbAngle'], 45.5);
      });

      test('should handle null values in map', () {
        final measurement = Measurement();

        final map = measurement.toMap();

        expect(map['line1Start']['x'], isNull);
        expect(map['line1Start']['y'], isNull);
        expect(map['cobbAngle'], isNull);
      });
    });

    group('fromMap', () {
      test('should create measurement from map', () {
        final map = {
          'line1Start': {'x': 10.0, 'y': 20.0},
          'line1End': {'x': 30.0, 'y': 40.0},
          'line2Start': {'x': 50.0, 'y': 60.0},
          'line2End': {'x': 70.0, 'y': 80.0},
          'cobbAngle': 45.5,
        };

        final measurement = Measurement.fromMap(map);

        expect(measurement.line1Start, const Offset(10, 20));
        expect(measurement.line1End, const Offset(30, 40));
        expect(measurement.line2Start, const Offset(50, 60));
        expect(measurement.line2End, const Offset(70, 80));
        expect(measurement.cobbAngle, 45.5);
      });

      test('should handle null values from map', () {
        final map = {
          'line1Start': null,
          'line1End': null,
          'line2Start': null,
          'line2End': null,
          'cobbAngle': null,
        };

        final measurement = Measurement.fromMap(map);

        expect(measurement.line1Start, isNull);
        expect(measurement.line1End, isNull);
        expect(measurement.line2Start, isNull);
        expect(measurement.line2End, isNull);
        expect(measurement.cobbAngle, isNull);
      });

      test('should parse string numbers to double', () {
        final map = {
          'line1Start': {'x': '10', 'y': '20'},
          'line1End': {'x': '30.5', 'y': '40.5'},
          'line2Start': {'x': 50, 'y': 60},
          'line2End': {'x': 70, 'y': 80},
          'cobbAngle': '45.5',
        };

        final measurement = Measurement.fromMap(map);

        expect(measurement.line1Start, const Offset(10, 20));
        expect(measurement.line1End, const Offset(30.5, 40.5));
        expect(measurement.cobbAngle, 45.5);
      });
    });

    group('JSON serialization', () {
      test('should convert to JSON string', () {
        final measurement = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
          line2Start: const Offset(50, 60),
          line2End: const Offset(70, 80),
          cobbAngle: 45.5,
        );

        final jsonString = measurement.toJson();
        final decoded = json.decode(jsonString);

        expect(decoded, isA<Map>());
        expect(decoded['line1Start']['x'], 10.0);
        expect(decoded['cobbAngle'], 45.5);
      });

      test('should create from JSON string', () {
        const jsonString = '''
        {
          "line1Start": {"x": 10.0, "y": 20.0},
          "line1End": {"x": 30.0, "y": 40.0},
          "line2Start": {"x": 50.0, "y": 60.0},
          "line2End": {"x": 70.0, "y": 80.0},
          "cobbAngle": 45.5
        }
        ''';

        final measurement = Measurement.fromJson(jsonString);

        expect(measurement.line1Start, const Offset(10, 20));
        expect(measurement.line1End, const Offset(30, 40));
        expect(measurement.line2Start, const Offset(50, 60));
        expect(measurement.line2End, const Offset(70, 80));
        expect(measurement.cobbAngle, 45.5);
      });

      test('should round-trip through JSON', () {
        final original = Measurement(
          line1Start: const Offset(10.5, 20.5),
          line1End: const Offset(30.5, 40.5),
          line2Start: const Offset(50.5, 60.5),
          line2End: const Offset(70.5, 80.5),
          cobbAngle: 45.5,
        );

        final jsonString = original.toJson();
        final deserialized = Measurement.fromJson(jsonString);

        expect(deserialized.line1Start, original.line1Start);
        expect(deserialized.line1End, original.line1End);
        expect(deserialized.line2Start, original.line2Start);
        expect(deserialized.line2End, original.line2End);
        expect(deserialized.cobbAngle, original.cobbAngle);
      });
    });

    group('toString', () {
      test('should return string representation', () {
        final measurement = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
          line2Start: const Offset(50, 60),
          line2End: const Offset(70, 80),
          cobbAngle: 45.5,
        );

        final str = measurement.toString();

        expect(str, contains('Measurement'));
        expect(str, contains('line1Start: Offset(10.0, 20.0)'));
        expect(str, contains('line1End: Offset(30.0, 40.0)'));
        expect(str, contains('line2Start: Offset(50.0, 60.0)'));
        expect(str, contains('line2End: Offset(70.0, 80.0)'));
        expect(str, contains('cobbAngle: 45.5'));
      });
    });

    group('Equality', () {
      test('should be equal for identical measurements', () {
        final measurement1 = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
          line2Start: const Offset(50, 60),
          line2End: const Offset(70, 80),
          cobbAngle: 45.5,
        );

        final measurement2 = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
          line2Start: const Offset(50, 60),
          line2End: const Offset(70, 80),
          cobbAngle: 45.5,
        );

        expect(measurement1, equals(measurement2));
      });

      test('should not be equal for different line1Start', () {
        final measurement1 = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
        );

        final measurement2 = Measurement(
          line1Start: const Offset(15, 20),
          line1End: const Offset(30, 40),
        );

        expect(measurement1, isNot(equals(measurement2)));
      });

      test('should not be equal for different cobbAngle', () {
        final measurement1 = Measurement(
          line1Start: const Offset(10, 20),
          cobbAngle: 45.5,
        );

        final measurement2 = Measurement(
          line1Start: const Offset(10, 20),
          cobbAngle: 50.0,
        );

        expect(measurement1, isNot(equals(measurement2)));
      });

      test('should be equal to itself', () {
        final measurement = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
        );

        expect(measurement, equals(measurement));
      });
    });

    group('hashCode', () {
      test('should have same hashCode for equal measurements', () {
        final measurement1 = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
          cobbAngle: 45.5,
        );

        final measurement2 = Measurement(
          line1Start: const Offset(10, 20),
          line1End: const Offset(30, 40),
          cobbAngle: 45.5,
        );

        expect(measurement1.hashCode, equals(measurement2.hashCode));
      });

      test('should have different hashCode for different measurements', () {
        final measurement1 = Measurement(line1Start: const Offset(10, 20));

        final measurement2 = Measurement(line1Start: const Offset(15, 20));

        expect(measurement1.hashCode, isNot(equals(measurement2.hashCode)));
      });
    });

    group('Edge cases', () {
      test('should handle very small angles', () {
        final measurement = Measurement(
          line1Start: const Offset(0, 0),
          line1End: const Offset(1000, 0),
          line2Start: const Offset(0, 0),
          line2End: const Offset(1000, 1),
        );

        measurement.calculateCobbAngle();

        expect(measurement.cobbAngle, greaterThan(0));
        expect(measurement.cobbAngle, lessThan(1));
      });

      test('should handle negative coordinates', () {
        final measurement = Measurement(
          line1Start: const Offset(-50, -50),
          line1End: const Offset(-10, -10),
          line2Start: const Offset(-50, -10),
          line2End: const Offset(-10, -50),
        );

        measurement.calculateCobbAngle();

        expect(measurement.cobbAngle, closeTo(90.0, 0.1));
      });

      test('should handle zero-length lines', () {
        final measurement = Measurement(
          line1Start: const Offset(50, 50),
          line1End: const Offset(50, 50),
          line2Start: const Offset(50, 50),
          line2End: const Offset(50, 50),
        );

        measurement.calculateCobbAngle();

        // Should still calculate (though result may be 0 or NaN)
        expect(measurement.cobbAngle, isNotNull);
      });
    });
  });
}
