# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

_No unreleased changes._

---

## [0.0.1] - 2026-03-24

### Added

- **`@AppRoute<TArgs>` annotation** — Declare routes directly on page classes with typed arguments and optional binding support.
- **CLI code generator** — Run `dart run get_typed_router` to scan `lib/` and generate `lib/routes/app_router.g.dart`. No `build_runner` required.
- **`RouteContract` sealed class** — Auto-generated base class for all route contracts, enforcing `path`, `args`, and `binding` members.
- **Typed `XxxRoute` classes** — One class per annotated page, carrying strongly-typed `args`, a static `route` constant, and an optional `Binding` instance.
- **`AppRouter` navigation hub** — Generated class with:
  - `AppRouter.pages` — Auto-generated `List<GetPage>` for `GetMaterialApp.getPages`.
  - `AppRouter.to(route)` — Push a new route with arguments.
  - `AppRouter.offNamed(route)` — Replace the current route.
  - `AppRouter.offAllNamed(route)` — Clear the navigation stack and navigate.
  - `AppRouter.offAndToNamed(route)` — Pop current route and push a new one.
  - `AppRouter.getArgs<T>()` — Retrieve strongly-typed arguments with runtime validation.
- **Full test suite** — Unit tests for `extractor`, `router_generator`, and `utils`.
- **Working example app** — Complete Flutter example in `example/` demonstrating typed navigation with multiple pages, arguments, and bindings.
- **Documentation** — README, CONTRIBUTING guide, and LICENSE.

---

[Unreleased]: https://github.com/BogneStanley/get_typed_router/compare/v0.0.1...HEAD
[0.0.1]: https://github.com/BogneStanley/get_typed_router/releases/tag/v0.0.1
