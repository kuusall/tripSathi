import 'package:minor/home-screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const MaterialColor kToDark = MaterialColor(
      0xFF1BC0C5, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
      <int, Color>{
        50: Color(0xFF1BC0C5), //10%
        100: Color(0xFF1BC0C5), //20%
        200: Color(0xFF1BC0C5), //30%
        300: Color(0xFF1BC0C5), //40%
        400: Color(0xFF1BC0C5), //50%
        500: Color(0xFF1BC0C5), //60%
        600: Color(0xFF1BC0C5), //70%
        700: Color(0xFF1BC0C5), //80%
        800: Color(0xFF1BC0C5), //90%
        900: Color(0xFF1BC0C5), //100%
      },
    );
    return MaterialApp(
      title: 'Trip Expensive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: IconThemeData(color: Color(0xFF1BC0C5)),
        primaryTextTheme:
            TextTheme(headlineMedium: TextStyle(color: Colors.black)),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        primarySwatch: kToDark,
        textTheme: Theme.of(context).textTheme.apply(
              displayColor: Colors.black,
              bodyColor: Colors.black87,
            ),
      ),
      home: HomeScreen(),
    );
  }
}
