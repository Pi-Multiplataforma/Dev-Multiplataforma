import 'package:flutter/material.dart';
import '../src/telas/home_page.dart';

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Página Principal',
      home: Scaffold(body: HomePage(),
      ),
    );
  }
}