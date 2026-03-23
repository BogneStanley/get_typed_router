import 'dart:io';
import 'package:get_typed_router/get_typed_router.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

String toImportPath(String fullPath) {
  final relative = p.relative(fullPath, from: 'lib').replaceAll('\\', '/');
  return 'package:$projectName/$relative';
}

String getProjectName() {
  final file = File('pubspec.yaml');

  if (!file.existsSync()) {
    throw Exception('pubspec.yaml not found');
  }

  final content = file.readAsStringSync();
  final yamlMap = loadYaml(content);

  final name = yamlMap['name'];

  if (name == null || name is! String) {
    throw Exception('Invalid pubspec.yaml: name not found');
  }

  return name;
}

List<File> getAllDartFiles() {
  final libDir = Directory('lib');

  return libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();
}
