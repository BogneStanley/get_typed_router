import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_typed_router/src/generator/route_config.dart';
import 'package:get_typed_router/src/generator/router_generator.dart';

RouteConfig _config({
  String pageName = 'HomePage',
  String routeName = '/home',
  String pageImport = 'package:my_app/pages/home.dart',
  String? argsType,
  String? bindingType,
  String? bindingImport,
}) =>
    RouteConfig(
      pageName: pageName,
      routeName: routeName,
      pageImport: pageImport,
      argsType: argsType,
      bindingType: bindingType,
      bindingImport: bindingImport,
    );

// Reads the generated file after calling generateRouterFile
String _readGeneratedFile() {
  return File('lib/routes/app_router.g.dart').readAsStringSync();
}

void main() {
  tearDownAll(() {
    final tmp = Directory('lib/routes');
    if (tmp.existsSync()) tmp.deleteSync(recursive: true);
  });

  group('generateBaseRoute', () {
    test('should generate a sealed RouteContract class', () {
      final result = generateBaseRoute();

      expect(result, contains('sealed class RouteContract'));
      expect(result, contains('String get path;'));
      expect(result, contains('dynamic get args;'));
      expect(result, contains('Bindings? get binding;'));
    });
  });

  group('generateRouterFile - imports', () {
    test('should always include get/get.dart import', () {
      generateRouterFile([]);
      final content = _readGeneratedFile();

      expect(content, contains("import 'package:get/get.dart'"));
    });

    test('should include page import', () {
      generateRouterFile([
        _config(pageImport: 'package:my_app/pages/home.dart'),
      ]);

      final content = _readGeneratedFile();
      expect(content, contains("import 'package:my_app/pages/home.dart'"));
    });

    test('should include binding import when provided', () {
      generateRouterFile([
        _config(
          bindingType: 'HomeBinding',
          bindingImport: 'package:my_app/controllers/home_controller.dart',
        ),
      ]);

      final content = _readGeneratedFile();
      expect(
        content,
        contains("import 'package:my_app/controllers/home_controller.dart'"),
      );
    });

    test('should not duplicate imports for same page/binding', () {
      final config = _config(
        pageImport: 'package:my_app/pages/home.dart',
        bindingImport: 'package:my_app/pages/home.dart', // same import
      );
      generateRouterFile([config]);

      final content = _readGeneratedFile();
      final count = "import 'package:my_app/pages/home.dart'"
          .allMatches(content)
          .length;

      expect(count, 1);
    });
  });

  group('generateRouterFile - base RouteContract', () {
    test('should always generate sealed RouteContract class', () {
      generateRouterFile([]);
      final content = _readGeneratedFile();

      expect(content, contains('sealed class RouteContract'));
      expect(content, contains('String get path;'));
      expect(content, contains('dynamic get args;'));
      expect(content, contains('Bindings? get binding;'));
    });
  });

  group('generateRouterFile - route class', () {
    test('class name add Route to Page', () {
      generateRouterFile([_config(pageName: 'TestPage', routeName: '/test')]);
      final content = _readGeneratedFile();

      expect(content, contains('class TestPageRoute extends RouteContract'));
    });

    test('should include route path', () {
      generateRouterFile([_config(routeName: '/dashboard')]);
      final content = _readGeneratedFile();

      expect(content, contains("final String path = '/dashboard'"));
    });

    test('should use provided argsType', () {
      generateRouterFile([
        _config(argsType: 'DashboardArgs'),
      ]);
      final content = _readGeneratedFile();

      expect(content, contains('final DashboardArgs args'));
    });

    test('should fallback to dynamic when argsType is null', () {
      generateRouterFile([_config(argsType: null)]);
      final content = _readGeneratedFile();

      expect(content, contains('final dynamic args'));
    });

    test('should include binding initializer when bindingType is set', () {
      generateRouterFile([_config(bindingType: 'HomeBinding')]);
      final content = _readGeneratedFile();

      expect(content, contains('final Bindings? binding = HomeBinding()'));
    });

    test('should use null for binding when bindingType is null', () {
      generateRouterFile([_config(bindingType: null)]);
      final content = _readGeneratedFile();

      expect(content, contains('final Bindings? binding = null'));
    });
  });

  group('generateRouterFile – AppRouter class', () {
    test('should contain AppRouter class', () {
      generateRouterFile([]);
      final content = _readGeneratedFile();

      expect(content, contains('class AppRouter'));
    });

    test('should contain pages list', () {
      generateRouterFile([_config(routeName: '/home', pageName: 'HomePage')]);
      final content = _readGeneratedFile();

      expect(content, contains("static final pages = <GetPage>"));
      expect(content, contains("name: '/home'"));
      expect(content, contains('page: () => HomePage()'));
    });

    test('should contain to() navigation method', () {
      generateRouterFile([]);
      final content = _readGeneratedFile();

      expect(content, contains('static Future<T?> to<T>(RouteContract route)'));
      expect(content, contains('Get.toNamed'));
    });

    test('should contain offNamed() navigation method', () {
      generateRouterFile([]);
      final content = _readGeneratedFile();

      expect(
        content,
        contains('static Future<T?> offNamed<T>(RouteContract route)'),
      );
    });

    test('should contain offAllNamed() navigation method', () {
      generateRouterFile([]);
      final content = _readGeneratedFile();

      expect(
        content,
        contains('static Future<T?> offAllNamed<T>(RouteContract route)'),
      );
    });

    test('should contain offAndToNamed() navigation method', () {
      generateRouterFile([]);
      final content = _readGeneratedFile();

      expect(
        content,
        contains('static Future<T?> offAndToNamed<T>(RouteContract route)'),
      );
    });

    test('should contain getArgs() typed getter', () {
      generateRouterFile([]);
      final content = _readGeneratedFile();

      expect(content, contains('static T getArgs<T>()'));
      expect(content, contains("throw Exception('No arguments found for route')"));
      expect(content, contains('Invalid argument type'));
    });

    test('should handle multiple routes', () {
      generateRouterFile([
        _config(pageName: 'Home', routeName: '/home'),
        _config(pageName: 'Profile', routeName: '/profile'),
      ]);
      final content = _readGeneratedFile();

      expect(content, contains("name: '/home'"));
      expect(content, contains("name: '/profile'"));
      expect(content, contains('class HomeRoute extends RouteContract'));
      expect(content, contains('class ProfileRoute extends RouteContract'));
    });
  });
}
