# Contributing to get_typed_router

Thank you for your interest in contributing to **get_typed_router**!
All contributions are welcome — bug fixes, new features, tests, and documentation improvements.

---

## Table of Contents

- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Development Workflow](#development-workflow)
- [Code Style & Standards](#code-style--standards)
- [Testing](#testing)
- [Commit Conventions](#commit-conventions)
- [Submitting a Pull Request](#submitting-a-pull-request)
- [Reporting Bugs](#reporting-bugs)
- [Feature Requests](#feature-requests)
- [Code of Conduct](#code-of-conduct)

---

## Getting Started

### 1. Fork and clone the repository

```sh
git clone https://github.com/{your-username}/get_typed_router.git
cd get_typed_router
```

### 2. Install dependencies

```sh
flutter pub get
```

### 3. Run the test suite

```sh
flutter test
```

All tests must pass before submitting a pull request.

### 4. Run the analyzer

```sh
flutter analyze
```

Zero warnings or errors required.

---

## Project Structure

```
get_typed_router/
├── lib/
│   ├── get_typed_router.dart          # Public API — barrel export file
│   └── src/
│       ├── annotations/
│       │   └── app_route.dart         # @AppRoute annotation class
│       ├── generator/
│       │   ├── extractor.dart         # AST extraction logic
│       │   ├── import_resolver.dart   # Type-to-import resolver
│       │   ├── route_config.dart      # Route data model
│       │   └── router_generator.dart  # Code generation output
│       └── utils.dart                 # Shared utilities (file scanning, paths)
├── bin/
│   └── get_typed_router.dart          # CLI entry point
├── test/
│   └── src/
│       ├── utils_test.dart            # Tests for utility functions
│       └── generator/
│           ├── extractor_test.dart        # Tests for AST extraction
│           └── router_generator_test.dart # Tests for code generation
├── example/                           # Full working Flutter app example
├── pubspec.yaml                       # Package metadata & dependencies
├── analysis_options.yaml              # Lint rules
├── README.md                          # Main documentation
├── CHANGELOG.md                       # Version history
├── CONTRIBUTING.md                    # This file
└── LICENSE                            # MIT License
```

---

## Development Workflow

### Understanding the codebase

Before contributing, take time to understand how the package works:

1. **`AppRoute` annotation** (`lib/src/annotations/app_route.dart`)
   The user-facing annotation class with `path`, `binding`, and generic `TArgs`.

2. **Extractor** (`lib/src/generator/extractor.dart`)
   Scans `.dart` files using the Dart `analyzer` to find `@AppRoute` annotations and extract metadata from the AST.

3. **Import Resolver** (`lib/src/generator/import_resolver.dart`)
   Given a type name (e.g., `HomeBinding`), scans the project to find which file defines it and returns the correct package import path.

4. **Route Config** (`lib/src/generator/route_config.dart`)
   A plain data class holding all extracted information for a single route.

5. **Router Generator** (`lib/src/generator/router_generator.dart`)
   Takes a `List<RouteConfig>` and writes the generated file with `RouteContract`, per-page route classes, and the `AppRouter` class.

6. **CLI** (`bin/get_typed_router.dart`)
   The entry point that orchestrates the scan, extract, generate pipeline.

### Running the generator locally

```sh
cd example
dart run get_typed_router
```

This will regenerate `example/lib/routes/app_router.g.dart`.

---

## Code Style & Standards

### General rules

- Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart/style) style guide.
- Run `flutter analyze` before submitting — **zero warnings or errors required**.
- Use `dartfmt` (or your IDE's built-in formatter) before committing.

### Documentation

- All public APIs must have **doc comments** (`///`).
- Include `@param` descriptions and code examples where appropriate.
- Private methods should have brief comments explaining their purpose.

### Naming conventions

| Element | Convention | Example |
|---|---|---|
| Files | `snake_case.dart` | `route_config.dart` |
| Classes | `PascalCase` | `RouteConfig` |
| Functions/methods | `camelCase` | `extractRoutes()` |
| Constants | `camelCase` or `SCREAMING_SNAKE` | `_routeContractClassName` |
| Test files | `*_test.dart` | `extractor_test.dart` |

---

## Testing

### Test structure

Tests are organized under `test/src/` mirroring the `lib/src/` structure:

```
test/
└── src/
    ├── utils_test.dart              → lib/src/utils.dart
    └── generator/
        ├── extractor_test.dart      → lib/src/generator/extractor.dart
        └── router_generator_test.dart → lib/src/generator/router_generator.dart
```

### Requirements

- **All new features** must include corresponding tests.
- **All bug fixes** must include a regression test.
- **Test coverage** should remain high — aim for comprehensive edge cases.

### Running tests

```sh
# Run all tests
flutter test

# Run a specific test file
flutter test test/src/generator/extractor_test.dart

# Run tests with verbose output
flutter test --reporter expanded
```

### Writing tests

- Use descriptive `group()` and `test()` names.
- Follow the **Arrange, Act, Assert** pattern.
- Use `setUpAll()` and `tearDownAll()` for shared setup/cleanup.
- Temporary files should be created in `test/tmp/` and cleaned up in `tearDownAll()`.

Example:

```dart
group('extractRoutes', () {
  test('should return empty list for a file with no @AppRoute', () {
    // Arrange
    final file = _createTempFile('no_annotation', 'class SomePage {}');

    // Act
    final routes = extractRoutes(file);

    // Assert
    expect(routes, isEmpty);
  });
});
```

---

## Commit Conventions

Use the [Conventional Commits](https://www.conventionalcommits.org/) format:

### Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Description |
|---|---|
| `feat` | A new feature |
| `fix` | A bug fix |
| `docs` | Documentation only changes |
| `style` | Code style changes (formatting, no logic change) |
| `refactor` | Code changes that neither fix a bug nor add a feature |
| `perf` | Performance improvements |
| `test` | Adding or updating tests |
| `chore` | Maintenance tasks (CI, dependencies, tooling) |

### Examples

```
feat(generator): add support for custom output path
fix(extractor): handle missing binding type gracefully
test(extractor): add edge case for multiple annotations
docs: update README with navigation API table
chore: bump analyzer dependency to ^8.2.0
```

---

## Submitting a Pull Request

1. **Create a feature branch** from `main`:
   ```sh
   git checkout -b feat/my-feature
   ```

2. **Make your changes** and commit them following the [commit conventions](#commit-conventions).

3. **Ensure quality**:
   ```sh
   flutter analyze   # Zero warnings
   flutter test      # All tests pass
   ```

4. **Push your branch** and open a Pull Request against `main`.

5. **PR description** — Clearly describe:
   - What the change does
   - Why the change is needed
   - How to test it
   - Any breaking changes

6. **Review** — A maintainer will review your PR. Please be responsive to feedback.

### PR Checklist

- [ ] Code follows the project's style guide
- [ ] All existing tests pass
- [ ] New tests cover the change
- [ ] Documentation is updated if applicable
- [ ] Commit messages follow Conventional Commits format
- [ ] `flutter analyze` reports zero issues

---

## Reporting Bugs

Please [open an issue](https://github.com/BogneStanley/get_typed_router/issues/new) with:

- **Title**: A clear, concise description of the problem.
- **Environment**:
  - Flutter SDK version (`flutter --version`)
  - Dart SDK version (`dart --version`)
  - OS and version
  - `get_typed_router` version
- **Steps to reproduce**: Minimal reproduction steps.
- **Expected behavior**: What you expected to happen.
- **Actual behavior**: What actually happened.
- **Code samples**: Minimal code that reproduces the issue.
- **Logs/errors**: Any relevant stack traces or error messages.

---

## Feature Requests

We welcome feature requests! Please [open an issue](https://github.com/BogneStanley/get_typed_router/issues/new) with:

- **Title**: A clear description of the feature.
- **Motivation**: Why this feature would be useful.
- **Proposed solution**: How you envision the feature working.
- **Alternatives considered**: Any alternative solutions you've considered.

---

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/).

**In summary:**

- Be respectful and constructive.
- Focus on what is best for the community.
- Show empathy towards other community members.
- Gracefully accept constructive criticism.

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported to the project maintainers.

---

Thank you for helping make `get_typed_router` better! ❤️🎉
