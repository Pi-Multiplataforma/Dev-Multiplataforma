import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utilities/dependencies.dart';
import '../../utilities/urlImagens.dart';

class GaleriaTela extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final TextEditingController buscaController = TextEditingController();
  final RxString termoBusca = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minha Galeria',
          style: TextStyle(
            fontFamily: 'Inria Sans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF2DC7CD),
        iconTheme: IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: buscaController,
              onChanged: (value) => termoBusca.value = value.toLowerCase(),
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        final Map<String, dynamic> imagens =
            authController.user['images'] ?? {};
        final busca = termoBusca.value;

        final imagensFiltradas = imagens.entries
            .where((entry) => entry.key.toLowerCase().contains(busca))
            .toList();

        if (imagensFiltradas.isEmpty) {
          return Center(child: Text('Nenhuma imagem encontrada.'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300.0,
            mainAxisExtent: 300.0,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: imagensFiltradas.length,
          itemBuilder: (context, index) {
            final entry = imagensFiltradas[index];
            final imageUrl = resolveImageUrl(entry.value);

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
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: Text('Erro ao carregar imagem'),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 60,
                            right: 16,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(16),
                                backgroundColor: const Color.fromARGB(255, 75, 221, 49), 
                                elevation: 4,
                              ),
                              child: Icon(
                                Icons.download, 
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: ElevatedButton(
                              onPressed: () async {
  final sucesso = await authController.deleteImageFromUser(entry.key);
  if (sucesso) {
    Navigator.of(context).pop();
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
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(16),
                                backgroundColor: Colors.red, 
                                elevation: 4,
                              ),
                              child: Icon(
                                Icons.delete, 
                                color: Colors.white,
                                size: 20,
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
                          child: Center(child: Text('Erro')),
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
