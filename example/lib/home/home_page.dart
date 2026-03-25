import 'package:example/home/home_controller.dart';
import 'package:example/routes/app_router.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_typed_router/get_typed_router.dart';

class HomeArgs {
  final String title;
  HomeArgs({required this.title});
}

@AppRoute<HomeArgs>(path: '/home', binding: HomeBinding)
class MyHomePage extends GetView<HomeController> {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(controller.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Get Typed Router!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                AppRouter.to(SecondPageRoute(args: 'Message from Home'));
              },
              child: const Text('Go to Second Page'),
            ),
          ],
        ),
      ),
    );
  }
}
