class RouteConfig {
  final String pageName;
  final String routeName;
  final String? argsType;
  final String? bindingType;
  final String pageImport;
  final String? bindingImport;

  RouteConfig({
    required this.pageName,
    required this.routeName,
    required this.pageImport,
    this.argsType,
    this.bindingType,
    this.bindingImport,
  });
}
