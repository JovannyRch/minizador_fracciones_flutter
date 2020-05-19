import 'package:flutter/material.dart';
import 'package:minimizador_fracciones/calculator_screen.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Simplificar Fracciones',
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}
