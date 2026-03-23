import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_typed_router/get_typed_router.dart' as globals;
import 'package:get_typed_router/src/utils.dart';
import 'package:path/path.dart' as p;

void main() {
  setUpAll(() {
    try {
      globals.projectName = 'my_test_project';
    } catch (_) {}
  });


  group('toImportPath', () {
    test('should convert path correctly on Windows/Unix style', () {
      final path = p.join('lib', 'pages', 'home.dart');
      final expected = 'package:${globals.projectName}/pages/home.dart';
      
      expect(toImportPath(path), expected);
    });

    test('should handle deep paths', () {
      final path = p.join('lib', 'src', 'sub', 'utils.dart');
      final expected = 'package:${globals.projectName}/src/sub/utils.dart';

      expect(toImportPath(path), expected);
    });
  });

  group('getProjectName', () {
    test('should throw Exception when pubspec.yaml is missing', () {
      expect(getProjectName(), 'get_typed_router');
    });

    test('should extract name from pubspec.yaml', () {
      final pubspec = File('pubspec.yaml');
      final projectName = getProjectName();

      expect(projectName, isNotEmpty);
      expect(pubspec.readAsStringSync(), contains('name: $projectName'));
    });
  });
}
