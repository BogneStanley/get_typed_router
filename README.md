# get_typed_router

Type-safe, annotation-based route generation for [GetX](https://pub.dev/packages/get).

[Pub Version](https://pub.dev/packages/get_typed_router)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Dart](https://img.shields.io/badge/dart-%3E%3D3.8.1-blue.svg)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/flutter-%3E%3D1.17.0-blue.svg)](https://flutter.dev)

---

Stop writing routes manually. Annotate your pages with `@AppRoute`, run the generator, and get a fully typed `AppRouter` with **type-safe navigation** and **strongly-typed argument passing**.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
  - [1. Annotate your pages](#1-annotate-your-pages)
  - [2. Run the code generator](#2-run-the-code-generator)
  - [3. Configure GetMaterialApp](#3-configure-getmaterialapp)
- [Navigation API](#navigation-api)
  - [Full Navigation Reference](#full-navigation-reference)
- [Reading Arguments](#reading-arguments)
  - [Error handling](#error-handling)
- [The @AppRoute Annotation](#the-approute-annotation)
  - [Parameters](#parameters)
  - [Supported page types](#supported-page-types)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

---

## Features

| Feature | Description |
|---|---|
| **Annotation-based** | Declare routes directly on your page classes with `@AppRoute` |
| **Type-safe arguments** | Each generated `Route` class carries its own strongly-typed `args` |
| **CLI code generator** | Run `dart run get_typed_router` — no build_runner needed |
| **GetX bindings** | Associate a `Binding` class directly in the annotation |
| **Full navigation API** | `to`, `offNamed`, `offAllNamed`, `offAndToNamed`, `getArgs<T>()` |
| **Static route constants** | Use `MyPageRoute.route` for type-safe routing with basic GetX features |
| **Zero boilerplate** | No manual `GetPage` lists, no `as` casting, no stringly-typed paths |

---

## Installation

Add `get_typed_router` to your `pubspec.yaml`:

```yaml
dependencies:
  get: ^4.6.6
  get_typed_router: ^0.0.1
```

Then run:

```sh
flutter pub get
```

---

## Quick Start

### 1. Annotate your pages

#### With typed arguments and a binding

```dart
import 'package:get/get.dart';
import 'package:get_typed_router/get_typed_router.dart';

// 1. Define your arguments class
class HomeArgs {
  final String title;
  HomeArgs({required this.title});
}

// 2. Annotate your page
@AppRoute<HomeArgs>(
  path: '/home',
  binding: HomeBinding,
)
class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.title)),
      body: const Center(child: Text('Welcome!')),
    );
  }
}
```

#### Without arguments (simple page)

```dart
@AppRoute(
  path: '/splash',
)
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Loading...')),
    );
  }
}
```

### 2. Run the code generator

From the **root of your Flutter project**:

```sh
dart run get_typed_router
```

This scans all `.dart` files in your `lib/` directory and generates `lib/routes/app_router.g.dart`.

> **Tip:** Add a script in your IDE or `Makefile` for convenience:
> ```makefile
> routes:
> 	dart run get_typed_router
> ```

### 3. Configure `GetMaterialApp`

```dart
import 'routes/app_router.g.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: HomePageRoute.route, // type-safe constant
      getPages: AppRouter.pages,         // auto-generated pages list
    );
  }
}
```

---

## Navigation API

All navigation methods are available through the generated `AppRouter` class:

### Navigate to a route

```dart
// Push a new route onto the stack
AppRouter.to(HomePageRoute(args: HomeArgs(title: 'Hello')));
```

### Replace current route

```dart
// Replace the current route (like Navigator.pushReplacement)
AppRouter.offNamed(HomePageRoute(args: HomeArgs(title: 'Hello')));
```

### Clear stack and navigate

```dart
// Remove all routes and navigate (like Navigator.pushAndRemoveAll)
AppRouter.offAllNamed(HomePageRoute(args: HomeArgs(title: 'Hello')));
```

### Replace and push

```dart
// Remove current route and push new one
AppRouter.offAndToNamed(HomePageRoute(args: HomeArgs(title: 'Hello')));
```

### Navigate without arguments

```dart
// For pages without typed args
AppRouter.to(SplashPageRoute());
```

### Full Navigation Reference

| Method | Equivalent GetX | Description |
|---|---|---|
| `AppRouter.to(route)` | `Get.toNamed(path, arguments:)` | Push a new route |
| `AppRouter.offNamed(route)` | `Get.offNamed(path, arguments:)` | Replace current route |
| `AppRouter.offAllNamed(route)` | `Get.offAllNamed(path, arguments:)` | Clear stack & navigate |
| `AppRouter.offAndToNamed(route)` | `Get.offAndToNamed(path, arguments:)` | Pop current & push new |

---

## Reading Arguments

Retrieve strongly-typed arguments in your page or controller:

```dart
final args = AppRouter.getArgs<HomeArgs>();
print(args.title); // fully typed, auto-completed
```

You can also fall back to the standard GetX approach:

```dart
final args = Get.arguments as HomeArgs;
```

### Error handling

`getArgs<T>()` throws a descriptive `Exception` when:

- **No arguments are found** — `Exception('No arguments found for route')`
- **Wrong type** — `Exception('Invalid argument type. Expected HomeArgs but got String')`

---

## The `@AppRoute` Annotation

```dart
@AppRoute<TArgs>(
  path: '/my-path',     // Required: the route path
  binding: MyBinding,   // Optional: GetX Binding class
)
```

### Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `path` | `String` | Yes | The route path. Must start with `/`. Must be unique across the app. |
| `binding` | `Type?` | No | A `Bindings` subclass to associate with this page. |
| `TArgs` | Generic | No | The type of arguments this route expects. Omit for no arguments. |

### Supported page types

`@AppRoute` works with any widget class:

| Widget Type | Supported |
|---|---|
| `StatelessWidget` | Yes |
| `StatefulWidget` | Yes |
| `GetView<T>` | Yes |
| `GetWidget<T>` | Yes |

---

## Examples

### Complete example with multiple pages

```dart
// lib/pages/home_page.dart
import 'package:get_typed_router/get_typed_router.dart';

class HomeArgs {
  final String title;
  HomeArgs({required this.title});
}

@AppRoute<HomeArgs>(
  path: '/home',
  binding: HomeBinding,
)
class MyHomePage extends GetView<HomeController> {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.title)),
      body: ElevatedButton(
        onPressed: () {
          // Type-safe navigation with arguments
          AppRouter.to(SecondPageRoute(args: 'Hello from Home!'));
        },
        child: const Text('Go to Second Page'),
      ),
    );
  }
}
```

```dart
// lib/pages/second_page.dart
import 'package:get_typed_router/get_typed_router.dart';

@AppRoute<String>(
  path: '/second',
)
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Type-safe argument retrieval
    final message = AppRouter.getArgs<String>();

    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Center(child: Text('Received: $message')),
    );
  }
}
```

A full working example is available in the [`example/`](example/) folder.

---

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to submit pull requests, report bugs, and suggest features.

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
