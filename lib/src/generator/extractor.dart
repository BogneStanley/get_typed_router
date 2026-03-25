import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:get_typed_router/src/utils.dart';

import 'route_config.dart';
import 'import_resolver.dart';

CompilationUnit _parseFile(File file) {
  final content = file.readAsStringSync();
  final result = parseString(content: content);
  return result.unit;
}

/// Extract routes from a file.
///
/// It searches all the files in the lib directory and returns the routes
/// found in the file.
///
/// Example:
/// ```dart
/// extractRoutes(File('lib/pages/home_page.dart'));
/// ```
/// and it will return a list of RouteConfig objects.
List<RouteConfig> extractRoutes(File file) {
  final unit = _parseFile(file);
  final routes = <RouteConfig>[];

  for (final clazz in unit.declarations.whereType<ClassDeclaration>()) {
    final annotations = clazz.metadata.where((a) => a.name.name == 'AppRoute');

    if (annotations.isEmpty) continue;

    final annotation = annotations.first;

    final pageName = clazz.name.lexeme;
    final routeName = _extractRouteName(annotation, pageName);
    final argsType = _extractGenericType(annotation);
    final bindingType = _extractBinding(annotation);

    final pageImport = toImportPath(file.path);
    final bindingImport = bindingType != null
        ? findImportForType(bindingType)
        : null;

    routes.add(
      RouteConfig(
        pageName: pageName,
        routeName: routeName,
        argsType: argsType,
        bindingType: bindingType,
        pageImport: pageImport,
        bindingImport: bindingImport,
      ),
    );
  }

  return routes;
}

/// Extract route name from an annotation.
///
/// It searches for the 'path' argument in the annotation and returns its value.
/// If the 'path' argument is not found, it returns the lowercase version of the fallback string.
///
/// Example:
/// ```dart
/// _extractRouteName(annotation, 'HomePage');
/// ```
/// and it will return '/home' if the annotation has path: '/home'.
String _extractRouteName(Annotation annotation, String fallback) {
  final args = annotation.arguments;

  if (args == null) return '/${fallback.toLowerCase()}';

  for (final arg in args.arguments) {
    if (arg is NamedExpression && arg.name.label.name == 'path') {
      final routeName = arg.expression.toSource().replaceAll("'", "");
      return routeName.startsWith('/') ? routeName : '/$routeName';
    }
  }

  return '/${fallback.toLowerCase()}';
}

String? _extractGenericType(Annotation annotation) {
  final typeArgs = annotation.typeArguments;
  if (typeArgs == null || typeArgs.arguments.isEmpty) return null;

  return typeArgs.arguments.first.toSource();
}

String? _extractBinding(Annotation annotation) {
  final args = annotation.arguments;
  if (args == null) return null;

  for (final arg in args.arguments) {
    if (arg is NamedExpression && arg.name.label.name == 'binding') {
      return arg.expression.toSource();
    }
  }

  return null;
}
