import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class MobileHome extends StatelessWidget {
  const MobileHome({super.key});

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
  @override
  Widget build(BuildContext context) {const background = Color(0xFF62DDDA);
    const waveColor1 = Color(0xFF53C5C2);
    const waveColor2 = Color(0xFF49B1AE);
    const waveColor3 = Color(0xFF409C9A);
    const buttonColor = Color(0xFF26C6CF);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: const Color.fromARGB(255, 133, 238, 236)),

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

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
              children: [
                const Spacer(flex: 2),

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

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width * 0.1, 0)
      ..cubicTo(
        size.width * 0.5, size.height * 0.2,
        size.width * 0.2, size.height * 0.5,
        size.width * 0.7, size.height * 0.6, 
      )
      ..quadraticBezierTo(
        size.width * 1.1, size.height * 0.8,
        size.width, size.height,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, size.height * 0.25)
      ..cubicTo(
        size.width * 0.3, size.height * 0.35,
        size.width * 0.1, size.height * 0.6,
        size.width * 0.5, size.height * 0.7,
      )
      ..cubicTo(
        size.width * 0.8, size.height * 0.8, 
        size.width * 0.5, size.height,       
        size.width * 0.8, size.height,       
      )
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) { 
    return Path()
      ..moveTo(0, size.height * 0.4) 
      ..cubicTo(
        size.width * 0.1, size.height * 0.45, 
        size.width * 0.0, size.height * 0.7, 
        size.width * 0.3, size.height * 0.8, 
      )
      ..cubicTo(
        size.width * 0.5, size.height * 0.9,
        size.width * 0.2, size.height * 1.0,
        size.width * 0.45, size.height,
      )
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

