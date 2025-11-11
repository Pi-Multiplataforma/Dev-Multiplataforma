import 'package:flutter/material.dart';
import 'package:pi_dev_multiplataforma/mobile_homescreen.dart';
import 'package:pi_dev_multiplataforma/src/telas/conversa_ia_mobile.dart';
import '../src/telas/home_page.dart';
import 'package:get/get.dart';
import '../utilities/dependencies.dart' as dependencies;
import '../src/telas/conversa_ia.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'dart:io';


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
    GetPage(name: '/home_page', page: () => HomePage()),
    GetPage(name: '/conversa_ia', page: () => ConversaIa()), 
    GetPage(name: '/mobile_home', page: () => MobileHome())
  ],
);
}
}