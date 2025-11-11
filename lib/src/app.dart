import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pi_dev_multiplataforma/mobile_homescreen.dart';
import '../src/telas/home_page.dart';
import 'package:get/get.dart';
import '../utilities/dependencies.dart' as dependencies;
import '../src/telas/conversa_ia.dart';

import 'dart:io' show Platform;


class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context){
    final bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Página Principal',
      initialBinding: dependencies.InitialBindings(),
  // abre MobileHome em Android/iOS, e HomePage nas outras plataformas
  home: isMobile ? MobileHome() : HomePage(),
      getPages: [
        GetPage(name: '/home_page', page: () => HomePage()),
        GetPage(name: '/conversa_ia', page: () => ConversaIa()), 
        GetPage(name: '/mobile_home', page: () => MobileHome())
      ],
    );
}
}