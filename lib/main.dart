import 'package:currency_converter/core/dependency_injection.dart' as di;
import 'package:currency_converter/core/routes/app_router.dart';
import 'package:currency_converter/features/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initInjections();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRouter.generatedRoute,
      initialRoute: HomeScreen.routeName,
    );
  }
}
