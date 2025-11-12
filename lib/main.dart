import 'dart:html' as html;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'src/app.dart';

import 'dart:ui_web' as ui;


void main() {
  if (kIsWeb) {
    _registerGeoGebraHtmlElement();
  }

  runApp(App());
}
void _registerGeoGebraHtmlElement() {
  ui.platformViewRegistry.registerViewFactory(
    'geogebra-element',
    (int viewId) {
      final div = html.DivElement()..id = 'ggb-element';
      _injectGeoGebra();
      return div;
    },
  );
}


void _injectGeoGebra() {
  final script = html.ScriptElement()
    ..innerHtml = """
      var ggbApplet;
      var params = {
        appName: "graphing",
        width: 800,
        height: 600,
        showToolBar: true,
        showMenuBar: true,
        showAlgebraInput: true,
      };
      ggbApplet = new GGBApplet(params, true);
      ggbApplet.inject('ggb-element');
    """;

  html.document.body?.append(script);
}
