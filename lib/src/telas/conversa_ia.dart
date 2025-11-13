import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import '../../utilities/dependencies.dart';
import 'package:get/get.dart';
import '../../utilities/urlImagens.dart';
import '../telas/galeria.dart';

class ConversaIa extends StatefulWidget {
  @override
  _ConversaIaState createState() => _ConversaIaState();
}

class _ConversaIaState extends State<ConversaIa> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, String?>> mensagens = [];

  void responder() async {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      mensagens.add({'prompt': prompt, 'imageUrl': null});
      _controller.clear();
    });

    final authController = Get.find<AuthController>();
    final result = await authController.generateImage(prompt);

    if (result['success']) {
      final url = result['url'];

      setState(() {
        final index = mensagens.lastIndexWhere(
          (m) => m['prompt'] == prompt && m['imageUrl'] == null,
        );
        if (index != -1) {
          mensagens[index] = {'prompt': prompt, 'imageUrl': url};
        }
      });
    } else {
      setState(() {
        mensagens.removeWhere(
          (m) => m['prompt'] == prompt && m['imageUrl'] == null,
        );
      });
      Get.snackbar('Erro ao gerar imagem, tente novamente', result['error']);
    }
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
                final item = mensagens[index];
                final imageUrl = item['imageUrl'];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFF2DC7CD),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          item['prompt'] ?? '',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: imageUrl == null
                                  ? Container(
                                      width: 350,
                                      height: 350,
                                      color: const Color.fromARGB(
                                        0,
                                        255,
                                        255,
                                        255,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Color(0xFF2DC7CD),
                                              ),
                                        ),
                                      ),
                                    )
                                  : Image.network(
                                      resolveImageUrl(imageUrl),
                                      width: 350,
                                      height: 350,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Text('Erro: $error');
                                          },
                                    ),
                            ),
                            const SizedBox(width: 12),
                            if (imageUrl != null)
                              CircleAvatar(
                                backgroundColor: Color(0xFF2DC7CD),
                                child: IconButton(
                                  icon: Icon(Icons.add, color: Colors.white),
                                  onPressed: () {
                                    final chaveController =
                                        TextEditingController();
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Salvar imagem'),
                                          content: TextField(
                                            controller: chaveController,
                                            decoration: InputDecoration(
                                              labelText: 'Chave da imagem',
                                              hintText:
                                                  'Ex: perfil, capa, documento...',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(
                                                context,
                                              ).pop(), 
                                              child: Text('Cancelar'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final chave = chaveController
                                                    .text
                                                    .trim();
                                                if (chave.isEmpty) {
                                                  Get.snackbar(
                                                    'Chave obrigatória',
                                                    'Digite uma chave para salvar a imagem.',
                                                    backgroundColor:
                                                        Colors.orange,
                                                    colorText: Colors.white,
                                                  );
                                                  return;
                                                }

                                                Navigator.of(
                                                  context,
                                                ).pop(); 

                                                final sucesso =
                                                    await Get.find<
                                                          AuthController
                                                        >()
                                                        .addImageToUser(
                                                          chave,
                                                          imageUrl,
                                                        );

                                                if (sucesso) {
                                                  Get.snackbar(
                                                    'Imagem salva',
                                                    'A imagem foi adicionada com a chave "$chave".',
                                                    backgroundColor:
                                                        Colors.green,
                                                    colorText: Colors.white,
                                                  );
                                                } else {
                                                  Get.snackbar(
                                                    'Erro',
                                                    'Não foi possível salvar a imagem.',
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white,
                                                  );
                                                }
                                              },
                                              child: Text('Salvar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
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
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: responder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2DC7CD),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GaleriaTela()),
                );
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
                onHover: (event) {},
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
}
