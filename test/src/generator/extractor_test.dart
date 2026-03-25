import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_typed_router/get_typed_router.dart' as globals;
import 'package:get_typed_router/src/generator/extractor.dart';

// Creates a temp dart file and returns it
File _createTempFile(String name, String content) {
  final file = File('test/tmp/$name.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(content);
  return file;
}

void main() {
  setUpAll(() {
    try {
      globals.projectName = 'get_typed_router';
    } catch (_) {}
  });

  tearDownAll(() {
    final tmp = Directory('test/tmp');
    if (tmp.existsSync()) tmp.deleteSync(recursive: true);
  });

  group('extractRoutes', () {
    test('should return empty list for a file with no @AppRoute', () {
      final file = _createTempFile('no_annotation', '''
class SomePage {}
''');

      final routes = extractRoutes(file);
      expect(routes, isEmpty);
    });

    test('should extract route with path', () {
      final file = _createTempFile('with_annotation', '''
import 'package:flutter/material.dart';
import 'package:get_typed_router/src/annotations/app_route.dart';

@AppRoute(path: '/home')
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}
''');

      final routes = extractRoutes(file);

      expect(routes.length, 1);
      expect(routes.first.pageName, 'HomePage');
      expect(routes.first.routeName, '/home');
    });

    test('should extract argsType from generic type argument', () {
      final file = _createTempFile('with_args', '''
import 'package:flutter/material.dart';
import 'package:get_typed_router/src/annotations/app_route.dart';

class HomeArgs {}

@AppRoute<HomeArgs>(path: '/home')
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}
''');

      final routes = extractRoutes(file);

      expect(routes.first.argsType, 'HomeArgs');
    });

    test('should extract binding type', () {
      final file = _createTempFile('with_binding', '''
import 'package:flutter/material.dart';
import 'package:get_typed_router/src/annotations/app_route.dart';

class HomeBinding {}
class HomeArgs {}

@AppRoute<HomeArgs>(path: '/home', binding: HomeBinding)
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}
''');

      final routes = extractRoutes(file);

      expect(routes.first.bindingType, 'HomeBinding');
    });

    test('should return null argsType when no generic type is provided', () {
      final file = _createTempFile('no_args', '''
import 'package:flutter/material.dart';
import 'package:get_typed_router/src/annotations/app_route.dart';

@AppRoute(path: '/splash')
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}
''');

      final routes = extractRoutes(file);

      expect(routes.first.argsType, isNull);
    });

    test('should extract multiple routes from a single file', () {
      final file = _createTempFile('multi_routes', '''
import 'package:flutter/material.dart';
import 'package:get_typed_router/src/annotations/app_route.dart';

@AppRoute(path: '/home')
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}

@AppRoute(path: '/profile')
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}
''');

      final routes = extractRoutes(file);

      expect(routes.length, 2);
      expect(
        routes.map((r) => r.routeName),
        containsAll(['/home', '/profile']),
      );
    });

    test('should include pageImport derived from the file path', () {
      final file = _createTempFile('import_check', '''
import 'package:get_typed_router/src/annotations/app_route.dart';
import 'package:flutter/material.dart';

@AppRoute(path: '/login')
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}
''');

      final routes = extractRoutes(file);

      expect(routes.first.pageImport, contains('package:get_typed_router'));
      expect(routes.first.pageImport, contains('import_check.dart'));
    });
  });
}
