import 'package:example/home/home_page.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as HomeArgs?;
    Get.lazyPut(() => HomeController(title: args?.title ?? 'Default Title'));
  }
}

class HomeController extends GetxController {
  final String title;

  HomeController({required this.title});
}