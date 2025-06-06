import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:s25_module_b/HomeTab.dart';
import 'package:s25_module_b/pages/OnboardingPage.dart';
import 'package:s25_module_b/providers/CartProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(initialPage: isLoggedIn ? HomeTab() : OnboardingPage()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget initialPage;

  const MyApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: initialPage);
  }
}
