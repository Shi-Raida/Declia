## Flutter testing standards

### Test Types

- **Unit Tests**: Test individual functions/classes
- **Widget Tests**: Test widget behavior
- **Integration Tests**: Test complete app flows

### Testing Stack

- **Framework**: flutter_test
- **Mocking**: Mockito for mock generation
- **Property Testing**: glados for property-based tests
- **GetX Testing**: get_test for GetX controllers

### Directory Structure

```
test/
├── unit/          # Pure Dart logic tests
├── widget/        # Widget tests
├── integration/   # Integration tests
└── fixtures/      # Test data
```

### Widget Testing

```dart
testWidgets('Widget test description', (WidgetTester tester) async {
  await tester.pumpWidget(
    GetMaterialApp(
      home: WidgetUnderTest(),
    ),
  );

  expect(find.text('Expected'), findsOneWidget);

  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();

  expect(find.text('After tap'), findsOneWidget);
});
```

### GetX Controller Testing

```dart
test('Controller test', () {
  final controller = ExampleController();

  controller.increment();

  expect(controller.count, 1);

  controller.onClose();
});
```

### Best Practices

- **Test Coverage**: Aim for 80%+
- **Mock External Dependencies**: Database, API calls
- **Test Names**: Descriptive "should..." format
- **Golden Tests**: For UI regression
- **Test Data**: Use fixtures for consistency
