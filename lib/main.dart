import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'logic/ludia.dart';
import 'screen/home/home.dart';
import 'shared/apptheme.dart';
import 'shared/constants.dart';

void main() async {
  // futter
  WidgetsFlutterBinding.ensureInitialized();

  // app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LudiaLogic>(create: (_) => LudiaLogic())
      ],
      child: DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDaynamic) {
        return MaterialApp(
          title: appName,
          theme: AppTheme.lightTheme(lightDynamic),
          darkTheme: AppTheme.darkTheme(darkDaynamic),
          home: const HomePage(),
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
