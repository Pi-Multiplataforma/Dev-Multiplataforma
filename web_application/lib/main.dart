import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(const PoliedroApp());

class PoliedroApp extends StatelessWidget {
  const PoliedroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poliedro • IA de imagens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFE6FAFB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1592A1),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
  leadingWidth: 60,
  leading: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Image.asset(
      'assets/images/logo_poliedro.png',
      height: 36,
      width: 36,
      fit: BoxFit.contain,
    ),
  ),
  title: const Text(' '),
  actions: const [
    _TopLink(text: 'Criar conta'),
    _DividerDot(),
    _TopLink(text: 'Entrar'),
    SizedBox(width: 12),
  ],
),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 28, 18, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá!!! Sou a IA de geração de imagens do Poliedro',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0B5B66),
                  ),
                ),
                const SizedBox(height: 22),
                const _HeroRow(),
                const SizedBox(height: 28),
                Text(
                  'Nossos professores do ensino médio, especialmente nas áreas de '
                  'Física, Matemática e Ciências, frequentemente enfrentam dificuldades '
                  'para encontrar ou produzir imagens educativas com rapidez e qualidade '
                  'adequada para suas aulas, avaliações e materiais didáticos.',
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
                ),
                const SizedBox(height: 26),

                Align(
                  alignment: Alignment.center,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 28,
                    runSpacing: 24,
                    children: [
                      DecorCard(color: const Color(0xFFF4C542), angleDeg: -12),
                      DecorCard(color: const Color(0xFF71D7DC), angleDeg: 0),
                      DecorCard(color: const Color(0xFFE85D6A), angleDeg: 12),
                    ],
                  ),
                ),  

                const SizedBox(height: 26),

                Text(
                  'Então pensamos em uma ferramenta que utiliza Inteligência Artificial '
                  'generativa para criar ilustrações personalizadas. Com base em '
                  'critérios definidos pelo usuário, como tema, estilo visual e nível '
                  'de detalhamento, será possível gerar imagens educativas com rapidez, '
                  'precisão e adequação ao contexto pedagógico.',
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
                ),
                const SizedBox(height: 16),

                Text(
                  'Nossa aplicação será voltada tanto para professores quanto para alunos, '
                  'oferecendo funcionalidades como geração de imagens, visualização em '
                  'galeria, download em diferentes formatos e histórico de criações. '
                  'O objetivo é ampliar o acesso a recursos visuais de qualidade, '
                  'promovendo uma experiência de ensino mais rica, dinâmica e acessível.',
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopLink extends StatelessWidget {
  final String text;
  const _TopLink({required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}

class _DividerDot extends StatelessWidget {
  const _DividerDot();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text('|', style: TextStyle(color: Colors.white70)),
    );
  }
}

class _HeroRow extends StatelessWidget {
  const _HeroRow();

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 720;

    final cube = Image.network(
      'logopoliedro.png',
      height: 150,
      fit: BoxFit.contain,
    );

    final audioBtn = ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Áudio: em breve')));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE85D6A),
        padding: const EdgeInsets.all(14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
      ),
      child: const Icon(Icons.volume_up_rounded, size: 26, color: Colors.white),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: cube),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerRight, child: audioBtn),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Center(child: cube)),
        const SizedBox(width: 12),
        audioBtn,
      ],
    );
  }
}

  class DecorCard extends StatelessWidget {
  final Color color;
  final double angleDeg;
  final double width;
  final double height;

  const DecorCard({
    super.key,
    required this.color,
    this.angleDeg = 0.0,
    this.width = 170,
    this.height = 210,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angleDeg * math.pi / 180,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.black.withOpacity(0.22),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(2, 5),
            ),
          ],
        ),
      ),
    );
  }
}

