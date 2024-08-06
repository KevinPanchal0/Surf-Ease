import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_ease/pages/bookmark_page.dart';
import 'package:surf_ease/pages/home_page.dart';
import 'package:surf_ease/provider/bookmark_provider.dart';
import 'package:surf_ease/provider/connectivity_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookmarkProvider()),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'homePage',
      routes: {
        'homePage': (context) => const HomePage(),
        'bookMark': (context) => const BookmarkPage(),
      },
    );
  }
}
