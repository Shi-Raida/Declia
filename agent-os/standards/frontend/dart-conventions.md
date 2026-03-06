## Dart language conventions

### Linting Rules

- **Analysis Options**: Use flutter_lints package
- **analysis_options.yaml**:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_final_fields: true
    use_key_in_widget_constructors: true
    avoid_print: true
    prefer_single_quotes: true
```

### Naming Conventions

- **Classes/Types**: PascalCase
- **Variables/Functions**: camelCase
- **Constants**: lowerCamelCase (not SCREAMING_CAPS)
- **Files**: snake_case.dart
- **Packages**: lowercase_with_underscores

### Null Safety

- **Required**: Dart 2.12+ with null safety
- **Non-nullable by Default**: Use ? for nullable
- **Late Initialization**: Use late sparingly
- **Null-aware Operators**: Use ??, ?., ??=

### Formatting

- **Tool**: dart format
- **Line Length**: 80 characters (Dart default)
- **Trailing Commas**: Use for better formatting
- **Import Order**: Dart, package, relative

### Type Safety

- **Avoid Dynamic**: Use specific types
- **Type Inference**: Let Dart infer when obvious
- **Generics**: Use type parameters
- **Type Annotations**: Required for public APIs
