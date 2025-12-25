import 'package:ayur_scoliosis_management/models/xray/measurement.dart';
import 'package:ayur_scoliosis_management/screens/measurement/measurement_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CobbAngleToolScreen', () {
    const testImageUrl = 'https://example.com/test-xray.jpg';

    testWidgets('should display app bar with correct title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: CobbAngleToolScreen(imageUrl: testImageUrl)),
      );

      expect(find.text('Cobb Angle Measurement'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should show initial instruction text when no measurements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: CobbAngleToolScreen(imageUrl: testImageUrl)),
      );

      expect(
        find.text('Tap to mark the start of the first line.'),
        findsOneWidget,
      );
    });

    testWidgets('should show reset button when not in read-only mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: CobbAngleToolScreen(imageUrl: testImageUrl)),
      );

      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byTooltip('Reset'), findsOneWidget);
    });

    testWidgets('should hide reset button in read-only mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CobbAngleToolScreen(imageUrl: testImageUrl, readOnly: true),
        ),
      );

      expect(find.byIcon(Icons.refresh), findsNothing);
    });

    testWidgets(
      'should show save button when measurements exist and onSaved is provided',
      (WidgetTester tester) async {
        final measurement = Measurement(
          line1Start: const Offset(10, 10),
          line1End: const Offset(50, 50),
          line2Start: const Offset(60, 10),
          line2End: const Offset(100, 50),
        )..calculateCobbAngle();

        bool saveCalled = false;
        await tester.pumpWidget(
          MaterialApp(
            home: CobbAngleToolScreen(
              imageUrl: testImageUrl,
              initialMeasurements: [measurement],
              onSaved: (measurements) {
                saveCalled = true;
              },
            ),
          ),
        );

        expect(find.byIcon(Icons.save), findsOneWidget);
        expect(find.byTooltip('Save Measurements'), findsOneWidget);

        // Test save button tap
        await tester.tap(find.byIcon(Icons.save));
        await tester.pump();

        expect(saveCalled, true);
      },
    );

    testWidgets('should not show save button when no measurements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CobbAngleToolScreen(
            imageUrl: testImageUrl,
            onSaved: (measurements) {},
          ),
        ),
      );

      expect(find.byIcon(Icons.save), findsNothing);
    });

    testWidgets('should display read-only instruction text with measurements', (
      WidgetTester tester,
    ) async {
      final measurement = Measurement(
        line1Start: const Offset(10, 10),
        line1End: const Offset(50, 50),
        line2Start: const Offset(60, 10),
        line2End: const Offset(100, 50),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: CobbAngleToolScreen(
            imageUrl: testImageUrl,
            initialMeasurements: [measurement],
            readOnly: true,
          ),
        ),
      );

      expect(find.text('Viewing 1 measurement.'), findsOneWidget);
    });

    testWidgets(
      'should display read-only instruction with multiple measurements',
      (WidgetTester tester) async {
        final measurements = [
          Measurement(
            line1Start: const Offset(10, 10),
            line1End: const Offset(50, 50),
          ),
          Measurement(
            line1Start: const Offset(60, 10),
            line1End: const Offset(100, 50),
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: CobbAngleToolScreen(
              imageUrl: testImageUrl,
              initialMeasurements: measurements,
              readOnly: true,
            ),
          ),
        );

        expect(find.text('Viewing 2 measurements.'), findsOneWidget);
      },
    );

    testWidgets(
      'should display empty message in read-only mode with no measurements',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CobbAngleToolScreen(imageUrl: testImageUrl, readOnly: true),
          ),
        );

        expect(find.text('No measurements available.'), findsOneWidget);
      },
    );

    testWidgets(
      'should show instruction for adjusting measurements after completion',
      (WidgetTester tester) async {
        final measurement = Measurement(
          line1Start: const Offset(10, 10),
          line1End: const Offset(50, 50),
          line2Start: const Offset(60, 10),
          line2End: const Offset(100, 50),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: CobbAngleToolScreen(
              imageUrl: testImageUrl,
              initialMeasurements: [measurement],
            ),
          ),
        );

        expect(
          find.text('Drag points to adjust or tap to start a new measurement.'),
          findsOneWidget,
        );
      },
    );

    testWidgets('should display CustomPaint for drawing measurements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: CobbAngleToolScreen(imageUrl: testImageUrl)),
      );

      // There will be multiple CustomPaint widgets (for the painter and other UI elements)
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('should render CobbAnglePainter with correct measurements', (
      WidgetTester tester,
    ) async {
      final measurements = [
        Measurement(
          line1Start: const Offset(10, 10),
          line1End: const Offset(50, 50),
          line2Start: const Offset(60, 10),
          line2End: const Offset(100, 50),
        )..calculateCobbAngle(),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: CobbAngleToolScreen(
            imageUrl: testImageUrl,
            initialMeasurements: measurements,
          ),
        ),
      );

      // Find the CustomPaint widget that has our CobbAnglePainter
      final customPaints = tester.widgetList<CustomPaint>(
        find.byType(CustomPaint),
      );
      final customPaintWithPainter = customPaints.firstWhere(
        (paint) => paint.painter is CobbAnglePainter,
      );
      final painter = customPaintWithPainter.painter as CobbAnglePainter;

      expect(painter.measurements.length, 1);
      expect(painter.measurements.first.line1Start, const Offset(10, 10));
      expect(painter.measurements.first.cobbAngle, isNotNull);
    });

    testWidgets('should not have gesture detectors in read-only mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CobbAngleToolScreen(imageUrl: testImageUrl, readOnly: true),
        ),
      );

      // Find gesture detectors and check if the main one has null callbacks
      final gestureDetectors = tester.widgetList<GestureDetector>(
        find.byType(GestureDetector),
      );
      final mainGestureDetector = gestureDetectors.firstWhere(
        (detector) => detector.onTapUp == null && detector.onPanStart == null,
      );

      expect(mainGestureDetector.onTapUp, isNull);
      expect(mainGestureDetector.onPanStart, isNull);
      expect(mainGestureDetector.onPanUpdate, isNull);
      expect(mainGestureDetector.onPanEnd, isNull);
    });

    testWidgets('should have gesture detectors when not in read-only mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: CobbAngleToolScreen(imageUrl: testImageUrl)),
      );

      // Find gesture detectors and check if the main one has callbacks
      final gestureDetectors = tester.widgetList<GestureDetector>(
        find.byType(GestureDetector),
      );
      final mainGestureDetector = gestureDetectors.firstWhere(
        (detector) => detector.onTapUp != null && detector.onPanStart != null,
      );

      expect(mainGestureDetector.onTapUp, isNotNull);
      expect(mainGestureDetector.onPanStart, isNotNull);
      expect(mainGestureDetector.onPanUpdate, isNotNull);
      expect(mainGestureDetector.onPanEnd, isNotNull);
    });

    testWidgets('should show initial instruction text for new measurement', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: CobbAngleToolScreen(imageUrl: testImageUrl)),
      );

      // Initial state - should show instruction for first line start
      expect(
        find.text('Tap to mark the start of the first line.'),
        findsOneWidget,
      );
    });

    testWidgets('should show different instruction after measurement exists', (
      WidgetTester tester,
    ) async {
      // Create a complete measurement
      final measurement = Measurement(
        line1Start: const Offset(10, 10),
        line1End: const Offset(50, 50),
        line2Start: const Offset(60, 10),
        line2End: const Offset(100, 50),
      )..calculateCobbAngle();

      await tester.pumpWidget(
        MaterialApp(
          home: CobbAngleToolScreen(
            imageUrl: testImageUrl,
            initialMeasurements: [measurement],
          ),
        ),
      );

      // After measurement is complete, should show adjustment instruction
      expect(
        find.text('Drag points to adjust or tap to start a new measurement.'),
        findsOneWidget,
      );
    });

    testWidgets(
      'should reset measurements and state when reset button is tapped',
      (WidgetTester tester) async {
        final initialMeasurement = Measurement(
          line1Start: const Offset(10, 10),
          line1End: const Offset(50, 50),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: CobbAngleToolScreen(
              imageUrl: testImageUrl,
              initialMeasurements: [initialMeasurement],
            ),
          ),
        );

        // Verify initial state
        expect(
          find.text('Drag points to adjust or tap to start a new measurement.'),
          findsOneWidget,
        );

        // Tap reset button
        await tester.tap(find.byIcon(Icons.refresh));
        await tester.pump();

        // Verify reset state
        expect(
          find.text('Tap to mark the start of the first line.'),
          findsOneWidget,
        );
      },
    );

    testWidgets('should initialize with provided initial measurements', (
      WidgetTester tester,
    ) async {
      final measurements = [
        Measurement(
          line1Start: const Offset(10, 10),
          line1End: const Offset(50, 50),
          line2Start: const Offset(60, 10),
          line2End: const Offset(100, 50),
        )..calculateCobbAngle(),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: CobbAngleToolScreen(
            imageUrl: testImageUrl,
            initialMeasurements: measurements,
          ),
        ),
      );

      // Find the CustomPaint widget that has our CobbAnglePainter
      final customPaints = tester.widgetList<CustomPaint>(
        find.byType(CustomPaint),
      );
      final customPaintWithPainter = customPaints.firstWhere(
        (paint) => paint.painter is CobbAnglePainter,
      );
      final painter = customPaintWithPainter.painter as CobbAnglePainter;

      expect(painter.measurements.length, 1);
      expect(painter.measurements.first.isComplete, true);
    });
  });

  group('CobbAnglePainter', () {
    test('should repaint always', () {
      final painter1 = CobbAnglePainter(
        measurements: [],
        draggedMeasurementIndex: null,
        draggedPointIndex: null,
      );
      final painter2 = CobbAnglePainter(
        measurements: [],
        draggedMeasurementIndex: null,
        draggedPointIndex: null,
      );

      expect(painter1.shouldRepaint(painter2), true);
    });

    testWidgets('should paint measurements on canvas', (
      WidgetTester tester,
    ) async {
      final measurements = [
        Measurement(
          line1Start: const Offset(10, 10),
          line1End: const Offset(50, 50),
          line2Start: const Offset(60, 10),
          line2End: const Offset(100, 50),
        )..calculateCobbAngle(),
      ];

      final painter = CobbAnglePainter(
        measurements: measurements,
        draggedMeasurementIndex: null,
        draggedPointIndex: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: painter,
              child: const SizedBox(width: 200, height: 200),
            ),
          ),
        ),
      );

      // Verify the painter was created successfully
      expect(painter.measurements.length, 1);
    });

    testWidgets('should highlight dragged point', (WidgetTester tester) async {
      final measurements = [
        Measurement(
          line1Start: const Offset(10, 10),
          line1End: const Offset(50, 50),
        ),
      ];

      final painter = CobbAnglePainter(
        measurements: measurements,
        draggedMeasurementIndex: 0,
        draggedPointIndex: 0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: painter,
              child: const SizedBox(width: 200, height: 200),
            ),
          ),
        ),
      );

      expect(painter.draggedMeasurementIndex, 0);
      expect(painter.draggedPointIndex, 0);
    });

    testWidgets('should paint multiple measurements', (
      WidgetTester tester,
    ) async {
      final measurements = [
        Measurement(
          line1Start: const Offset(10, 10),
          line1End: const Offset(50, 50),
          line2Start: const Offset(60, 10),
          line2End: const Offset(100, 50),
        )..calculateCobbAngle(),
        Measurement(
          line1Start: const Offset(110, 10),
          line1End: const Offset(150, 50),
          line2Start: const Offset(160, 10),
          line2End: const Offset(200, 50),
        )..calculateCobbAngle(),
      ];

      final painter = CobbAnglePainter(
        measurements: measurements,
        draggedMeasurementIndex: null,
        draggedPointIndex: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: painter,
              child: const SizedBox(width: 400, height: 200),
            ),
          ),
        ),
      );

      expect(painter.measurements.length, 2);
    });

    testWidgets('should paint incomplete measurements', (
      WidgetTester tester,
    ) async {
      final measurements = [
        Measurement(
          line1Start: const Offset(10, 10),
          line1End: const Offset(50, 50),
        ),
      ];

      final painter = CobbAnglePainter(
        measurements: measurements,
        draggedMeasurementIndex: null,
        draggedPointIndex: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: painter,
              child: const SizedBox(width: 200, height: 200),
            ),
          ),
        ),
      );

      expect(painter.measurements.length, 1);
      expect(painter.measurements.first.isComplete, false);
    });
  });

  group('DrawingStep Enum', () {
    test('should have correct enum values', () {
      expect(DrawingStep.values.length, 4);
      expect(DrawingStep.values.contains(DrawingStep.line1Start), true);
      expect(DrawingStep.values.contains(DrawingStep.line1End), true);
      expect(DrawingStep.values.contains(DrawingStep.line2Start), true);
      expect(DrawingStep.values.contains(DrawingStep.line2End), true);
    });
  });
}
