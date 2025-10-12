import 'package:flutter/material.dart';

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
        leadingWidth: 78,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(width: 12),
            // 👇 ícone no lugar da logo
            Icon(Icons.image_outlined, color: Colors.white, size: 28),
            SizedBox(width: 10),
            // separador vertical
            SizedBox(
              width: 2,
              height: 18,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.white70),
              ),
            ),
          ],
        ),
        title: const Text(' '), // mantém alinhamento como no mock
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
                  style: theme.textTheme.headlineSmall?.copyWith( fontWeight: FontWeight.w800, color: const Color(0xFF0B5B66), ), ),
                Text(
                  'Este site produz imagens educativas com rapidez e qualidade adequada para suas aulas, avaliações e materiais didáticos.',
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
                ),
                const SizedBox(height: 22),
                
              
                const _InstructionRow(),

                const SizedBox(height: 28),

                Text(
                  'Com base em critérios definidos pelo usuário, como tema, estilo visual e nível de detalhamento, será possível gerar imagens educativas com rapidez, precisão e adequação ao contexto pedagógico.',
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
                ),
                const SizedBox(height: 16),
                Text(
                  'Desejamos ampliar o acesso a recursos visuais de qualidade, promovendo uma experiência de ensino mais rica, dinâmica e acessível.',
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

class _InstructionRow extends StatelessWidget {
  const _InstructionRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.circle, color: Colors.blue, size: 16),
            const SizedBox(width: 12),
            const Text('Crie uma conta e entre para conseguir acesso', style: TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.circle, color: Colors.blue, size: 16),
            const SizedBox(width: 12),
            const Text('Descreva a imagem para ser gerada', style: TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.circle, color: Colors.blue, size: 16),
            const SizedBox(width: 12),
            const Text('Suas imagens serão salvas em uma galeria para acesso posterior', style: TextStyle(fontSize: 16)),
          ],
        ),
      ],
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