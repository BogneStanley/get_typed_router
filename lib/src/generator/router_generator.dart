import 'dart:io';
import 'route_config.dart';

const _routeContractClassName = 'RouteContract';

void generateRouterFile(List<RouteConfig> routes) {
  final buffer = StringBuffer();

  final imports = <String>{
    "import 'package:get/get.dart';",
  };

  for (final r in routes) {
    imports.add("import '${r.pageImport}';");

    if (r.bindingImport != null) {
      imports.add("import '${r.bindingImport}';");
    }
  }

  buffer.writeln(imports.join('\n'));
  buffer.writeln();

  /// base route
  buffer.writeln(generateBaseRoute());
  buffer.writeln();

  /// route classes
  for (final r in routes) {
    buffer.writeln(_generateRouteClass(r));
  }

  buffer.writeln();

  /// router
  buffer.writeln(_generateAppRouter(routes));

  final file = File('lib/routes/app_router.g.dart');
  file.createSync(recursive: true);
  file.writeAsStringSync(buffer.toString());
}

String _generateRouteClass(RouteConfig r) {
  final routeClassName = "${r.pageName}Route";

  final argsLine = r.argsType != null ? 'final ${r.argsType} args;' : 'final dynamic args = null;';
  final argsInit = r.argsType != null ? '{required this.args}' : '';

  final bindingInit =
      r.bindingType != null ? '${r.bindingType}()' : 'null';

  return '''
class $routeClassName extends $_routeContractClassName {
  @override
  final String path = '${r.routeName}';

  static final String route = '${r.routeName}';

  @override
  $argsLine

  @override
  final Bindings? binding = $bindingInit;

  $routeClassName($argsInit);
}
''';
}

String _generateGetPage(RouteConfig r) {
  final bindingInit =
      r.bindingType != null ? '${r.bindingType}()' : 'null';

  return '''
    GetPage(
      name: '${r.routeName}',
      page: () => ${r.pageName}(),
      binding: $bindingInit,
    ),
''';
}

String generateBaseRoute() {
  return '''
sealed class $_routeContractClassName {
  String get path;
  dynamic get args;
  Bindings? get binding;
}
''';
}

String _generateAppRouter(List<RouteConfig> routes) {
  final buffer = StringBuffer();

  buffer.writeln('class AppRouter {');

  /// pages
  buffer.writeln('  static final pages = <GetPage>[');

  for (final r in routes) {
    buffer.writeln(_generateGetPage(r));
  }

  buffer.writeln('  ];');

  /// navigation
  buffer.writeln('''
  static Future<T?> to<T>($_routeContractClassName route) async {
    return await Get.toNamed(
      route.path,
      arguments: route.args,
    );
  }

  static Future<T?> offNamed<T>($_routeContractClassName route) async {
    return await Get.offNamed(
      route.path,
      arguments: route.args,
    );
  }

  static Future<T?> offAllNamed<T>($_routeContractClassName route) async {
    return await Get.offAllNamed(
      route.path,
      arguments: route.args,
    );
  }

  static Future<T?> offAndToNamed<T>($_routeContractClassName route) async {
    return await Get.offAndToNamed(
      route.path,
      arguments: route.args,
    );
  }
''');

  /// args
  buffer.writeln('''
  static T getArgs<T>() {
    final args = Get.arguments;
    if (args == null) {
      throw Exception('No arguments found for route');
    }
    if (args is! T) {
      throw Exception(
        'Invalid argument type. Expected \$T but got \${args.runtimeType}',
      );
    }

    return args;
  }
''');

  buffer.writeln('}');
  return buffer.toString();
}