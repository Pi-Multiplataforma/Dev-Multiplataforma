import 'package:flutter/material.dart';
import '../src/telas/home_page.dart';
import 'package:get/get.dart';
import '../utilities/dependencies.dart' as dependencies;
import '../src/telas/conversa_ia.dart';


class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context){
    return GetMaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Página Principal',
  initialBinding: dependencies.InitialBindings(),
  initialRoute: '/',
  getPages: [
    GetPage(name: '/', page: () => HomePage()),
    GetPage(name: '/conversa_ia', page: () => ConversaIa()), 
  ],
);
}
}