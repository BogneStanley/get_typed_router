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
      initialRoute: '/home',
      getPages: AppRouter.pages,
    );
  }
}

class HomeArgs {
  final String title;
  HomeArgs({required this.title});
}

@AppRoute<HomeArgs>(
  path: '/home',
)
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final args = Get.arguments as HomeArgs?;
    final title = args?.title ?? 'Home Page';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
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

@AppRoute<String>(
  path: '/second',
)
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    final message = AppRouter.getArgs<String>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Received message: $message'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
