import 'package:client/client.dart';
import 'package:flutter/material.dart';

void main() {
  setUpDependencies();
  runApp(const BDUIApp());
}

class BDUIApp extends StatelessWidget {
  const BDUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Challenges - BDUI',
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const BDUIHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
