export PATH := "/home/rgodet/tools/flutter/bin:" + env_var('PATH')

# justfile for timux Flutter/Dart project
# Run `just --list` to see all available recipes

# Show available recipes
default:
    @just --list

# Install dependencies
get:
    flutter pub get

# Load .env as --dart-define flags (strips comments and blank lines)
_dart_defines := `[ -f .env ] && grep -v '^\s*#' .env | grep -v '^\s*$' | sed 's/^/--dart-define=/' | tr '\n' ' ' || true`

# Run app in debug mode
run *args:
    flutter run {{_dart_defines}} {{args}}

# Run app in release mode
run-release:
    flutter run --release {{_dart_defines}}

# List available devices
devices:
    flutter devices

# Build Android APK
build-apk:
    flutter build apk

# Build Android App Bundle
build-appbundle:
    flutter build appbundle

# Build iOS app
build-ios:
    flutter build ios

# Build web app
build-web:
    flutter build web

# Run all tests
test *args:
    flutter test {{args}}

# Run unit tests only
test-unit:
    flutter test test/unit/

# Run widget tests only
test-widget:
    flutter test test/widget/

# Run tests with coverage
test-coverage:
    flutter test --coverage

# Generate HTML coverage report
coverage-report: test-coverage
    genhtml coverage/lcov.info -o coverage/html
    @echo "Coverage report generated at coverage/html/index.html"

# Run static analysis
analyze:
    flutter analyze

# Format Dart code
format:
    dart format lib/ test/

# Check formatting (CI-friendly)
format-check:
    dart format --output=none --set-exit-if-changed lib/ test/

# Combined analysis + format check
lint: analyze format-check

# Run build_runner for code generation
gen:
    dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
gen-watch:
    dart run build_runner watch --delete-conflicting-outputs

# Clean build artifacts
clean:
    flutter clean

# Upgrade dependencies
upgrade:
    flutter pub upgrade

# Check for outdated packages
outdated:
    flutter pub outdated

# Check Flutter installation
doctor:
    flutter doctor -v

# Full CI pipeline
ci: get gen analyze format-check test

# Quick check (analyze + format)
check: analyze format-check

# Pre-commit hook
pre-commit: analyze format test
