import 'package:flutter/material.dart';
import 'package:s25_module_b/HomeTab.dart';
import 'package:s25_module_b/pages/HomePage.dart';
import 'package:s25_module_b/pages/OnboardingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: isLoggedIn ? HomeTab() : OnboardingPage(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: null);
  }
}
