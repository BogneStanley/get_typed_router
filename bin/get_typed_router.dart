import 'package:get_typed_router/get_typed_router.dart';
import 'package:get_typed_router/src/utils.dart';

import 'package:get_typed_router/src/generator/extractor.dart';
import 'package:get_typed_router/src/generator/router_generator.dart';
import 'package:get_typed_router/src/generator/route_config.dart';

void main() {
  projectName = getProjectName();

  final files = getAllDartFiles();

  final routes = <RouteConfig>[];

  for (final file in files) {
    routes.addAll(extractRoutes(file));
  }

  generateRouterFile(routes);

  print('✅ Router generated in lib/routes/app_router.g.dart');
}
