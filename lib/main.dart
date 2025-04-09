import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Views/home_view.dart';
import 'providers/show_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShowProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Shows App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomeView(),
    );
  }
}
