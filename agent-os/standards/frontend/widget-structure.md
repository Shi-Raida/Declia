## Flutter widget structure and organization

### Directory Structure

```
lib/
├── main.dart
├── app/
│   ├── bindings/       # GetX bindings
│   ├── controllers/    # GetX controllers
│   ├── data/          # Models and repositories
│   ├── routes/        # Route definitions
│   └── ui/
│       ├── pages/     # Full pages/screens
│       ├── widgets/   # Reusable widgets
│       └── theme/     # Theme definitions
└── generated/         # Code generation output
```

### Widget Guidelines

- **Stateless Preferred**: Use StatelessWidget with GetX
- **Const Constructors**: Always use const where possible
- **Widget Composition**: Small, focused widgets
- **Separation**: Business logic in controllers, not widgets

### Naming Conventions

- **Files**: snake_case.dart
- **Classes**: PascalCase
- **Widgets**: Descriptive names (UserProfileCard not Card1)
- **Private**: Prefix with underscore

### Code Generation

- **Freezed**: For immutable data classes
- **JsonSerializable**: For JSON parsing
- **GetX Snippets**: Use for boilerplate

### Performance

- **Const Widgets**: Use const constructors
- **Keys**: Use keys for list items
- **Lazy Loading**: Use GetX lazy loading
- **Image Optimization**: Cached network images
