import 'package:flutter/material.dart';
import 'package:member/providers/auth_provider.dart';
import 'package:member/screens/home_screen.dart';
import 'package:member/screens/login_screen.dart';
import 'package:member/screens/register_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        title: 'Member App',
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (context) => HomeScreen(),
          "/register": (context) => RegisterScreen(),
          "/home": (context) => HomeScreen()
        },
      ),
    );
  }
}
