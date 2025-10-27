import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import '../../utilities/dependencies.dart';
import 'package:get/get.dart';

class ConversaIa extends StatefulWidget {
  @override
  _ConversaIaState createState() => _ConversaIaState();
}

class _ConversaIaState extends State<ConversaIa> {
  TextEditingController _controller = TextEditingController();
  List<String> mensagens = [];

  void responder() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      mensagens.add(_controller.text);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: minhaBarraIa(context),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mensagens.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Align(
                    alignment: Alignment.centerRight, // 👈 Alinha à direita
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF2DC7CD), // cor de fundo da mensagem
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        mensagens[index],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: responder,
                  child: Text('Enviar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




PreferredSizeWidget minhaBarraIa(BuildContext context) {
  return AppBar(
     automaticallyImplyLeading: false,
    elevation: 8,
    shadowColor: Colors.black,
    backgroundColor: const Color(0xFF2DC7CD),
    title: Row(
      children: [
        SvgPicture.asset(
          'assets/poliedro_logo.svg',
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          width: 35,
          height: 35,
        ),
        const Spacer(),

        MouseRegion(
  cursor: SystemMouseCursors.click,
  child: GestureDetector(
    onTap: () {
      
    },
    child: HoverWidget(
      onHover: (event) {},
      hoverChild: const Text(
        'Galeria',
        style: TextStyle(
          fontFamily: 'Inria Sans',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(0, 0),
              blurRadius: 8,
              color: Colors.black45,
            ),
          ],
        ),
      ),
      child: const Text(
        'Galeria',
        style: TextStyle(
          fontFamily: 'Inria Sans',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ),
),

        const SizedBox(width: 10),
        Container(height: 30, width: 3, color: Colors.white),
        const SizedBox(width: 10),

        MouseRegion(
  cursor: SystemMouseCursors.click,
  child: GestureDetector(
    onTap: () {
  final authController = Get.find<AuthController>();
  authController.signOut();
},

    child: HoverWidget(
      onHover: (event) {}, // obrigatório
      hoverChild: const Text(
        'Sair',
        style: TextStyle(
          fontFamily: 'Inria Sans',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(0, 0),
              blurRadius: 8,
              color: Colors.black45,
            ),
          ],
        ),
      ),
      child: const Text(
        'Sair',
        style: TextStyle(
          fontFamily: 'Inria Sans',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ),
),
      ],
    ),
  );
}