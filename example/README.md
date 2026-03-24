# get_typed_router — Example App

A complete working Flutter application demonstrating how to use `get_typed_router` for type-safe GetX routing.

---

## Overview

This example shows:

- How to annotate pages with `@AppRoute`
- How to pass typed arguments between pages
- How to use GetX bindings with the router
- How to configure `GetMaterialApp` with the generated router
- Type-safe navigation using `AppRouter.to()`, `AppRouter.offAllNamed()`
- Type-safe argument retrieval using `AppRouter.getArgs<T>()`

---

## Project Structure

```
example/
├── lib/
│   ├── main.dart                 # App entry point + SecondPage
│   ├── home/
│   │   ├── home_page.dart        # HomePage with @AppRoute<HomeArgs>
│   │   └── home_controller.dart  # HomeController + HomeBinding
│   └── routes/
│       └── app_router.g.dart     # Generated router (do not edit manually)
└── pubspec.yaml
```

---

## Pages

### `HomePage` — With typed arguments and binding

```dart
class HomeArgs {
  final String title;
  HomeArgs({required this.title});
}

@AppRoute<HomeArgs>(
  path: '/home',
  binding: HomeBinding,
)
class MyHomePage extends GetView<HomeController> { ... }
```

- **Arguments:** `HomeArgs` with a required `title` field.
- **Binding:** `HomeBinding` injects `HomeController` with the received title.
- **Navigation:** Navigates to `SecondPage` with `AppRouter.to(SecondPageRoute(args: 'Message from Home'))`.

### `SecondPage` — With simple `String` argument

```dart
@AppRoute<String>(
  path: '/second',
)
class SecondPage extends StatelessWidget { ... }
```

- **Arguments:** A simple `String`.
- **Retrieval:** Uses `AppRouter.getArgs<String>()` for type-safe access.
- **Navigation:** Returns to home with `AppRouter.offAllNamed(MyHomePageRoute(args: HomeArgs(title: 'Message from Second Page')))`.

---

## Running the Example

### 1. Install dependencies

```sh
cd example
flutter pub get
```

### 2. Generate the router

From the `example/` directory:

```sh
dart run get_typed_router
```

This generates or updates `lib/routes/app_router.g.dart`.

### 3. Run the app

```sh
flutter run
```

---

## Regenerating Routes

Whenever you add, remove, or modify an `@AppRoute` annotation, regenerate the router:

```sh
dart run get_typed_router
```

The generated file (`app_router.g.dart`) should **not** be edited manually — any changes will be overwritten on the next generation.

---

## Key Takeaways

| Concept | Example in this app |
|---|---|
| Typed arguments | `HomeArgs` class with `@AppRoute<HomeArgs>` |
| Simple type args | `@AppRoute<String>` on `SecondPage` |
| Bindings support | `HomeBinding` injecting `HomeController` |
| Type-safe navigation | `AppRouter.to(SecondPageRoute(args: '...'))` |
| Type-safe retrieval | `AppRouter.getArgs<String>()` |
| Initial route | `initialRoute: MyHomePageRoute.route` |
| Pages list | `getPages: AppRouter.pages` |
