import 'package:example/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_typed_router/get_typed_router.dart';
import 'routes/app_router.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Get Typed Router Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: MyHomePageRoute.route,
      getPages: AppRouter.pages,
    );
  }
}

@AppRoute<String>(path: '/second')
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    final message = AppRouter.getArgs<String>();

    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Received message: $message'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => AppRouter.offAllNamed(
                MyHomePageRoute(
                  args: HomeArgs(title: 'Message from Second Page'),
                ),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
