import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

String getBaseUrl() {
  if (kIsWeb) {
    // Para rodar no navegador (localhost funciona direto)
    return 'http://localhost:3000';
  } else if (Platform.isAndroid) {
    // Para Android Emulator → localhost da máquina host é 10.0.2.2
    return 'http://10.0.2.2:3000';
  } else if (Platform.isIOS) {
    // Para iOS Simulator → localhost funciona
    return 'http://localhost:3000';
  } else {
    // Para dispositivos físicos → use o IP da máquina na rede
    return 'http://192.168.0.15:3000'; // substitua pelo IP do seu PC
  }
}
