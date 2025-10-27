import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pregnancy & Baby Care',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      home: const Scaffold(
        body: Center(
          child: Text('Pregnancy & Baby App'),
        ),
      ),
    );
  }
}