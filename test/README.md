# Unit Tests for SpineAlign

This directory contains comprehensive unit tests for the SpineAlign - Ayurvedic Scoliosis Management application.

## Test Coverage

### ✅ Measurement Tool Tests
**File:** `test/screens/measurement/measurement_tool_test.dart`  
**Coverage:** 23 test cases

#### CobbAngleToolScreen Widget Tests (18 tests)
- UI rendering and layout tests
- AppBar title and buttons
- Instruction text display
- Read-only mode functionality
- Save button visibility and functionality
- Reset button functionality
- CustomPaint rendering
- GestureDetector presence and configuration
- Initial measurements loading
- Multiple measurements display

#### CobbAnglePainter Tests (5 tests)
- Painter repaint behavior
- Multiple measurements rendering
- Incomplete measurements handling
- Dragged point highlighting
- Canvas painting verification

### ✅ Measurement Model Tests
**File:** `test/models/xray/measurement_test.dart`  
**Coverage:** 39 test cases

#### Constructor Tests (2 tests)
- Full parameter initialization
- Null parameter initialization

#### Points Getter Tests (2 tests)
- Complete measurement points list
- Incomplete measurement with null values

#### isComplete Getter Tests (6 tests)
- Complete measurement validation
- Individual null point detection
- All null points handling

#### calculateCobbAngle Tests (8 tests)
- Perpendicular lines (90°)
- 45-degree angle calculation
- Smaller angle selection
- Incomplete measurement handling
- Parallel lines (0°)
- Opposite parallel lines
- Angle recalculation on point changes

#### copyWith Tests (3 tests)
- Single field update
- Multiple field updates
- Identical copy creation

#### Serialization Tests (3 tests)
- toMap conversion
- fromMap creation with various data types
- Null value handling

#### JSON Tests (3 tests)
- toJson string conversion
- fromJson deserialization
- Round-trip serialization

#### toString Tests (1 test)
- String representation format

#### Equality Tests (4 tests)
- Identical measurements
- Different line1Start
- Different cobbAngle
- Self-equality

#### hashCode Tests (2 tests)
- Same hashCode for equal measurements
- Different hashCode for different measurements

#### Edge Cases Tests (3 tests)
- Very small angles
- Negative coordinates
- Zero-length lines

## Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/screens/measurement/measurement_tool_test.dart
flutter test test/models/xray/measurement_test.dart
```

### Run with coverage
```bash
flutter test --coverage
```

### Run in watch mode
```bash
flutter test --watch
```

## Test Results

**Total Test Cases:** 62  
**Status:** ✅ All tests passing

```
00:10 +62: All tests passed!
```

## Test Structure

```
test/
├── README.md
├── models/
│   └── xray/
│       └── measurement_test.dart (39 tests)
└── screens/
    └── measurement/
        └── measurement_tool_test.dart (23 tests)
```

## Key Testing Patterns Used

### Widget Testing
- `testWidgets()` for Flutter widget tests
- `WidgetTester` for widget interaction
- `pump()` and `pumpWidget()` for rendering
- `find` matchers for widget discovery
- `expect()` assertions

### Unit Testing
- `test()` for pure Dart unit tests
- `group()` for organizing related tests
- `setUp()` and `tearDown()` for test fixtures
- Matcher library for assertions

### Test Doubles
- Mock data using real model instances
- Test fixtures for complex objects

## Best Practices Followed

1. **Descriptive Test Names:** Each test clearly describes what it tests
2. **AAA Pattern:** Arrange, Act, Assert structure
3. **Single Responsibility:** Each test validates one specific behavior
4. **Independence:** Tests don't depend on each other
5. **Edge Cases:** Includes boundary and error condition tests
6. **Coverage:** Tests cover happy paths, edge cases, and error scenarios

## Future Test Additions

Consider adding tests for:
- [ ] Integration tests with backend services
- [ ] Golden file tests for UI consistency
- [ ] Performance tests for large measurement sets
- [ ] Accessibility tests
- [ ] Gesture interaction tests with drag operations

## Dependencies

All test dependencies are included in `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

## Continuous Integration

These tests are designed to run in CI/CD pipelines. No external dependencies or special setup required beyond Flutter SDK.

---

**Last Updated:** November 18, 2025  
**Test Framework:** Flutter Test  
**Dart Version:** 3.0+  
**Flutter Version:** 3.8.1+
