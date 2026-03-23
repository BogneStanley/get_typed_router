import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:get_typed_router/src/utils.dart';

CompilationUnit _parseFile(File file) {
  final content = file.readAsStringSync();
  final result = parseString(content: content);
  return result.unit;
}

/// Find import for a type.
/// 
/// It searches all the files in the lib directory and returns the import path
/// of the file that contains the type.
/// 
/// Example:
/// we have a file lib/pages/home_page.dart and we want to find the import path of HomePage
/// ```dart
/// findImportForType('HomePage');
/// ```
/// and it will return 'package:my_test_project/pages/home_page.dart'
String? findImportForType(String typeName) {
  final files = getAllDartFiles();

  for (final file in files) {
    final unit = _parseFile(file);

    final found = unit.declarations
        .whereType<ClassDeclaration>()
        .any((c) => c.name.lexeme == typeName);

    if (found) {
      return toImportPath(file.path);
    }
  }

  return null;
}