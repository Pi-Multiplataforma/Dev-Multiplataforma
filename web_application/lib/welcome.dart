// import 'package:flutter/material.dart';

// class LandingPage extends StatelessWidget {
//   const LandingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leadingWidth: 78,
//         leading: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: const [
//             SizedBox(width: 12),
//             Icon(Icons.image_outlined, color: Colors.white, size: 28),
//             SizedBox(width: 10),
//             SizedBox(width: 2, height: 18, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white70))),
//           ],
//         ),
//         title: const Text(''),
//         actions: const [
//           _TopLink(text: 'Minha galeria'),
//           _DividerDot(),
//           _TopLink(text: 'Sair'),
//           SizedBox(width: 12),
//         ],
//       ),
//       body: Center(
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 980),
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.fromLTRB(18, 28, 18, 40),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Olá!!! Sou a IA de geração de imagens do Poliedro',
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                     fontWeight: FontWeight.w800,
//                     color: const Color(0xFF0B5B66),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



// class _TopLink extends StatelessWidget {
//   final String text;
//   const _TopLink({required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () {}, // ligar depois
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }

// class _DividerDot extends StatelessWidget {
//   const _DividerDot({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8),
//       child: Text('|', style: TextStyle(color: Colors.white70)),
//     );
//   }
// }
