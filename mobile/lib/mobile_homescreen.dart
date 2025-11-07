import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Landing',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF23C1C5),
          brightness: Brightness.light,
        ),
      ),
      home: AuthLandingPage(),
    );
  }
}

class AuthLandingPage extends StatelessWidget {
  // ...
  @override
  Widget build(BuildContext context) {const background = Color(0xFF62DDDA);
    const waveColor1 = Color(0xFF53C5C2); // A mais clara
    const waveColor2 = Color(0xFF49B1AE); // Tom intermediário
    const waveColor3 = Color(0xFF409C9A); // A mais escura
    const buttonColor = Color(0xFF26C6CF);

    return Scaffold(
      // CORREÇÃO: Substitua o body inteiro
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Fundo base
          Container(color: const Color.fromARGB(255, 133, 238, 236)),

          // 2. Ondas como Widgets, da mais clara (fundo) para a mais escura (frente)
          ClipPath(
            clipper: WaveClipper1(),
            child: Container(color: const Color.fromARGB(255, 182, 255, 255)),
          ),
          ClipPath(
            clipper: WaveClipper2(),
            child: Container(color: const Color.fromARGB(255, 121, 228, 224)),
          ),
          ClipPath(
            clipper: WaveClipper3(),
            child: Container(color: const Color.fromARGB(255, 89, 219, 217)),
          ),

          // 3. Conteúdo principal (logo e botões) - permanece igual
          SafeArea(
            child: Column(
              // ... seu código da logo e botões continua aqui, sem alterações ...
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
              children: [
                const Spacer(flex: 2), // Empurra o conteúdo para baixo um pouco

                SizedBox(
                  width: 120,
                  height: 120,
                  child: SvgPicture.asset(
                    'assets/images/poliedro_logo.svg',
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 60),
                // Botões
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      _PrimaryButton(
                        label: 'Entrar',
                        color: buttonColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                          );
                        },
                      ),

                      const SizedBox(height: 16), 

                      _PrimaryButton(
                        label: 'Criar conta',
                        color: buttonColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SignUpPage()),
                          );
                        },
                      ),

                    ],
                  ),
                ),
                const Spacer(flex: 4), // Dá mais espaço na parte de baixo
              ],
            ),
          ),
        ],
      ),
    );
  }
}
/// Botão grande, arredondado, com sombra suave.
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 3,
          backgroundColor: color,
          foregroundColor: Colors.white,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

// --- AJUSTE FINAL DOS CLIPPERS ---

// Onda 1 (A mais clara, mais à direita no desenho)
class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Segue a linha preta mais à direita
    return Path()
      ..moveTo(size.width * 0.1, 0) // Começa no topo, um pouco para a direita
      ..cubicTo(
        size.width * 0.5, size.height * 0.2, // 1. Curva para a direita
        size.width * 0.2, size.height * 0.5, // 2. Curva de volta para a esquerda no meio
        size.width * 0.7, size.height * 0.6, // 3. Curva para a direita, passando pelo centro
      )
      // --- AJUSTE FINAL NESTA CURVA ---
      ..quadraticBezierTo(
        // Curva simples que continua o fluxo para baixo e para a direita
        size.width * 1.1, size.height * 0.8, // Ponto de controle fora da tela para forçar a direção
        size.width, size.height,             // Termina no canto inferior direito
      )
      ..lineTo(size.width, 0) // Linha pela borda direita até o topo
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// Onda 2 (Tom intermediário, no meio do desenho)
class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Segue a linha preta do meio
    return Path()
      ..moveTo(0, size.height * 0.25) // Começa na borda esquerda, um pouco para baixo
      ..cubicTo(
        size.width * 0.3, size.height * 0.35, // 1. Curva para a direita
        size.width * 0.1, size.height * 0.6,  // 2. Curva de volta para a esquerda
        size.width * 0.5, size.height * 0.7,  // 3. Curva para o centro
      )
      ..cubicTo(
        size.width * 0.8, size.height * 0.8, // 4. Curva para a direita
        size.width * 0.5, size.height,       // 5. Curva para a base
        size.width * 0.8, size.height,       // 6. Termina na base, a 80%
      )
      ..lineTo(0, size.height) // Linha pela borda inferior
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// Onda 3 (A mais escura, mais à esquerda no desenho)
class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {    // Segue a linha preta mais à esquerda
    return Path()
      // AJUSTE FINAL: Começa mais abaixo na borda esquerda, e não no topo.
      ..moveTo(0, size.height * 0.4) // ANTES: ..moveTo(0, 0)
      ..cubicTo(
        size.width * 0.1, size.height * 0.45, // 1. Curva inicial
        size.width * 0.0, size.height * 0.7,  // 2. Curva bem para a esquerda
        size.width * 0.3, size.height * 0.8,  // 3. Curva para o centro
      )
      ..cubicTo(
        size.width * 0.5, size.height * 0.9,   // 4. Curva para a direita
        size.width * 0.2, size.height * 1.0,   // 5. Curva para baixo
        size.width * 0.45, size.height,       // 6. Termina na base, a 45%
      )
      ..lineTo(0, size.height) // Linha pela borda inferior
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

