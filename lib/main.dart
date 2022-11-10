import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample/view/navigation/main_route_information_parser.dart';
import 'package:sample/view/navigation/main_router_delegate.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(DevicePreview(
    enabled: kIsWeb && !kReleaseMode,
    builder: (context) => const ProviderScope(child: MyApp()),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Flutter Sample Application',
      theme: ThemeData.light(useMaterial3: true).copyWith(
          inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))))),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))))),
      routerDelegate: MainRouterDelegate(ref),
      routeInformationParser: MainRouteInformationParser(ref),
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}
