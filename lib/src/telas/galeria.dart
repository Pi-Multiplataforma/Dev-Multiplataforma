import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utilities/dependencies.dart';

class GaleriaTela extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final TextEditingController buscaController = TextEditingController();
  final RxString termoBusca = ''.obs;


  GaleriaTela({super.key}) {
    authController.carregarGaleria(); // carrega a galeria ao abrir a tela
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minha Galeria',
          style: TextStyle(
            fontFamily: 'Inria Sans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2DC7CD),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: buscaController,
              onChanged: (value) => termoBusca.value = value.toLowerCase(),
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        final busca = termoBusca.value;
  final imagens = authController.galeria;

  final imagensFiltradas = imagens
      .where((img) => (img['key'] ?? '').toLowerCase().contains(busca))
      .toList();



        if (imagensFiltradas.isEmpty) {
          return const Center(child: Text('Nenhuma imagem encontrada.'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300.0,
            mainAxisExtent: 300.0,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: imagensFiltradas.length,
          itemBuilder: (context, index) {
            final img = imagensFiltradas[index];
            final imageUrl = img['url'];
            final key = img['key'];

            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    content: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                padding: const EdgeInsets.all(20),
                                child: const Center(
                                  child: Text('Erro ao carregar imagem'),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 65,
                            right: 16,
                            child: ElevatedButton(
                              onPressed: () {
   
  },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                                backgroundColor: Colors.green,
                                elevation: 4,
                              ),
                              child: const Icon(
                                Icons.download,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: ElevatedButton(
                              onPressed: () async {
                                final sucesso = await authController.deleteImageFromUser(key);
                                if (sucesso) {
                                  Navigator.of(context).pop();
                                  authController.carregarGaleria(); // atualiza após excluir
                                  Get.snackbar('Imagem excluída', 'A imagem foi removida de sua galeria.',
                                    backgroundColor: const Color.fromARGB(255, 34, 218, 46),
                                    colorText: Colors.white,
                                  );
                                } else {
                                  Get.snackbar('Erro', 'Não foi possível excluir a imagem.',
                                    backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                                    colorText: Colors.white,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                                backgroundColor: Colors.red,
                                elevation: 4,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(child: Text('Erro')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
