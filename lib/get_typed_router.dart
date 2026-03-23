import 'package:get_typed_router/src/utils.dart';

import 'src/generator/extractor.dart';
import 'src/generator/router_generator.dart';
import 'src/generator/route_config.dart';

late final String projectName;

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
