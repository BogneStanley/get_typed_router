import 'package:get/get.dart';
import 'package:example/home/home_page.dart';
import 'package:example/home/home_controller.dart';
import 'package:example/main.dart';

sealed class RouteContract {
  String get path;
  dynamic get args;
  Bindings? get binding;
}


class MyHomePageRoute extends RouteContract {
  @override
  final String path = '/home';

  static final String route = '/home';

  @override
  final HomeArgs args;

  @override
  final Bindings? binding = HomeBinding();

  MyHomePageRoute({required this.args});
}

class SecondPageRoute extends RouteContract {
  @override
  final String path = '/second';

  static final String route = '/second';

  @override
  final String args;

  @override
  final Bindings? binding = null;

  SecondPageRoute({required this.args});
}


class AppRouter {
  static final pages = <GetPage>[
    GetPage(
      name: '/home',
      page: () => MyHomePage(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: '/second',
      page: () => SecondPage(),
      binding: null,
    ),

  ];
  static Future<T?> to<T>(RouteContract route) async {
    return await Get.toNamed(
      route.path,
      arguments: route.args,
    );
  }

  static Future<T?> offNamed<T>(RouteContract route) async {
    return await Get.offNamed(
      route.path,
      arguments: route.args,
    );
  }

  static Future<T?> offAllNamed<T>(RouteContract route) async {
    return await Get.offAllNamed(
      route.path,
      arguments: route.args,
    );
  }

  static Future<T?> offAndToNamed<T>(RouteContract route) async {
    return await Get.offAndToNamed(
      route.path,
      arguments: route.args,
    );
  }

  static T getArgs<T>() {
    final args = Get.arguments;
    if (args == null) {
      throw Exception('No arguments found for route');
    }
    if (args is! T) {
      throw Exception(
        'Invalid argument type. Expected $T but got ${args.runtimeType}',
      );
    }

    return args;
  }

}

