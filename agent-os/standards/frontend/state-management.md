## Flutter state management with GetX

### GetX Setup

- **Package**: get: ^4.6.0 or latest stable
- **Architecture**: GetX pattern (Controller, View, Binding)

### Controller Pattern

```dart
class ExampleController extends GetxController {
  // Observable state
  final _count = 0.obs;
  int get count => _count.value;

  // Actions
  void increment() => _count.value++;

  @override
  void onInit() {
    super.onInit();
    // Initialize resources
  }

  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
}
```

### View Pattern

```dart
class ExampleView extends GetView<ExampleController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Text('${controller.count}'));
  }
}
```

### Binding Pattern

```dart
class ExampleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExampleController>(() => ExampleController());
  }
}
```

### Best Practices

- **Reactive State**: Use .obs for reactive variables
- **GetView**: Extend GetView for cleaner code
- **Bindings**: Use bindings for dependency injection
- **Navigation**: Use GetX navigation
- **Dispose**: Always clean up in onClose()
