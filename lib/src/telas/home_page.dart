import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import '../../utilities/dependencies.dart';
import 'package:get/get.dart';
import 'conversa_ia.dart';



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: minhaBarra(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
            textoPrincipal(context),
            SizedBox(height: 60),
            imagemPoliedro(context),
            SizedBox(height: 60),
            texto1(context),
            SizedBox(height: 60),
            tutorial1(context),
            SizedBox(height: 40),
            tutorial2(context),
            SizedBox(height: 40),
            tutorial3(context),
            SizedBox(height: 60),
            texto2(context),
            SizedBox(height: 40),
            texto3(context),
            SizedBox(height: 100),
            footer(context),
          ],
        ),
      ),
    );
  }
}

PreferredSizeWidget minhaBarra(BuildContext context) {
  return AppBar(
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
      showDialog(
        context: context,
        builder: (context) => cadastroPopup(context),
      );
    },
    child: HoverWidget(
      onHover: (event) {},
      hoverChild: const Text(
        'Criar Conta',
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
        'Criar Conta',
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
      showDialog(
        context: context,
        builder: (context) => loginPopup(context),
      );
    },
    child: HoverWidget(
      onHover: (event) {}, // obrigatório
      hoverChild: const Text(
        'Entrar',
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
        'Entrar',
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


final TextEditingController emailLoginController = TextEditingController();
final TextEditingController senhaLoginController = TextEditingController();

Widget loginPopup(BuildContext context) {
  final authController = Get.find<AuthController>();

  return AlertDialog(
    backgroundColor: const Color.fromARGB(255, 239, 239, 239),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: Colors.white, width: 3),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF2DC7CD)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              controller: emailLoginController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Email',
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF2DC7CD)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              controller: senhaLoginController,
              obscureText: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Senha',
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    ),
    actions: [
      ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2DC7CD),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Cancelar',
          style: TextStyle(
            fontFamily: 'Inria Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ElevatedButton(
        onPressed: () async {
          final email = emailLoginController.text.trim();
          final senha = senhaLoginController.text.trim();

          if (email.isEmpty || senha.isEmpty) {
            Get.snackbar('Erro', 'Preencha todos os campos',
              backgroundColor: Colors.red, colorText: Colors.white);
            return;
          }

          final resultado = await authController.signIn(email, senha);

          if (resultado == 'sucess') {

            Get.snackbar('Bem-vindo', 'Login realizado com sucesso!',
              backgroundColor: Colors.green, colorText: Colors.white);
            emailLoginController.clear();
            senhaLoginController.clear();
            Navigator.pop(context);
            Get.offNamed('/conversa_ia');
          } else {
            final mensagemErro = resultado.contains('Instance of')
              ? 'Erro ao fazer login.'
              : resultado;

            Get.snackbar('Erro ao entrar', mensagemErro,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2DC7CD),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Entrar',
          style: TextStyle(
            fontFamily: 'Inria Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}





RxString status = 'enter-details'.obs;

final TextEditingController nomeController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController senhaController = TextEditingController();


Widget cadastroPopup(BuildContext context) {
  final authController = Get.find<AuthController>();

  return AlertDialog(
    backgroundColor: const Color.fromARGB(255, 239, 239, 239),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: Colors.white, width: 3),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF2DC7CD)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              controller: nomeController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Usuário',
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF2DC7CD)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              controller: emailController,
              obscureText: false,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Email',
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF2DC7CD)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Senha',
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    ),
    actions: [
      ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2DC7CD),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Cancelar',
          style: TextStyle(
            fontFamily: 'Inria Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ElevatedButton(
        onPressed: () async {
          final nome = nomeController.text.trim();
          final email = emailController.text.trim();
          final senha = senhaController.text.trim();

          if (nome.isEmpty && email.isEmpty && senha.isEmpty) {
            Get.snackbar('Erro', 'Preencha todos os campos',
              backgroundColor: Colors.red, colorText: Colors.white);
            return;
          }

          final resultado = await authController.createAccount(nome, email, senha);

          if (resultado == 'sucess') {
            Get.snackbar('Sucesso', 'Conta criada com sucesso!',
              backgroundColor: Colors.green, colorText: Colors.white);
            nomeController.clear();
            emailController.clear();
            senhaController.clear();
            Navigator.pop(context);
          } else {
  final mensagemErro = resultado.contains('Instance of')
      ? 'Erro ao criar conta.'
      : resultado;

  Get.snackbar('Erro ao cadastrar', mensagemErro,
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}

        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2DC7CD),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Cadastrar',
          style: TextStyle(
            fontFamily: 'Inria Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}


Widget textoPrincipal(BuildContext context) {
  double largura = MediaQuery.of(context).size.width;

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: largura * 0.9,
        child: Text(
          'Olá!!! Sou a IA de geração de imagens do Poliedro',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Inria Sans",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    ],
  );
}

Widget imagemPoliedro(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Flexible(
        child: SvgPicture.asset('assets/poliedro_logo.svg', height: 220),
      ),
    ],
  );
}

Widget texto1(BuildContext context) {
  double largura = MediaQuery.of(context).size.width;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: largura * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Este site produz imagens educativas com rapidez e qualidade adequada para suas aulas, avaliações e materiais didáticos.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Inria Sans",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    ],
  );
}

Widget tutorial1(BuildContext context) {
  double largura = MediaQuery.of(context).size.width;

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: largura * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF2DC7CD),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                'Crie uma conta e entre para conseguir usar a ferramenta;',
                style: const TextStyle(
                  fontFamily: "Inria Sans",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget tutorial2(BuildContext context) {
  double largura = MediaQuery.of(context).size.width;

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: largura * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF2DC7CD),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                'Descreva a imagem para ser gerada;',
                style: const TextStyle(
                  fontFamily: "Inria Sans",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget tutorial3(BuildContext context) {
  double largura = MediaQuery.of(context).size.width;

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: largura * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF2DC7CD),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                'Suas imagens desejadas serão salvas em uma galeria para acesso posterior;',
                style: const TextStyle(
                  fontFamily: "Inria Sans",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget texto2(BuildContext context) {
  double largura = MediaQuery.of(context).size.width;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: largura * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Com base em critérios definidos pelo usuário, como tema, estilo visual e nível de detalhamento, será possível gerar imagens educativas com rapidez, precisão e adequação ao contexto pedagógico.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Inria Sans",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    ],
  );
}

Widget texto3(BuildContext context) {
  double largura = MediaQuery.of(context).size.width;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: largura * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: Text(
          'Desejamos ampliar o acesso a recursos visuais de qualidade, promovendo uma experiência de ensino mais rica, dinâmica e acessível.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Inria Sans",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    ],
  );
}

Widget footer(BuildContext context) {
  return Container(
    width: double.infinity,
    color: Color(0xff222222),
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 30),
              child: SvgPicture.asset(
                'assets/poliedro_logo.svg',

                width: 60,
                height: 60,
              ),
            ),

            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Navegação',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Página principal',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Chat de geração de imagens',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Text('Galeria', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            SizedBox(width: 20),

            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Serviços',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Termos e condições',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            SizedBox(width: 20),

            Flexible(
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'redes sociais',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/instagram_icon.svg',
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 15),
                SvgPicture.asset(
                  'assets/facebook_icon.svg',
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 15),
                SvgPicture.asset(
                  'assets/youtube_icon.svg',
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ],
        ),
            ),
          ],
        ),
      ],
    ),
  );
}
