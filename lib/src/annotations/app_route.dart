/// AppRoute annotation for generating GetX routes.
/// 
/// This annotation should be placed above a page class to provide metadata
/// for code generation.
/// 
/// Example usage:
/// ```dart
/// @AppRoute<HomeArgs>(
///   path: '/home',
///   binding: HomeBinding,
/// )
/// class HomePage extends StatelessWidget { ... }
/// ```
class AppRoute<TArgs> {
  /// The route path, used in Get.toNamed('/path') and GetPage.name.
  /// Must start with a '/' and be unique across the app.
  final String path;

  /// Optional GetX binding associated with this page.
  /// If provided, it will be generated in GetPage(binding: ...).
  final Type? binding;

  /// Generic type representing the arguments this route expects.
  /// Example: `HomeArgs`, `ProfileArgs`, or `void` if no arguments.
  /// This allows code generation to create strongly typed `Route` classes.
  ///
  /// Usage in code generation:
  /// ```dart
  /// AppRouter.to(HomePageRoute(arg: HomeArgs(...)));
  /// ```
  const AppRoute({
    required this.path,
    this.binding,
  });
}